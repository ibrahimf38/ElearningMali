import 'package:flutter/material.dart';
import '../models/library_models.dart';
import '../services/contenu_service.dart';
import 'brochure_screen.dart' show BrochureCard;
import 'pdf_viewer_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        _error = 'Impossible de charger les sujets d\'examen. Vérifiez votre connexion et réessayez.';
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
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header vert avec retour ──────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              decoration: BoxDecoration(
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
                    child: Icon(Icons.arrow_back,
                        color: Color(0xFF1A1A2E), size: 24.sp),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "Sujets d'examen",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            // ── Recherche ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Recherche les sujets',
                  hintStyle:
                      TextStyle(color: Color(0xFF9E9E9E), fontSize: 14.sp),
                  prefixIcon:
                      Icon(Icons.search, color: Color(0xFF2E7D32)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                        color: Color(0xFF2E7D32), width: 1.5.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide:
                        BorderSide(color: Color(0xFF2E7D32), width: 2.r),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                        color: Color(0xFF2E7D32), width: 1.5.r),
                  ),
                ),
              ),
            ),

            // ── Titre ─────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
              child: Text(
                "Sujets d'examen",
                style: TextStyle(
                  fontSize: 18.sp,
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
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48.sp, color: Color(0xFF9E9E9E)),
              SizedBox(height: 10.h),
              Text(_error!, style: const TextStyle(color: Color(0xFF6B7280))),
              SizedBox(height: 12.h),
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
      padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 16.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14.w,
        crossAxisSpacing: 14.w,
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
