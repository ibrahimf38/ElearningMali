/// Représente `Contenu` + `TutorielVideo` du diagramme de classe.
/// `urlVideo` pointe vers un fichier vidéo stocké sur AWS S3.
class TutorielVideoModel {
  final int id;
  final int idMatiere;
  final String titre;
  final String sousTitre;
  final String description;
  final String urlVideo; // URL S3
  final int dureeMinutes;
  final DateTime? dateAjout;

  const TutorielVideoModel({
    required this.id,
    required this.idMatiere,
    required this.titre,
    required this.sousTitre,
    required this.description,
    required this.urlVideo,
    required this.dureeMinutes,
    this.dateAjout,
  });

  factory TutorielVideoModel.fromJson(Map<String, dynamic> json) {
    return TutorielVideoModel(
      id: json['id_tuto'] as int? ?? json['id'] as int,
      idMatiere: json['id_matiere'] as int,
      titre: json['titre'] as String,
      sousTitre: json['sous_titre'] as String? ?? '',
      description: json['description'] as String? ?? '',
      urlVideo: json['url_video'] as String,
      dureeMinutes: json['duree_minutes'] as int? ?? 0,
      dateAjout: json['date_ajout'] != null
          ? DateTime.tryParse(json['date_ajout'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id_tuto': id,
        'id_matiere': idMatiere,
        'titre': titre,
        'sous_titre': sousTitre,
        'description': description,
        'url_video': urlVideo,
        'duree_minutes': dureeMinutes,
        'date_ajout': dateAjout?.toIso8601String(),
      };

  /// Formate la durée en "MM:SS" pour l'affichage (ex: 5:56)
  String get dureeFormatee {
    final minutes = dureeMinutes;
    return '$minutes:00';
  }
}