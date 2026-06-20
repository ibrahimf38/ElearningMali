import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  static const List<Map<String, dynamic>> _items = [
    {'asset': 'assets/images/nav_etudiant.png', 'fallback': Icons.school_rounded,    'route': '/cours'},
    {'asset': 'assets/images/nav_maison.png',   'fallback': Icons.home_rounded,       'route': '/accueil'},
    {'asset': 'assets/images/nav_video.png',    'fallback': Icons.videocam_rounded,   'route': '/tutoriel'},
  ];

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) onTap!(index);
    final route = _items[index]['route'] as String;
    if (route != _routeForIndex(currentIndex)) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  String _routeForIndex(int index) => _items[index]['route'] as String;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 16),
      height: 68,
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_items.length, (i) {
          final isActive = currentIndex == i;
          return GestureDetector(
            onTap: () => _handleTap(context, i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withOpacity(0.25)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  _items[i]['asset'] as String,
                  width: 30,
                  height: 30,
                  color: Colors.white,
                  errorBuilder: (_, __, ___) => Icon(
                    _items[i]['fallback'] as IconData,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}