import '../config/api_config.dart';
import '../models/cours_model_api.dart';
import '../models/tutoriel_video_model.dart';
import '../models/library_models.dart';
import 'api_client.dart';

/// Service des contenus pédagogiques : Cours, TutorielVideo,
/// Ebook, Brochure, SujetExamen.
///
/// Endpoints :
///   GET /matieres/:id/cours
///   GET /matieres/:id/tutoriels
///   GET /tutoriels?id_domaine=&id_matiere=&search=
///   GET /ebooks?search=
///   GET /brochures
///   GET /sujets-examen?classe=&annee=
class ContenuService {
  final ApiClient _client;

  ContenuService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Liste des cours pour une matière donnée (page Cours).
  Future<List<CoursModel>> getCoursByMatiere(int idMatiere) async {
    final json = await _client.get(ApiConfig.coursByMatiere(idMatiere));
    return (json as List)
        .map((e) => CoursModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Liste des tutoriels vidéo pour une matière donnée.
  Future<List<TutorielVideoModel>> getTutosByMatiere(int idMatiere) async {
    final json = await _client.get(ApiConfig.tutosByMatiere(idMatiere));
    return (json as List)
        .map((e) => TutorielVideoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Liste globale de tutoriels avec filtres optionnels
  /// (page Tutoriel vidéo : filtre domaine + catégorie + recherche).
  ///
  /// [idDomaine] : filtre par domaine (bottom sheet "Filtré par niveau")
  /// [idMatiere] : filtre par matière (tags Tout/Math/Physique/...)
  /// [search]    : recherche texte sur titre/description
  Future<List<TutorielVideoModel>> getTutoriels({
    int? idDomaine,
    int? idMatiere,
    String? search,
  }) async {
    final json = await _client.get(ApiConfig.tutoriels, query: {
      if (idDomaine != null) 'id_domaine': idDomaine,
      if (idMatiere != null) 'id_matiere': idMatiere,
      if (search != null && search.isNotEmpty) 'search': search,
    });
    return (json as List)
        .map((e) => TutorielVideoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Liste des ebooks de la bibliothèque (avec recherche optionnelle).
  Future<List<EbookModel>> getEbooks({String? search}) async {
    final json = await _client.get(ApiConfig.ebooks, query: {
      if (search != null && search.isNotEmpty) 'search': search,
    });
    return (json as List)
        .map((e) => EbookModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Liste des brochures pédagogiques.
  Future<List<BrochureModel>> getBrochures() async {
    final json = await _client.get(ApiConfig.brochures);
    return (json as List)
        .map((e) => BrochureModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Liste des sujets d'examen (avec filtres optionnels classe/année).
  Future<List<BrochureModel>> getSujetsExamen({
    String? classe,
    int? annee,
  }) async {
    final json = await _client.get(ApiConfig.sujetsExamen, query: {
      if (classe != null && classe.isNotEmpty) 'classe': classe,
      if (annee != null) 'annee': annee,
    });
    return (json as List)
        .map((e) => BrochureModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}