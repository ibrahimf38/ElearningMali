import 'package:flutter/material.dart';

/// Permet de naviguer (et d'afficher des SnackBars) depuis du code qui
/// n'a pas de [BuildContext] — notamment [ApiClient], qui a besoin de
/// rediriger automatiquement vers l'écran de connexion quand le token
/// JWT a expiré (réponse 401), sans attendre qu'un écran gère l'erreur
/// lui-même.
///
/// À brancher sur le `navigatorKey` du MaterialApp dans main.dart.
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
