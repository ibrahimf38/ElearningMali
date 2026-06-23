// import 'package:flutter/material.dart';
// import '../models/cours_model_api.dart';
// import '../services/contenu_service.dart';
// import 'pdf_viewer_screen.dart';

// /// Page affichant la liste des leçons/cours d'une matière
// /// (ex: "Language") sous forme de grille de cards.
// ///
// /// Arguments attendus (via Navigator) :
// ///   { 'idMatiere': int, 'nomMatiere': String }
// class MatiereDetailScreen extends StatefulWidget {
//   const MatiereDetailScreen({super.key});

//   @override
//   State<MatiereDetailScreen> createState() => _MatiereDetailScreenState();
// }

// class _MatiereDetailScreenState extends State<MatiereDetailScreen> {
//   final ContenuService _service = ContenuService();
//   final _searchController = TextEditingController();

//   List<CoursModel> _cours = [];
//   bool _isLoading = true;
//   String? _error;
//   String _searchQuery = '';

//   String _nomMatiere = '';
//   int _idMatiere = 0;
//   bool _initialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       final args = ModalRoute.of(context)!.settings.arguments
//           as Map<String, dynamic>?;
//       _idMatiere = args?['idMatiere'] as int? ?? 0;
//       _nomMatiere = args?['nomMatiere'] as String? ?? 'Matière';
//       _initialized = true;
//       _loadCours();
//     }
//   }

//   Future<void> _loadCours() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       final cours = await _service.getCoursByMatiere(_idMatiere);
//       setState(() {
//         _cours = cours;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Impossible de charger les leçons.';
//         _isLoading = false;
//       });
//     }
//   }

//   List<CoursModel> get _filtered {
//     if (_searchQuery.isEmpty) return _cours;
//     final q = _searchQuery.toLowerCase();
//     return _cours
//         .where((c) =>
//             c.titre.toLowerCase().contains(q) ||
//             c.sousTitre.toLowerCase().contains(q))
//         .toList();
//   }

//   void _openPdf(CoursModel cours) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => PdfViewerScreen(
//           url: cours.urlFichier,
//           titre: cours.titre,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Header vert avec retour ──────────────────────
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//               decoration: const BoxDecoration(
//                 color: Color(0xFF7A9E7E),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(24),
//                   bottomRight: Radius.circular(24),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(Icons.arrow_back,
//                         color: Color(0xFF1A1A2E), size: 24),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     _nomMatiere,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1A1A2E),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // ── Recherche ─────────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: (v) => setState(() => _searchQuery = v),
//                 decoration: InputDecoration(
//                   hintText: 'Recherche les lecons',
//                   hintStyle: const TextStyle(
//                       color: Color(0xFF9E9E9E), fontSize: 14),
//                   prefixIcon:
//                       const Icon(Icons.search, color: Color(0xFF2E7D32)),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                       const EdgeInsets.symmetric(vertical: 12),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide:
//                         const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide:
//                         const BorderSide(color: Color(0xFF2E7D32), width: 2),
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide:
//                         const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
//                   ),
//                 ),
//               ),
//             ),

//             // ── Grille de cards ───────────────────────────────
//             Expanded(
//               child: _buildContent(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContent() {
//     if (_isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
//       );
//     }

//     if (_error != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.error_outline_rounded,
//                   size: 48, color: Color(0xFF9E9E9E)),
//               const SizedBox(height: 10),
//               Text(_error!,
//                   style: const TextStyle(color: Color(0xFF6B7280))),
//               const SizedBox(height: 12),
//               ElevatedButton(
//                 onPressed: _loadCours,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2E7D32),
//                   foregroundColor: Colors.white,
//                 ),
//                 child: const Text('Réessayer'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (_filtered.isEmpty) {
//       return const Center(
//         child: Text(
//           'Aucune leçon trouvée',
//           style: TextStyle(color: Color(0xFF9E9E9E)),
//         ),
//       );
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         mainAxisSpacing: 14,
//         crossAxisSpacing: 14,
//         childAspectRatio: 0.85,
//       ),
//       itemCount: _filtered.length,
//       itemBuilder: (context, index) {
//         final cours = _filtered[index];
//         // Alternance de couleurs comme sur la maquette
//         final isAlt = index % 2 == 1;
//         return _LeconCard(
//           cours: cours,
//           backgroundColor:
//               isAlt ? const Color(0xFFA98E72) : const Color(0xFFB99B6B),
//           footerColor:
//               isAlt ? const Color(0xFFD9C9A3) : const Color(0xFFE3D2A8),
//           onTap: () => _openPdf(cours),
//         );
//       },
//     );
//   }
// }

// class _LeconCard extends StatelessWidget {
//   final CoursModel cours;
//   final Color backgroundColor;
//   final Color footerColor;
//   final VoidCallback onTap;

//   const _LeconCard({
//     required this.cours,
//     required this.backgroundColor,
//     required this.footerColor,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         clipBehavior: Clip.hardEdge,
//         child: Column(
//           children: [
//             // Titre
//             Padding(
//               padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
//               child: Text(
//                 cours.titre,
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF3E2E1E),
//                 ),
//               ),
//             ),
//             // Icône livre
//             const Expanded(
//               child: Center(
//                 child: Icon(
//                   Icons.menu_book_rounded,
//                   size: 44,
//                   color: Color(0xFF5D4530),
//                 ),
//               ),
//             ),
//             // Footer description
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(10),
//               color: footerColor,
//               child: Text(
//                 cours.sousTitre,
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 11,
//                   color: Color(0xFF3E2E1E),
//                   height: 1.3,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/cours_model_api.dart';
import '../services/contenu_service.dart';
import 'pdf_viewer_screen.dart';

/// Page affichant la liste des leçons/cours d'une matière
/// (ex: "Language") sous forme de grille de cards.
///
/// Arguments attendus (via Navigator) :
///   { 'idMatiere': int, 'nomMatiere': String }
class MatiereDetailScreen extends StatefulWidget {
  const MatiereDetailScreen({super.key});

  @override
  State<MatiereDetailScreen> createState() => _MatiereDetailScreenState();
}

class _MatiereDetailScreenState extends State<MatiereDetailScreen> {
  final ContenuService _service = ContenuService();
  final _searchController = TextEditingController();

  List<CoursModel> _cours = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  String _nomMatiere = '';
  int _idMatiere = 0;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments
          as Map<String, dynamic>?;
      _idMatiere = args?['idMatiere'] as int? ?? 0;
      _nomMatiere = args?['nomMatiere'] as String? ?? 'Matière';
      _initialized = true;
      _loadCours();
    }
  }

  Future<void> _loadCours() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cours = await _service.getCoursByMatiere(_idMatiere);
      setState(() {
        _cours = cours;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Erreur chargement cours: $e');
      setState(() {
        _error = 'Impossible de charger les leçons. ($e)';
        _isLoading = false;
      });
    }
  }

  List<CoursModel> get _filtered {
    if (_searchQuery.isEmpty) return _cours;
    final q = _searchQuery.toLowerCase();
    return _cours
        .where((c) =>
            c.titre.toLowerCase().contains(q) ||
            c.sousTitre.toLowerCase().contains(q))
        .toList();
  }

  void _openPdf(CoursModel cours) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(
          url: cours.urlFichier,
          titre: cours.titre,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  Text(
                    _nomMatiere,
                    style: const TextStyle(
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Recherche les lecons',
                  hintStyle: const TextStyle(
                      color: Color(0xFF9E9E9E), fontSize: 14),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF2E7D32)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12),
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

            // ── Grille de cards ───────────────────────────────
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
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
              Text(_error!,
                  style: const TextStyle(color: Color(0xFF6B7280))),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadCours,
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
          'Aucune leçon trouvée',
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
        childAspectRatio: 0.85,
      ),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final cours = _filtered[index];
        // Alternance de couleurs comme sur la maquette
        final isAlt = index % 2 == 1;
        return _LeconCard(
          cours: cours,
          backgroundColor:
              isAlt ? const Color(0xFFA98E72) : const Color(0xFFB99B6B),
          footerColor:
              isAlt ? const Color(0xFFD9C9A3) : const Color(0xFFE3D2A8),
          onTap: () => _openPdf(cours),
        );
      },
    );
  }
}

class _LeconCard extends StatelessWidget {
  final CoursModel cours;
  final Color backgroundColor;
  final Color footerColor;
  final VoidCallback onTap;

  const _LeconCard({
    required this.cours,
    required this.backgroundColor,
    required this.footerColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            // Titre
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Text(
                cours.titre,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2E1E),
                ),
              ),
            ),
            // Icône livre
            const Expanded(
              child: Center(
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 44,
                  color: Color(0xFF5D4530),
                ),
              ),
            ),
            // Footer description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: footerColor,
              child: Text(
                cours.sousTitre,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF3E2E1E),
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}