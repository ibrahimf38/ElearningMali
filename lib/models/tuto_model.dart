class TutoVideo {
  final String matiere;
  final String titre;
  final String sousTitre;
  final String description;
  final String duree;
  final String thumbnail;
  final String domaine; // pour filtre par domaine
  final String urlVideo; // URL S3 (mp4)

  const TutoVideo({
    required this.matiere,
    required this.titre,
    this.sousTitre = '',
    required this.description,
    required this.duree,
    required this.thumbnail,
    required this.domaine,
    this.urlVideo = '',
  });
}

/// Catégories rapides affichées en tags ("Tout", "Math", "Physique"...)
const List<String> kTutoCategories = [
  'Tout', 'Math', 'Physique', 'Chimie', 'Francais', 'Anglais',
];

final List<TutoVideo> tutoVideos = [
  TutoVideo(
    matiere: 'Mathematique',
    titre: 'Mathematique',
    sousTitre: 'Les primitives constituent un concept fondamental en mathematiques',
    description:
        "Les primitives constituent un concept fondamental en mathematiques, "
        "notamment en analyse. Elles sont etroitement liees a la notion de "
        "derivee et permettent de comprendre le processus inverse de la "
        "derivation. Trouver une primitive d'une fonction, c'est determiner "
        "une fonction dont la derivee redonne la fonction initiale. Cette "
        "idee est essentielle pour resoudre de nombreux problemes, en "
        "particulier dans le calcul d'aires, l'etude des variations ou "
        "encore la modelisation de phenomenes physiques.\n"
        "Dans ce tutoriel d'introduction, l'objectif est de familiariser "
        "l'utilisateur avec les bases : comprendre ce qu'est une primitive, "
        "savoir reconnaitre les formes simples et appliquer les regles "
        "elementaires de calcul. On y decouvre egalement que toute fonction "
        "peut admettre une infinite de primitives qui differrent entre elles "
        "par une constante, appelee constante d'integration.",
    duree: '5:56',
    thumbnail: 'assets/images/tuto_math1.png',
    domaine: 'Secondaire',
    urlVideo: 'https://example-bucket.s3.amazonaws.com/tutoriels/math-primitives.mp4',
  ),
  TutoVideo(
    matiere: 'Chimie',
    titre: 'Chimie',
    description: 'Classification periodique des element chimi...',
    duree: '9:32',
    thumbnail: 'assets/images/tuto_chimie1.png',
    domaine: 'Secondaire',
    urlVideo: 'https://example-bucket.s3.amazonaws.com/tutoriels/chimie-classification.mp4',
  ),
  TutoVideo(
    matiere: 'Mathematique',
    titre: 'Mathematique',
    description: "tutoriel d'introduction sur les primitif ...",
    duree: '5:56',
    thumbnail: 'assets/images/tuto_math2.png',
    domaine: 'Secondaire',
    urlVideo: 'https://example-bucket.s3.amazonaws.com/tutoriels/math-primitives-2.mp4',
  ),
  TutoVideo(
    matiere: 'Chimie',
    titre: 'Chimie',
    description: 'Classification periodique des element chimi...',
    duree: '9:32',
    thumbnail: 'assets/images/tuto_chimie2.png',
    domaine: 'Secondaire',
    urlVideo: 'https://example-bucket.s3.amazonaws.com/tutoriels/chimie-classification-2.mp4',
  ),
  TutoVideo(
    matiere: 'Physique',
    titre: 'Physique',
    description: 'Les lois de Newton expliquees simplement ...',
    duree: '7:14',
    thumbnail: 'assets/images/tuto_physique1.png',
    domaine: 'Secondaire',
    urlVideo: 'https://example-bucket.s3.amazonaws.com/tutoriels/physique-newton.mp4',
  ),
  TutoVideo(
    matiere: 'Francais',
    titre: 'Francais',
    description: 'La conjugaison des verbes du premier groupe ...',
    duree: '4:20',
    thumbnail: 'assets/images/tuto_francais1.png',
    domaine: 'Fondamental',
    urlVideo: 'https://example-bucket.s3.amazonaws.com/tutoriels/francais-conjugaison.mp4',
  ),
];