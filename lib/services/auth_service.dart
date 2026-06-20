import '../config/api_config.dart';
import '../models/client_model.dart';
import 'api_client.dart';

/// Résultat retourné par login/register : token + infos client.
class AuthResult {
  final String token;
  final ClientModel client;

  const AuthResult({required this.token, required this.client});

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      token: json['token'] as String,
      client: ClientModel.fromJson(json['client'] as Map<String, dynamic>),
    );
  }
}

/// Service d'authentification.
///
/// Flux 100% OTP — pas de mot de passe côté client :
///   POST /auth/login        { telephone }                  -> envoie OTP
///   POST /auth/register      { nom_complet, telephone }      -> crée le compte + envoie OTP
///   POST /auth/verify-otp    { telephone, code_otp }         -> token + client
///   POST /auth/resend-otp    { telephone }
class AuthService {
  final ApiClient _client;

  AuthService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Demande de connexion : le backend vérifie que le numéro existe
  /// puis envoie un code OTP par SMS.
  Future<dynamic> login({
    required String telephone,
  }) {
    return _client.post(ApiConfig.login, {
      'telephone': telephone,
    });
  }

  /// Inscription d'un nouveau client (nom complet + téléphone).
  /// Le backend envoie un code OTP par SMS pour vérification.
  Future<dynamic> register({
    required String nomComplet,
    required String telephone,
  }) {
    return _client.post(ApiConfig.register, {
      'nom_complet': nomComplet,
      'telephone': telephone,
    });
  }

  /// Vérifie le code OTP reçu par SMS.
  /// Retourne un [AuthResult] (token + client) si succès.
  Future<AuthResult> verifyOtp({
    required String telephone,
    required String codeOtp,
  }) async {
    final json = await _client.post(ApiConfig.verifyOtp, {
      'telephone': telephone,
      'code_otp': codeOtp,
    });
    return AuthResult.fromJson(json as Map<String, dynamic>);
  }

  /// Demande l'envoi d'un nouveau code OTP.
  Future<dynamic> resendOtp({required String telephone}) {
    return _client.post(ApiConfig.resendOtp, {'telephone': telephone});
  }
}