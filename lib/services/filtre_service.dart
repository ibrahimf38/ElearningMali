import '../config/api_config.dart';
import '../models/filtre_model.dart';
import 'api_client.dart';

/// Service du système de filtrage : Domaine -> Niveau -> Matiere.
///
/// Endpoints :
///   GET /domaines
///   GET /domaines/:id/niveaux
///   GET /niveaux/:id/matieres
///   GET /domaines/:id/matieres-tutoriels  (pour la page Tutoriel)
class FiltreService {
  final ApiClient _client;

  FiltreService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Liste des 6 domaines (Fondamental, Universitaire, Secondaire,
  /// Technique, Art-culture, Defense).
  Future<List<DomaineModel>> getDomaines() async {
    final json = await _client.get(ApiConfig.domaines);
    return (json as List)
        .map((e) => DomaineModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Niveaux disponibles pour un domaine donné (1ere, 2eme, ...).
  Future<List<NiveauModel>> getNiveaux(int idDomaine) async {
    final json = await _client.get(ApiConfig.niveauxByDomaine(idDomaine));
    return (json as List)
        .map((e) => NiveauModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Matières disponibles pour un niveau donné.
  Future<List<MatiereModel>> getMatieres(int idNiveau) async {
    final json = await _client.get(ApiConfig.matieresByNiveau(idNiveau));
    return (json as List)
        .map((e) => MatiereModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Matières liées à un domaine pour le filtrage des tutoriels
  /// (table d'association DomaineMatiereTutoriel).
  Future<List<MatiereModel>> getMatieresByDomaineTuto(int idDomaine) async {
    final json = await _client.get(ApiConfig.matieresByDomaineTuto(idDomaine));
    return (json as List)
        .map((e) => MatiereModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}