import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'session_manager.dart';
import 'navigation_service.dart';

/// Exception levée quand l'API retourne une erreur.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Client HTTP de base, partagé par tous les services.
///
/// Centralise :
/// - la construction des URLs (baseUrl + endpoint)
/// - les headers (auth token — récupéré automatiquement depuis
///   SessionManager si non fourni explicitement)
/// - le parsing JSON et la gestion d'erreurs
/// - le timeout
class ApiClient {
  final String? _explicitToken;
  final Duration timeout;

  // Évite de déclencher plusieurs redirections/SnackBars en même temps
  // si plusieurs requêtes échouent en 401 au même moment.
  static bool _isHandlingSessionExpiry = false;

  ApiClient({String? token, this.timeout = const Duration(seconds: 15)})
      : _explicitToken = token;

  /// Token utilisé pour cette requête : celui passé explicitement,
  /// sinon celui de la session courante (utilisateur connecté).
  String? get _token => _explicitToken ?? SessionManager.instance.token;

  Uri _buildUri(String path, [Map<String, dynamic>? query]) {
    final cleanQuery = query?.map((k, v) => MapEntry(k, v?.toString()))
        .entries
        .where((e) => e.value != null)
        .fold<Map<String, String>>({}, (map, e) {
          map[e.key] = e.value!;
          return map;
        });
    return Uri.parse('${ApiConfig.baseUrl}$path').replace(
      queryParameters: (cleanQuery != null && cleanQuery.isNotEmpty)
          ? cleanQuery
          : null,
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await http
          .get(_buildUri(path, query), headers: ApiConfig.headers(token: _token))
          .timeout(timeout);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            _buildUri(path),
            headers: ApiConfig.headers(token: _token),
            body: jsonEncode(body),
          )
          .timeout(timeout);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    try {
      final response = await http
          .put(
            _buildUri(path),
            headers: ApiConfig.headers(token: _token),
            body: jsonEncode(body),
          )
          .timeout(timeout);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final response = await http
          .delete(_buildUri(path), headers: ApiConfig.headers(token: _token))
          .timeout(timeout);
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Pas de connexion internet');
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    debugPrint('🌐 API ${statusCode}: ${response.request?.url}');
    if (statusCode != 200 && statusCode != 201) {
      debugPrint('⚠️  Body: ${response.body}');
    }
    dynamic decoded;
    try {
      decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } catch (_) {
      decoded = null;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    }

    // Token manquant/expiré/invalide : on déconnecte et on redirige
    // automatiquement vers l'écran de connexion, au lieu de laisser
    // chaque écran gérer ce cas lui-même (ou pas du tout).
    if (statusCode == 401) {
      _handleSessionExpired();
    }

    final message = (decoded is Map && decoded['message'] != null)
        ? decoded['message'] as String
        : _messageForStatus(statusCode);

    throw ApiException(message, statusCode: statusCode);
  }

  /// Message générique et compréhensible quand le serveur n'en fournit
  /// pas lui-même (évite d'afficher "Erreur serveur (500)" ou pire,
  /// une trace technique, à l'utilisateur final).
  String _messageForStatus(int statusCode) {
    if (statusCode == 401) return 'Session expirée. Veuillez vous reconnecter.';
    if (statusCode == 403) return 'Accès non autorisé.';
    if (statusCode == 404) return 'Ressource introuvable.';
    if (statusCode == 409) return 'Cette action n\'est pas possible actuellement.';
    if (statusCode >= 500) return 'Le serveur est momentanément indisponible. Réessayez dans un instant.';
    return 'Une erreur est survenue. Réessayez.';
  }

  /// Déconnecte l'utilisateur et le redirige vers /connexion.
  /// Appelé automatiquement sur toute réponse 401 (token manquant,
  /// expiré ou invalide), quel que soit l'écran depuis lequel l'appel
  /// a été fait.
  void _handleSessionExpired() {
    if (_isHandlingSessionExpiry) return;
    _isHandlingSessionExpiry = true;

    // Efface le token immédiatement (synchrone) pour qu'aucun autre
    // appel ne reparte avec un token qu'on sait invalide.
    SessionManager.instance.clear();

    final navigator = NavigationService.navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushNamedAndRemoveUntil('/connexion', (route) => false);
      final context = NavigationService.navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Votre session a expiré. Veuillez vous reconnecter.'),
            backgroundColor: Color(0xFFC62828),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    // Autorise une prochaine redirection après un court délai (au cas
    // où une nouvelle session expire plus tard).
    Future.delayed(const Duration(seconds: 3), () {
      _isHandlingSessionExpiry = false;
    });
  }
}