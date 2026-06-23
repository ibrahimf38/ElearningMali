import '../config/api_config.dart';
import '../models/abonnement_model.dart';
import 'api_client.dart';

/// Service de paiement et d'abonnement.
///
/// Le flux est ASYNCHRONE pour les deux opérateurs :
///   1. initierPaiement()  -> POST /paiements/orange-money ou /moov-money
///        - Orange Money : retourne `paymentUrl` à ouvrir dans une WebView
///        - Moov Money   : déclenche une notification USSD sur le téléphone
///   2. verifierStatut()   -> GET /paiements/:id/statut, à appeler en
///      polling (ex: toutes les 3s) jusqu'à confirmation ou échec.
///   3. getHistorique()    -> liste des abonnements passés du client
class PaiementService {
  final ApiClient _client;

  PaiementService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Initie un paiement. Ne confirme PAS l'abonnement — voir [verifierStatut].
  Future<PaiementInitiationResult> initierPaiement({
    required MethodePaiement methode,
    required String numeroTelephone,
  }) async {
    final endpoint = methode == MethodePaiement.orangeMoney
        ? ApiConfig.paiementOrangeMoney
        : ApiConfig.paiementMoovMoney;

    final json = await _client.post(endpoint, {
      methode.champNumero: numeroTelephone,
    });

    return PaiementInitiationResult.fromJson(json as Map<String, dynamic>);
  }

  /// Vérifie le statut d'un paiement initié. À appeler en polling
  /// pendant que l'utilisateur confirme sur Orange/Moov.
  Future<PaiementStatutResult> verifierStatut(String idTransaction) async {
    final json = await _client.get(ApiConfig.paiementStatut(idTransaction));
    return PaiementStatutResult.fromJson(json as Map<String, dynamic>);
  }

  /// Historique des abonnements du client connecté.
  Future<List<AbonnementModel>> getHistorique() async {
    final json = await _client.get(ApiConfig.abonnement);
    return (json as List)
        .map((e) => AbonnementModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}