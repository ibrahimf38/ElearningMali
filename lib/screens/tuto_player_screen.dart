// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import '../models/tutoriel_video_model.dart';

// /// Page lecteur vidéo pour un tutoriel.
// /// Arguments attendus : un [TutorielVideoModel].
// class TutoPlayerScreen extends StatefulWidget {
//   const TutoPlayerScreen({super.key});

//   @override
//   State<TutoPlayerScreen> createState() => _TutoPlayerScreenState();
// }

// class _TutoPlayerScreenState extends State<TutoPlayerScreen> {
//   VideoPlayerController? _controller;
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _showControls = true;
//   TutorielVideoModel? _video;
//   bool _initialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       _video = ModalRoute.of(context)!.settings.arguments
//           as TutorielVideoModel?;
//       _initialized = true;
//       if (_video != null && _video!.urlVideo.isNotEmpty) {
//         _initVideo(_video!.urlVideo);
//       } else {
//         setState(() {
//           _isLoading = false;
//           _hasError = true;
//         });
//       }
//     }
//   }

//   Future<void> _initVideo(String url) async {
//     try {
//       final controller = VideoPlayerController.networkUrl(Uri.parse(url));
//       await controller.initialize();
//       setState(() {
//         _controller = controller;
//         _isLoading = false;
//       });
//     } catch (_) {
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//       });
//     }
//   }

//   void _togglePlayPause() {
//     if (_controller == null) return;
//     setState(() {
//       if (_controller!.value.isPlaying) {
//         _controller!.pause();
//       } else {
//         _controller!.play();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   String _formatDuration(Duration d) {
//     final m = d.inMinutes;
//     final s = d.inSeconds % 60;
//     return '$m:${s.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final video = _video;

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
//                   Expanded(
//                     child: Text(
//                       video?.titre ?? 'Titre',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1A1A2E),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // ── Player vidéo ────────────────────────────────────
//             _buildPlayer(),

//             // ── Sous-titre + description ─────────────────────────
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (video != null && video.sousTitre.isNotEmpty) ...[
//                       const Text(
//                         'Sous titre',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1A1A2E),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         video.sousTitre,
//                         style: const TextStyle(
//                           fontSize: 13,
//                           color: Color(0xFF1A1A2E),
//                           height: 1.5,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                     ],
//                     const Text(
//                       'Description',
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1A1A2E),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       video?.description ?? '',
//                       style: const TextStyle(
//                         fontSize: 13,
//                         color: Color(0xFF1A1A2E),
//                         height: 1.6,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPlayer() {
//     if (_isLoading) {
//       return AspectRatio(
//         aspectRatio: 16 / 9,
//         child: Container(
//           color: Colors.black,
//           child: const Center(
//             child: CircularProgressIndicator(color: Colors.white),
//           ),
//         ),
//       );
//     }

//     if (_hasError || _controller == null) {
//       return AspectRatio(
//         aspectRatio: 16 / 9,
//         child: Container(
//           color: Colors.black,
//           child: const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline_rounded,
//                     color: Colors.white54, size: 48),
//                 SizedBox(height: 8),
//                 Text(
//                   'Vidéo indisponible',
//                   style: TextStyle(color: Colors.white70, fontSize: 13),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     final controller = _controller!;

//     return GestureDetector(
//       onTap: () => setState(() => _showControls = !_showControls),
//       child: AspectRatio(
//         aspectRatio: controller.value.aspectRatio == 0
//             ? 16 / 9
//             : controller.value.aspectRatio,
//         child: Stack(
//           alignment: Alignment.center,
//           fit: StackFit.expand,
//           children: [
//             VideoPlayer(controller),

//             // Bouton play/pause central
//             if (_showControls)
//               AnimatedOpacity(
//                 opacity: _showControls ? 1 : 0,
//                 duration: const Duration(milliseconds: 200),
//                 child: Container(
//                   color: Colors.black.withOpacity(0.15),
//                   child: Center(
//                     child: GestureDetector(
//                       onTap: _togglePlayPause,
//                       child: Container(
//                         width: 56,
//                         height: 56,
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.4),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           controller.value.isPlaying
//                               ? Icons.pause_rounded
//                               : Icons.play_arrow_rounded,
//                           color: Colors.white,
//                           size: 34,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//             // Barre de progression + durée
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.transparent,
//                       Colors.black.withOpacity(0.6),
//                     ],
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Text(
//                       _formatDuration(controller.value.position),
//                       style: const TextStyle(
//                           color: Colors.white, fontSize: 12),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: VideoProgressIndicator(
//                         controller,
//                         allowScrubbing: true,
//                         colors: const VideoProgressColors(
//                           playedColor: Color(0xFF2E7D32),
//                           bufferedColor: Colors.white38,
//                           backgroundColor: Colors.white12,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     // Icône plein écran (visuel uniquement)
//                     const Icon(Icons.fullscreen_rounded,
//                         color: Colors.white, size: 20),
//                   ],
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
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../models/tutoriel_video_model.dart';

class TutoPlayerScreen extends StatefulWidget {
  const TutoPlayerScreen({super.key});

  @override
  State<TutoPlayerScreen> createState() => _TutoPlayerScreenState();
}

class _TutoPlayerScreenState extends State<TutoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  bool _showControls = true;
  bool _isFullscreen = false;
  TutorielVideoModel? _video;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _video = ModalRoute.of(context)!.settings.arguments as TutorielVideoModel?;
      _initialized = true;
      if (_video != null && _video!.urlVideo.isNotEmpty) {
        _initVideo(_video!.urlVideo);
      } else {
        setState(() { _isLoading = false; _hasError = true; });
      }
    }
  }

  Future<void> _initVideo(String url) async {
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
      );
      await controller.initialize();
      controller.addListener(() { if (mounted) setState(() {}); });
      setState(() { _controller = controller; _isLoading = false; });
    } catch (e) {
      setState(() { _isLoading = false; _hasError = true; });
    }
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
    });
  }

  void _toggleFullscreen() {
    setState(() => _isFullscreen = !_isFullscreen);
    if (_isFullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) return '$h:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}';
    return '$m:${s.toString().padLeft(2,'0')}';
  }

  // Calcule le ratio adapté au format de la vidéo
  double get _videoRatio {
    if (_controller == null || !_controller!.value.isInitialized) return 16 / 9;
    final ratio = _controller!.value.aspectRatio;
    if (ratio <= 0) return 16 / 9;
    return ratio;
  }

  // Détermine si la vidéo est en format portrait (vertical)
  bool get _isPortrait => _videoRatio < 1.0;

  @override
  Widget build(BuildContext context) {
    if (_isFullscreen) return _buildFullscreenPlayer();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────
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
                    child: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _video?.titre ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Player ────────────────────────────────────────
            _buildPlayerWidget(),

            // ── Infos ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_video?.sousTitre.isNotEmpty == true) ...[
                      const Text('Sous titre',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 6),
                      Text(_video!.sousTitre,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E), height: 1.5)),
                      const SizedBox(height: 16),
                    ],
                    const Text('Description',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                    const SizedBox(height: 6),
                    Text(_video?.description ?? '',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E), height: 1.6)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerWidget() {
    if (_isLoading) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      );
    }
    if (_hasError || _controller == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: const Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.error_outline_rounded, color: Colors.white54, size: 48),
              SizedBox(height: 8),
              Text('Vidéo indisponible', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    // Pour les vidéos portrait (vertical), on limite la hauteur
    // Pour les vidéos paysage, on utilise toute la largeur
    final playerHeight = _isPortrait
        ? screenWidth * (1 / _videoRatio).clamp(0.5, 1.2)
        : screenWidth / _videoRatio;

    return GestureDetector(
      onTap: () => setState(() => _showControls = !_showControls),
      child: SizedBox(
        width: screenWidth,
        height: playerHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Fond noir
            Container(color: Colors.black),

            // Vidéo centrée et adaptée
            Center(
              child: AspectRatio(
                aspectRatio: _videoRatio,
                child: VideoPlayer(_controller!),
              ),
            ),

            // Contrôles
            if (_showControls) _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    final controller = _controller!;
    final duration = controller.value.duration;
    final position = controller.value.position;

    return AnimatedOpacity(
      opacity: _showControls ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.5)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            // Bouton play/pause
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  controller.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white, size: 34,
                ),
              ),
            ),
            // Barre de progression
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Row(
                children: [
                  Text(_formatDuration(position),
                      style: const TextStyle(color: Colors.white, fontSize: 11)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: VideoProgressIndicator(
                      controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Color(0xFF2E7D32),
                        bufferedColor: Colors.white38,
                        backgroundColor: Colors.white12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_formatDuration(duration),
                      style: const TextStyle(color: Colors.white, fontSize: 11)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _toggleFullscreen,
                    child: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Écran plein écran (après rotation)
  Widget _buildFullscreenPlayer() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_controller != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _videoRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
            if (_showControls) ...[
              _buildControls(),
              Positioned(
                top: 16, left: 16,
                child: GestureDetector(
                  onTap: _toggleFullscreen,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.fullscreen_exit_rounded, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
