// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../models/filtre_model.dart';
// import '../models/tutoriel_video_model.dart';
// import '../services/contenu_service.dart';
// import '../services/filtre_service.dart';
// import '../widgets/section_header.dart';
// import '../widgets/app_drawer.dart';
// import '../widgets/bottom_nav_bar.dart';
// import '../widgets/domain_filter_sheet.dart';

// class TutorielScreen extends StatefulWidget {
//   const TutorielScreen({super.key});

//   @override
//   State<TutorielScreen> createState() => _TutorielScreenState();
// }

// class _TutorielScreenState extends State<TutorielScreen> {
//   final ContenuService _contenuService = ContenuService();
//   final FiltreService _filtreService = FiltreService();

//   DomaineModel? _selectedDomaine;
//   MatiereModel? _selectedMatiere; // null = "Tout"
//   List<MatiereModel> _categories = []; // matières liées au domaine sélectionné
//   String _searchQuery = '';

//   List<TutorielVideoModel> _videos = [];
//   bool _isLoading = true;
//   String? _error;

//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     _loadVideos();
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   Future<void> _loadVideos() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });
//     try {
//       final videos = await _contenuService.getTutoriels(
//         idDomaine: _selectedDomaine?.id,
//         idMatiere: _selectedMatiere?.id,
//         search: _searchQuery.isEmpty ? null : _searchQuery,
//       );
//       setState(() {
//         _videos = videos;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = 'Impossible de charger les tutoriels';
//         _isLoading = false;
//       });
//     }
//   }

//   void _onSearchChanged(String value) {
//     _searchQuery = value;
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 400), _loadVideos);
//   }

//   Future<void> _openFilter() async {
//     final result = await showDomainFilterSheet(
//       context,
//       selected: _selectedDomaine,
//     );
//     if (result != null) {
//       setState(() {
//         _selectedDomaine = result;
//         _selectedMatiere = null;
//         _categories = [];
//       });
//       _loadVideos();
//       // Charge les matières liées à ce domaine pour les tags catégories
//       try {
//         final matieres =
//             await _filtreService.getMatieresByDomaineTuto(result.id);
//         setState(() => _categories = matieres);
//       } catch (_) {
//         // Pas bloquant : les tags resteront vides, juste "Tout"
//       }
//     }
//   }

//   void _clearDomaine() {
//     setState(() {
//       _selectedDomaine = null;
//       _selectedMatiere = null;
//       _categories = [];
//     });
//     _loadVideos();
//   }

//   void _selectCategory(MatiereModel? matiere) {
//     setState(() => _selectedMatiere = matiere);
//     _loadVideos();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       drawer: const AppDrawer(),
//       body: Builder(
//         builder: (context) => Column(
//           children: [
//             // ── Header ──────────────────────────────────────
//             SafeArea(
//               bottom: false,
//               child: SectionHeader(
//                 title: 'Tutoriel video',
//                 onMenuTap: () => Scaffold.of(context).openDrawer(),
//               ),
//             ),

//             // ── Recherche + filtre domaine ───────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       onChanged: _onSearchChanged,
//                       decoration: InputDecoration(
//                         hintText: 'Recherche les tuto',
//                         hintStyle: const TextStyle(
//                             color: Color(0xFF9E9E9E), fontSize: 14.sp),
//                         prefixIcon: const Icon(Icons.search,
//                             color: Color(0xFF2E7D32)),
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 12.h),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: const BorderSide(
//                               color: Color(0xFF2E7D32), width: 1.5.w),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                           borderSide: const BorderSide(
//                               color: Color(0xFF2E7D32), width: 2.w),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10.w),
//                   GestureDetector(
//                     onTap: _openFilter,
//                     child: Container(
//                       width: 48.w,
//                       height: 48.h,
//                       decoration: BoxDecoration(
//                         color: _selectedDomaine != null
//                             ? const Color(0xFF8FBC94)
//                             : const Color(0xFFEDEDED),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),
//                       child: Icon(Icons.filter_list_rounded,
//                           color: _selectedDomaine != null
//                               ? Colors.white
//                               : const Color(0xFF555555)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Domaine sélectionné (chip dismissible)
//             if (_selectedDomaine != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.w),
//                 child: Row(
//                   children: [
//                     Chip(
//                       label: Text(_selectedDomaine!.nomDomaine),
//                       backgroundColor:
//                           const Color(0xFF8FBC94).withOpacity(0.2),
//                       labelStyle: const TextStyle(
//                         color: Color(0xFF2E7D32),
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12.sp,
//                       ),
//                       deleteIcon: const Icon(Icons.close,
//                           size: 16.sp, color: Color(0xFF2E7D32)),
//                       onDeleted: _clearDomaine,
//                     ),
//                   ],
//                 ),
//               ),

//             const SizedBox(height: 8.h),

//             // ── Tags catégories (Tout + matières du domaine) ──
//             if (_categories.isNotEmpty)
//               SizedBox(
//                 height: 36.h,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 16.w),
//                   itemCount: _categories.length + 1,
//                   separatorBuilder: (_, __) => const SizedBox(width: 8.w),
//                   itemBuilder: (context, index) {
//                     final isAll = index == 0;
//                     final matiere = isAll ? null : _categories[index - 1];
//                     final label = isAll ? 'Tout' : matiere!.nomMatiere;
//                     final isSelected = isAll
//                         ? _selectedMatiere == null
//                         : _selectedMatiere?.id == matiere!.id;
//                     return GestureDetector(
//                       onTap: () => _selectCategory(matiere),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 18.w),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? const Color(0xFF8FBC94)
//                               : Colors.white,
//                           borderRadius: BorderRadius.circular(20.r),
//                           border: Border.all(
//                             color: isSelected
//                                 ? const Color(0xFF8FBC94)
//                                 : Colors.grey.shade300,
//                           ),
//                         ),
//                         child: Text(
//                           label,
//                           style: TextStyle(
//                             fontSize: 13.sp,
//                             fontWeight: isSelected
//                                 ? FontWeight.bold
//                                 : FontWeight.normal,
//                             color: isSelected
//                                 ? Colors.white
//                                 : const Color(0xFF555555),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             const SizedBox(height: 14.h),

//             // ── Titre "video" ─────────────────────────────────
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'video',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1A1A2E),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8.h),

//             // ── Liste vidéos ──────────────────────────────────
//             Expanded(child: _buildVideoList()),

//             // ── Bottom nav ────────────────────────────────────
//             const BottomNavBar(currentIndex: 2),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoList() {
//     if (_isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
//       );
//     }
//     if (_error != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.r),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.error_outline_rounded,
//                   size: 48.sp, color: Color(0xFF9E9E9E)),
//               const SizedBox(height: 10.h),
//               Text(_error!, style: const TextStyle(color: Color(0xFF6B7280))),
//               const SizedBox(height: 12.h),
//               ElevatedButton(
//                 onPressed: _loadVideos,
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
//     if (_videos.isEmpty) {
//       return const Center(
//         child: Text(
//           'Aucun tutoriel trouvé',
//           style: TextStyle(color: Color(0xFF9E9E9E)),
//         ),
//       );
//     }

//     return ListView.separated(
//       padding: const EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       itemCount: _videos.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 10.h),
//       itemBuilder: (context, index) {
//         return _VideoTile(video: _videos[index]);
//       },
//     );
//   }
// }

// class _VideoTile extends StatelessWidget {
//   final TutorielVideoModel video;

//   const _VideoTile({required this.video});

//   String get _dureeFormatee {
//     final m = video.dureeMinutes;
//     return '${m}min';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, '/tuto-player', arguments: video);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(8.r),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Vignette générique (pas de thumbnail en base) + play
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: 90.w,
//                   height: 70.h,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE8F5E9),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: const Icon(Icons.movie_outlined,
//                       color: Color(0xFFA5D6A7), size: 28.sp),
//                 ),
//                 Container(
//                   width: 32.w,
//                   height: 32.h,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.4),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.play_arrow_rounded,
//                       color: Colors.white, size: 22.sp),
//                 ),
//                 Positioned(
//                   bottom: 4,
//                   right: 4,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 5.w, vertical: 1.h),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(4.r),
//                     ),
//                     child: Text(
//                       _dureeFormatee,
//                       style: const TextStyle(
//                           color: Colors.white, fontSize: 10.sp),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 12.w),

//             // Infos
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     video.titre,
//                     style: const TextStyle(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1A1A2E),
//                     ),
//                   ),
//                   const SizedBox(height: 4.h),
//                   Text(
//                     video.description,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 12.sp,
//                       color: Color(0xFF6B7280),
//                       height: 1.3,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const Icon(Icons.favorite_border_rounded,
//                 color: Color(0xFF9E9E9E), size: 20.sp),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../models/filtre_model.dart';
import '../models/tutoriel_video_model.dart';
import '../services/contenu_service.dart';
import '../services/filtre_service.dart';
import '../widgets/section_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/domain_filter_sheet.dart';

class TutorielScreen extends StatefulWidget {
  const TutorielScreen({super.key});

  @override
  State<TutorielScreen> createState() => _TutorielScreenState();
}

class _TutorielScreenState extends State<TutorielScreen> {
  final ContenuService _contenuService = ContenuService();
  final FiltreService _filtreService = FiltreService();

  DomaineModel? _selectedDomaine;
  MatiereModel? _selectedMatiere; // null = "Tout"
  List<MatiereModel> _categories = []; // matières liées au domaine sélectionné
  String _searchQuery = '';

  List<TutorielVideoModel> _videos = [];
  bool _isLoading = true;
  String? _error;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final videos = await _contenuService.getTutoriels(
        idDomaine: _selectedDomaine?.id,
        idMatiere: _selectedMatiere?.id,
        search: _searchQuery.isEmpty ? null : _searchQuery,
      );
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('');
      setState(() {
        _error = '';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    _searchQuery = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _loadVideos);
  }

  Future<void> _openFilter() async {
    final result = await showDomainFilterSheet(
      context,
      selected: _selectedDomaine,
    );
    if (result != null) {
      setState(() {
        _selectedDomaine = result;
        _selectedMatiere = null;
        _categories = [];
      });
      _loadVideos();
      // Charge les matières liées à ce domaine pour les tags catégories
      try {
        final matieres =
            await _filtreService.getMatieresByDomaineTuto(result.id);
        setState(() => _categories = matieres);
      } catch (_) {
        // Pas bloquant : les tags resteront vides, juste "Tout"
      }
    }
  }

  void _clearDomaine() {
    setState(() {
      _selectedDomaine = null;
      _selectedMatiere = null;
      _categories = [];
    });
    _loadVideos();
  }

  void _selectCategory(MatiereModel? matiere) {
    setState(() => _selectedMatiere = matiere);
    _loadVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFF5F5F5),
      drawer: AppDrawer(),
      body: Builder(
        builder: (context) => Column(
          children: [
            // ── Header ──────────────────────────────────────
            SafeArea(
              bottom: false,
              child: SectionHeader(
                title: 'Tutoriel video',
                onMenuTap: () => Scaffold.of(context).openDrawer(),
              ),
            ),

            // ── Recherche + filtre domaine ───────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Recherche les tuto',
                        hintStyle: TextStyle(
                            color: Color(0xFF9E9E9E), fontSize: 14.sp),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFF2E7D32)),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(
                              color: Color(0xFF2E7D32), width: 1.5.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide:
                              BorderSide(color: Color(0xFF2E7D32), width: 2.w),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: _openFilter,
                    child: Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: _selectedDomaine != null
                            ? Color(0xFF8FBC94)
                            : Color(0xFFEDEDED),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.filter_list_rounded,
                          color: _selectedDomaine != null
                              ? Colors.white
                              : const Color(0xFF555555)),
                    ),
                  ),
                ],
              ),
            ),

            // Domaine sélectionné (chip dismissible)
            if (_selectedDomaine != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Chip(
                      label: Text(_selectedDomaine!.nomDomaine),
                      backgroundColor: Color(0xFF8FBC94).withOpacity(0.2),
                      labelStyle: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                      deleteIcon: Icon(Icons.close,
                          size: 16.sp, color: Color(0xFF2E7D32)),
                      onDeleted: _clearDomaine,
                    ),
                  ],
                ),
              ),

            SizedBox(height: 8.h),

            // ── Tags catégories (Tout + matières du domaine) ──
            if (_categories.isNotEmpty)
              SizedBox(
                height: 36.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: _categories.length + 1,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final matiere = isAll ? null : _categories[index - 1];
                    final label = isAll ? 'Tout' : matiere!.nomMatiere;
                    final isSelected = isAll
                        ? _selectedMatiere == null
                        : _selectedMatiere?.id == matiere!.id;
                    return GestureDetector(
                      onTap: () => _selectCategory(matiere),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFF8FBC94) : Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8FBC94)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF555555),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 14.h),

            // ── Titre "video" ─────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'video',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // ── Liste vidéos ──────────────────────────────────
            Expanded(child: _buildVideoList()),

            // ── Bottom nav ────────────────────────────────────
            const BottomNavBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoList() {
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
                onPressed: _loadVideos,
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
    if (_videos.isEmpty) {
      return const Center(
        child: Text(
          'Aucun tutoriel trouvé',
          style: TextStyle(color: Color(0xFF9E9E9E)),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: _videos.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        return _VideoTile(video: _videos[index]);
      },
    );
  }
}

class _VideoTile extends StatelessWidget {
  final TutorielVideoModel video;

  const _VideoTile({required this.video});

  String get _dureeFormatee {
    final m = video.dureeMinutes;
    return '${m}min';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/tuto-player', arguments: video);
      },
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vignette générique (pas de thumbnail en base) + play
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 90.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.movie_outlined,
                      color: Color(0xFFA5D6A7), size: 28.sp),
                ),
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 22.sp),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      _dureeFormatee,
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),

            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.titre,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    video.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF6B7280),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            Icon(Icons.favorite_border_rounded,
                color: Color(0xFF9E9E9E), size: 20.sp),
          ],
        ),
      ),
    );
  }
}
