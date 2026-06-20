import 'package:flutter/material.dart';
import '../models/library_models.dart';
import '../services/contenu_service.dart';
import 'brochure_screen.dart' show BrochureCard;
import 'pdf_viewer_screen.dart';

class SujetsExamenScreen extends StatefulWidget {
  const SujetsExamenScreen({super.key});

  @override
  State<SujetsExamenScreen> createState() => _SujetsExamenScreenState();
}

class _SujetsExamenScreenState extends State<SujetsExamenScreen> {
  final ContenuService _service = ContenuService();
  String _searchQuery = '';
  List<BrochureModel> _sujets = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final sujets = await _service.getSujetsExamen();
      setState(() {
        _sujets = sujets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Impossible de charger les sujets d'examen";
        _isLoading = false;
      });
    }
  }

  List<BrochureModel> get _filtered {
    if (_searchQuery.isEmpty) return _sujets;
    final q = _searchQuery.toLowerCase();
    return _sujets
        .where((s) =>
            s.titre.toLowerCase().contains(q) ||
            s.sousTitre.toLowerCase().contains(q) ||
            s.editeur.toLowerCase().contains(q) ||
            '${s.annee}'.contains(q))
        .toList();
  }

  void _openPdf(BrochureModel sujet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(
          url: sujet.urlFichier,
          titre: sujet.titre,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header vert avec retour ──────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Color(0xFF7A9E7E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Color(0xFF1A1A2E), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Sujets d'examen",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            // ── Recherche ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Recherche les sujets',
                  hintStyle: const TextStyle(
                      color: Color(0xFF9E9E9E), fontSize: 14),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF2E7D32)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF2E7D32), width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                  ),
                ),
              ),
            ),

            // ── Titre ─────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                "Sujets d'examen",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),

            // ── Grille ────────────────────────────────────────
            Expanded(
              child: _buildGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
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
                  size: 48, color: Color(0xFF9E9E9E)),
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Color(0xFF6B7280))),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _load,
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
    if (_filtered.isEmpty) {
      return const Center(
        child: Text(
          'Aucun sujet trouvé',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        return BrochureCard(
          brochure: _filtered[index],
          onTap: () => _openPdf(_filtered[index]),
        );
      },
    );
  }
}