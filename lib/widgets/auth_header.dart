import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const AuthHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Fond vert avec forme arrondie en bas ──────────────
        ClipPath(
          clipper: _WaveClipper(),
          child: Container(
            height: 220,
            width: double.infinity,
            color: const Color(0xFF7A9E7E), // vert sauge maquette
          ),
        ),

        // ── Contenu ───────────────────────────────────────────
        SizedBox(
          height: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // Bouton Retour
              GestureDetector(
                onTap: onBack,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back, color: Color(0xFF2E7D32), size: 22),
                      SizedBox(width: 6),
                      Text(
                        'Retour',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Titre centré
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width * 0.25, size.height + 25,
      size.width * 0.5, size.height - 15,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height - 40,
      size.width, size.height - 10,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper old) => false;
}