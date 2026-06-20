/// Représente `Contenu` + `Ebook` du diagramme de classe.
/// Utilisé pour la page Bibliothèque.
class EbookModel {
  final int id;
  final String titre;
  final String typeEbook; // ex: "Roman", "Récit de vie"
  final String nomAuteur;
  final int anneeSortie;
  final String urlFichier; // PDF sur S3

  const EbookModel({
    required this.id,
    required this.titre,
    required this.typeEbook,
    required this.nomAuteur,
    required this.anneeSortie,
    required this.urlFichier,
  });

  factory EbookModel.fromJson(Map<String, dynamic> json) {
    final dateSortie = json['date_sortie'] as String?;
    return EbookModel(
      id: json['id_ebook'] as int? ?? json['id'] as int,
      titre: json['titre'] as String,
      typeEbook: json['type_ebook'] as String? ?? '',
      nomAuteur: json['nom_auteur'] as String? ?? '',
      anneeSortie: dateSortie != null
          ? DateTime.tryParse(dateSortie)?.year ?? 0
          : (json['annee'] as int? ?? 0),
      urlFichier: json['url_fichier'] as String,
    );
  }
}

/// Représente `Contenu` + `Brochure` du diagramme de classe.
/// Utilisé pour les pages Brochure et Sujet d'examen.
///
/// Pour Sujet d'examen, on réutilise la même structure :
///   editeur     <- module/classe
///   titre       <- titre du sujet
///   sousTitre   <- second titre (ex: "Corrige")
///   nomAuteur   <- auteur (badge orange)
///   annee       <- annee de l'epreuve
class BrochureModel {
  final int id;
  final String editeur; // badge en haut (ex: "Bembus", "PrepaDEF")
  final String titre;
  final String sousTitre; // 2e ligne du titre, optionnelle
  final String nomAuteur;
  final int annee;
  final String urlFichier; // PDF sur S3

  const BrochureModel({
    required this.id,
    required this.editeur,
    required this.titre,
    this.sousTitre = '',
    required this.nomAuteur,
    required this.annee,
    required this.urlFichier,
  });

  factory BrochureModel.fromJson(Map<String, dynamic> json) {
    final dateSortie = json['date_sortie'] as String?;
    final isSujetExamen = json['id_sujet'] != null;

    return BrochureModel(
      id: json['id_brochure'] as int? ?? json['id_sujet'] as int? ?? json['id'] as int,
      // Sujet d'examen : badge = classe (DEF, BAC...). Brochure : badge = module/éditeur.
      editeur: isSujetExamen
          ? (json['classe'] as String? ?? '')
          : (json['module'] as String? ?? ''),
      // Sujet d'examen : titre = matière (module). Brochure : vrai titre.
      titre: isSujetExamen
          ? (json['module'] as String? ?? 'Sujet')
          : (json['titre'] as String? ?? ''),
      sousTitre: json['sous_titre'] as String? ?? '',
      nomAuteur: json['nom_auteur'] as String? ?? '',
      annee: dateSortie != null
          ? DateTime.tryParse(dateSortie)?.year ?? 0
          : (json['annee'] as int? ?? 0),
      urlFichier: json['url_fichier'] as String,
    );
  }
}