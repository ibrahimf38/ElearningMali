/// Représente `Contenu` + `Cours` du diagramme de classe.
/// `urlFichier` pointe vers un objet stocké sur AWS S3.
class CoursModel {
  final int id;
  final int idMatiere;
  final String titre;
  final String sousTitre;
  final String urlFichier; // URL S3
  final DateTime? dateAjout;

  const CoursModel({
    required this.id,
    required this.idMatiere,
    required this.titre,
    required this.sousTitre,
    required this.urlFichier,
    this.dateAjout,
  });

  factory CoursModel.fromJson(Map<String, dynamic> json) {
    return CoursModel(
      id: json['id_cours'] as int? ?? json['id'] as int,
      idMatiere: json['id_matiere'] as int,
      titre: json['titre'] as String,
      sousTitre: json['sous_titre'] as String? ?? '',
      urlFichier: json['url_fichier'] as String,
      dateAjout: json['date_ajout'] != null
          ? DateTime.tryParse(json['date_ajout'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id_cours': id,
        'id_matiere': idMatiere,
        'titre': titre,
        'sous_titre': sousTitre,
        'url_fichier': urlFichier,
        'date_ajout': dateAjout?.toIso8601String(),
      };
}