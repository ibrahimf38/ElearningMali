import '../config/api_config.dart';
import '../models/abonnement_model.dart';
import 'api_client.dart';

/// Service de paiement et d'abonnement.
///
/// Endpoints :
///   POST /paiements/orange-money  { numero_orange, montant, type_forfait }
///   POST /paiements/moov-money    { numero_moov, montant, type_forfait }
///   GET  /abonnements             -> historique d'abonnement du client
class PaiementService {
  final ApiClient _client;

  PaiementService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Effectue le paiement via Orange Money ou Moov Money,
  /// puis crée l'abonnement correspondant côté serveur.
  Future<PaiementResult> payer({
    required MethodePaiement methode,
    required String numeroTelephone,
    required ForfaitModel forfait,
  }) async {
    final endpoint = methode == MethodePaiement.orangeMoney
        ? ApiConfig.paiementOrangeMoney
        : ApiConfig.paiementMoovMoney;

    final json = await _client.post(endpoint, {
      methode.champNumero: numeroTelephone,
      'montant': forfait.montant,
      'type_forfait': forfait.typeForfait,
      'duree_jours': forfait.dureeJours,
    });

    return PaiementResult.fromJson(json as Map<String, dynamic>);
  }

  /// Historique des abonnements du client connecté.
  Future<List<AbonnementModel>> getHistorique() async {
    final json = await _client.get(ApiConfig.abonnement);
    return (json as List)
        .map((e) => AbonnementModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}