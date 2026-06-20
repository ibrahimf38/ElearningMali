import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

/// Affiche un PDF en lecture seule depuis une URL S3.
///
/// IMPORTANT (confidentialité du contenu) :
/// - Aucune option de partage/téléchargement n'est exposée.
/// - Le fichier est mis en cache temporaire (dossier "cache" de l'app,
///   purgé par l'OS) uniquement pour permettre le rendu par `pdfx`,
///   et n'est jamais accessible depuis l'espace de stockage visible
///   par l'utilisateur (Téléchargements, Galerie, etc.).
class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String titre;

  const PdfViewerScreen({
    super.key,
    required this.url,
    required this.titre,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfControllerPinch? _controller;
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      // Télécharge le PDF dans le cache temporaire de l'app uniquement.
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode != 200) {
        throw Exception('Impossible de charger le document (${response.statusCode})');
      }

      final cacheDir = await getTemporaryDirectory();
      final file = File(
          '${cacheDir.path}/lecture_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(response.bodyBytes);

      final document = PdfDocument.openFile(file.path);

      setState(() {
        _controller = PdfControllerPinch(document: document);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement du document.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.titre,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        // Pas d'icônes de partage/téléchargement (lecture seule).
        actions: [
          if (_totalPages > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 56, color: Color(0xFF9E9E9E)),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadPdf();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    return PdfViewPinch(
      controller: _controller!,
      onDocumentLoaded: (document) {
        setState(() => _totalPages = document.pagesCount);
      },
      onPageChanged: (page) {
        setState(() => _currentPage = page);
      },
    );
  }
}