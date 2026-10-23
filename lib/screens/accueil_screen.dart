// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../services/abonnement_guard.dart';
// import '../widgets/bottom_nav_bar.dart';

// class AccueilScreen extends StatefulWidget {
//   const AccueilScreen({super.key});

//   @override
//   State<AccueilScreen> createState() => _AccueilScreenState();
// }

// class _AccueilScreenState extends State<AccueilScreen> {
//   final PageController _carouselController = PageController();
//   int _currentCarousel = 0;
//   Timer? _carouselTimer;
//   int _currentNav = 1; // Accueil sélectionné par défaut (icône maison)

//   final List<Map<String, dynamic>> _slides = [
//     {'label': 'Fondamental',   'image': 'assets/images/carousel_fondamental.jpg'},
//     {'label': 'Universitaire', 'image': 'assets/images/carousel_universitaire.jpg'},
//     {'label': 'Secondaire',    'image': 'assets/images/carousel_secondaire.jpg'},
//     {'label': 'Technique',     'image': 'assets/images/carousel_technique.jpg'},
//     {'label': 'Art-Culture',   'image': 'assets/images/carousel_art_culture.jpg'},
//     {'label': 'Défense',       'image': 'assets/images/carousel_defense.jpg'},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _startCarousel();
//   }

//   void _startCarousel() {
//     _carouselTimer = Timer.periodic(const Duration(seconds: 2), (_) {
//       final next = (_currentCarousel + 1) % _slides.length;
//       _carouselController.animateToPage(
//         next,
//         duration: const Duration(milliseconds: 600),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _carouselTimer?.cancel();
//     _carouselController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: Column(
//         children: [
//           // ── Header vert ─────────────────────────────────────
//           _buildHeader(),

//           // ── Corps ───────────────────────────────────────────
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
//               child: Column(
//                 children: [
//                   _buildBrochureCard(context),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(child: _buildSujetsCard(context)),
//                       const SizedBox(width: 12),
//                       Expanded(child: _buildBiblioCard(context)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // ── Bottom Nav ───────────────────────────────────────
//           BottomNavBar(currentIndex: _currentNav),
//         ],
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────────────────────
//   // HEADER
//   // ─────────────────────────────────────────────────────────────
//   Widget _buildHeader() {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Color(0xFF7A9E7E),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(28),
//           bottomRight: Radius.circular(28),
//         ),
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Column(
//           children: [
//             // Top bar
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//               child: Row(
//                 children: [
//                   // Logo arbre (image)
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: ClipOval(
//                       child: Image.asset(
//                         'assets/images/logo_arbre.png',
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => const Icon(
//                           Icons.park_rounded,
//                           color: Color(0xFF2E7D32),
//                           size: 30,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // Texte bienvenu
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Bienvenu',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         'sur Mali Kalan ',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   // Logo Orange (image)
//                   Image.asset(
//                     'assets/images/logo_orange.png',
//                     height: 36,
//                     errorBuilder: (_, __, ___) => Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFF6600),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Text(
//                         'orange',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 13,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Carousel
//             ClipRRect(
//               borderRadius: const BorderRadius.only(),
//               child: SizedBox(
//                 width: 350,
//                 height: 170,
//                 child: PageView.builder(
//                   controller: _carouselController,
//                   itemCount: _slides.length,
//                   onPageChanged: (i) => setState(() => _currentCarousel = i),
//                   itemBuilder: (_, index) => _buildSlide(_slides[index]),
//                 ),
//               ),
//             ),

//             // Dots
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(_slides.length, (i) {
//                   final active = _currentCarousel == i;
//                   return AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     margin: const EdgeInsets.symmetric(horizontal: 3),
//                     width: active ? 22 : 7,
//                     height: 7,
//                     decoration: BoxDecoration(
//                       color: active ? Colors.white : Colors.white38,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSlide(Map<String, dynamic> slide) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Image.asset(
//           slide['image'] as String,
//           fit: BoxFit.cover,
//           errorBuilder: (_, __, ___) => Container(
//             color: const Color(0xFF4A7C59),
//           ),
//         ),
//         // Overlay dégradé bas
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Colors.transparent,
//                 Colors.black.withOpacity(0.55),
//               ],
//             ),
//           ),
//         ),
//         // Label centré
//         Center(
//           child: Text(
//             slide['label'] as String,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1,
//               shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ─────────────────────────────────────────────────────────────
//   // CARDS
//   // ─────────────────────────────────────────────────────────────
//   Widget _buildBrochureCard(BuildContext context) {
//     return GestureDetector(
//       onTap: () => verifierAbonnementEtAcceder(
//         context: context,
//         onAbonne: () => Navigator.pushNamed(context, '/brochure'),
//       ),
//       child: Container(
//         width: double.infinity,
//         height: 150,
//         decoration: BoxDecoration(
//           color: const Color(0xFF4A7C59),
//           borderRadius: BorderRadius.circular(18),
//         ),
//         clipBehavior: Clip.hardEdge,
//         child: Stack(
//           children: [
//             // Texte à gauche
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 14, 0, 14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text(
//                     '📚 Préparez vos examens avec\ndes cours sur mesure !',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12.5,
//                       height: 1.4,
//                     ),
//                   ),
//                   Text(
//                     'Brochure',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Image illustration (fille lisant) à droite
//             Positioned(
//               right: 0,
//               bottom: 0,
//               top: 0,
//               child: Image.asset(
//                 'assets/images/brochure_illus.png',
//                 fit: BoxFit.contain,
//                 errorBuilder: (_, __, ___) => const Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Icon(
//                     Icons.menu_book_rounded,
//                     size: 70,
//                     color: Colors.white54,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSujetsCard(BuildContext context) {
//     return GestureDetector(
//       onTap: () => verifierAbonnementEtAcceder(
//         context: context,
//         onAbonne: () => Navigator.pushNamed(context, '/sujets'),
//       ),
//       child: Container(
//         height: 185,
//         decoration: BoxDecoration(
//           color: const Color(0xFFD9B8B8),
//           borderRadius: BorderRadius.circular(18),
//         ),
//         clipBehavior: Clip.hardEdge,
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Sujets\nd'examen",
//               style: TextStyle(
//                 color: Color(0xFF3E2020),
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 height: 1.3,
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Image illustration
//             Expanded(
//               child: Center(
//                 child: Image.asset(
//                   'assets/images/sujets_illus.png',
//                   fit: BoxFit.contain,
//                   errorBuilder: (_, __, ___) => const Icon(
//                     Icons.assignment_rounded,
//                     size: 48,
//                     color: Color(0xFF8B4513),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               "Accédez aux\nanciens sujets d'examens.",
//               style: TextStyle(
//                 color: Color(0xFF555555),
//                 fontSize: 11,
//                 height: 1.4,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBiblioCard(BuildContext context) {
//     return GestureDetector(
//       onTap: () => verifierAbonnementEtAcceder(
//         context: context,
//         onAbonne: () => Navigator.pushNamed(context, '/bibliotheque'),
//       ),
//       child: Container(
//         height: 190,
//         decoration: BoxDecoration(
//           color: const Color(0xFFC8BB95),
//           borderRadius: BorderRadius.circular(18),
//         ),
//         clipBehavior: Clip.hardEdge,
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Bibliothèque',
//               style: TextStyle(
//                 color: Color(0xFF2E7D32),
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             // Image illustration
//             Expanded(
//               child: Center(
//                 child: Image.asset(
//                   'assets/images/biblio_illus.png',
//                   fit: BoxFit.contain,
//                   errorBuilder: (_, __, ___) => const Icon(
//                     Icons.local_library_rounded,
//                     size: 48,
//                     color: Color(0xFF5D4037),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 6),
//             const Text(
//               'Accédez à une\ncollection riche\net variée.',
//               style: TextStyle(
//                 color: Color(0xFF555555),
//                 fontSize: 11,
//                 height: 1.4,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'dart:async';
import 'package:flutter/material.dart';
import '../services/abonnement_guard.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  final PageController _carouselController = PageController();
  int _currentCarousel = 0;
  Timer? _carouselTimer;
  int  _currentNav = 1; // Accueil sélectionné par défaut (icône maison)

  final List<Map<String, dynamic>> _slides = [
    {'label': 'Ecole Numérique du Mali(ENM)',   'image': 'assets/images/carousel_fondamental.jpg'},
    {'label': 'Lycée Numérique du Mali(LNM)',    'image': 'assets/images/carousel_secondaire.jpg'},
    {'label': 'Professionnel Numérique du Mali(PNM)', 'image': 'assets/images/carousel_technique.jpg'},
    {'label': 'Universitaire Numérique du Mali(UNM)', 'image': 'assets/images/carousel_universitaire.jpg'},
    {'label': 'Musée Numérique du Mali(MNM)',   'image': 'assets/images/carousel_art_culture.jpg'},
    {'label': 'Sécurité/Défense',       'image': 'assets/images/carousel_defense.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _startCarousel();
  }

  void _startCarousel() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final next = (_currentCarousel + 1) % _slides.length;
      _carouselController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // ── Header vert ─────────────────────────────────────
          _buildHeader(),

          // ── Corps ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
              child: Column(
                children: [
                  _buildBrochureCard(context),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(child: _buildSujetsCard(context)),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildBiblioCard(context)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Nav ───────────────────────────────────────
          BottomNavBar(currentIndex: _currentNav),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF7A9E7E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              child: Row(
                children: [
                  // Logo arbre (image)
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 2.w),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo_arbre.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.park_rounded,
                          color: const Color(0xFF2E7D32),
                          size: 30.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Texte bienvenu
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'sur Mali Kalan ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  // Logo Orange (image)
                  Image.asset(
                    'assets/images/logo_orange.png',
                    height: 36.h,
                    errorBuilder: (_, __, ___) => Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6600),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'orange',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Carousel
            ClipRRect(
              borderRadius:const BorderRadius.only(),
              child: SizedBox(
                width: 350.w,
                height: 170.h,
                child: PageView.builder(
                  controller: _carouselController,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _currentCarousel = i),
                  itemBuilder: (_, index) => _buildSlide(_slides[index]),
                ),
              ),
            ),

            // Dots
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  final active = _currentCarousel == i;
                  return AnimatedContainer(
                    duration:const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: active ? 22 : 7,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white38,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(Map<String, dynamic> slide) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          slide['image'] as String,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF4A7C59),
          ),
        ),
        // Overlay dégradé bas
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.55),
              ],
            ),
          ),
        ),
        // Label centré
        Center(
          child: Text(
            slide['label'] as String,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // CARDS
  // ─────────────────────────────────────────────────────────────
  Widget _buildBrochureCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.h,
      decoration: BoxDecoration(
        color: Color(0xFF4A7C59),
        borderRadius: BorderRadius.circular(18.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
        onTap: () => verifierAbonnementEtAcceder(
          context: context,
          onAbonne: () => Navigator.pushNamed(context, '/brochure'),
        ),
        child: Stack(
          children: [
            // Texte à gauche
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 0.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📚 Préparez vos examens avec\ndes cours sur mesure !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5.sp,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    'Brochure',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Image illustration (fille lisant) à droite
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: Image.asset(
                'assets/images/brochure_illus.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 70.sp,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildSujetsCard(BuildContext context) {
    return Container(
      height: 185.h,
      decoration: BoxDecoration(
        color: Color(0xFFD9B8B8),
        borderRadius: BorderRadius.circular(18.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
        onTap: () => verifierAbonnementEtAcceder(
          context: context,
          onAbonne: () => Navigator.pushNamed(context, '/sujets'),
        ),
        child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sujets\nd'examen",
              style: TextStyle(
                color: Color(0xFF3E2020),
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            SizedBox(height: 8.h),
            // Image illustration
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/sujets_illus.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.assignment_rounded,
                    size: 48.sp,
                    color: Color(0xFF8B4513),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "Accédez aux\nanciens sujets d'examens.",
              style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 11.sp,
                height: 1.4,
              ),
            ),
          ],
        ),
        ),
        ),
      ),
    );
  }

  Widget _buildBiblioCard(BuildContext context) {
    return Container(
      height: 190.h,
      decoration: BoxDecoration(
        color: Color(0xFFC8BB95),
        borderRadius: BorderRadius.circular(18.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
        onTap: () => verifierAbonnementEtAcceder(
          context: context,
          onAbonne: () => Navigator.pushNamed(context, '/bibliotheque'),
        ),
        child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bibliothèque',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            // Image illustration
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/biblio_illus.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.local_library_rounded,
                    size: 48.sp,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Accédez à une\ncollection riche\net variée.',
              style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 11.sp,
                height: 1.4,
              ),
            ),
          ],
        ),
        ),
        ),
      ),
    );
  }
}
