import 'package:shared_preferences/shared_preferences.dart';
import '../models/client_model.dart';

/// Gère la session utilisateur courante (token JWT + infos client).
///
/// Singleton accessible partout via `SessionManager.instance`.
/// Le token est gardé en mémoire pour un accès synchrone rapide
/// (utilisé par tous les services API), et persisté sur disque
/// pour survivre aux redémarrages de l'app.
class SessionManager {
  SessionManager._internal();
  static final SessionManager instance = SessionManager._internal();

  String? _token;
  ClientModel? _client;

  String? get token => _token;
  ClientModel? get client => _client;
  bool get isLoggedIn => _token != null;

  static const _kTokenKey = 'auth_token';
  static const _kClientIdKey = 'client_id';
  static const _kClientNomKey = 'client_nom';
  static const _kClientTelKey = 'client_tel';

  /// Charge la session sauvegardée au démarrage de l'app.
  /// À appeler une fois dans main() avant runApp().
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_kTokenKey);
    final id = prefs.getInt(_kClientIdKey);
    final nom = prefs.getString(_kClientNomKey);
    final tel = prefs.getString(_kClientTelKey);
    if (id != null && nom != null && tel != null) {
      _client = ClientModel(id: id, nomComplet: nom, telephone: tel);
    }
  }

  /// Sauvegarde la session après une connexion réussie (verifyOtp).
  Future<void> saveSession(String token, ClientModel client) async {
    _token = token;
    _client = client;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, token);
    await prefs.setInt(_kClientIdKey, client.id);
    await prefs.setString(_kClientNomKey, client.nomComplet);
    await prefs.setString(_kClientTelKey, client.telephone);
  }

  /// Efface la session (déconnexion).
  Future<void> clear() async {
    _token = null;
    _client = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    await prefs.remove(_kClientIdKey);
    await prefs.remove(_kClientNomKey);
    await prefs.remove(_kClientTelKey);
  }
}