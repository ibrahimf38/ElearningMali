import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'session_manager.dart';

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
    dynamic decoded;
    try {
      decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } catch (_) {
      decoded = null;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    }

    final message = (decoded is Map && decoded['message'] != null)
        ? decoded['message'] as String
        : 'Erreur serveur ($statusCode)';

    throw ApiException(message, statusCode: statusCode);
  }
}