import 'package:flutter/material.dart';

/// Transition de navigation par glissement (écran qui arrive depuis la
/// droite + léger fondu, l'écran précédent recule légèrement vers la
/// gauche). Utilisée par toutes les routes nommées via le PageTransitionsTheme.
class SlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const SlidePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final enter = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    final exit = CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return SlideTransition(
      // L'écran précédent recule d'un tiers de largeur (effet de profondeur).
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.25, 0),
      ).animate(exit),
      child: SlideTransition(
        // Le nouvel écran glisse depuis la droite.
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(enter),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.6, end: 1).animate(enter),
          child: child,
        ),
      ),
    );
  }
}
