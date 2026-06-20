import 'cours_model_api.dart';

/// Données factices de leçons, indexées par nom de matière.
///
/// Utilisées en fallback dans [MatiereDetailScreen] tant que
/// l'API `/matieres/:id/cours` n'est pas branchée (le backend
/// est en cours de développement par l'équipe).
///
/// Une fois l'API prête, `idMatiere` réel sera transmis et
/// `ContenuService.getCoursByMatiere(idMatiere)` sera utilisé
/// à la place de ces données.
final Map<String, List<CoursModel>> mockCoursParMatiere = {
  'Language': [
    const CoursModel(
      id: 1,
      idMatiere: 0,
      titre: 'Le Mali',
      sousTitre: 'Situation géographique du Mali',
      urlFichier: 'https://example-bucket.s3.amazonaws.com/cours/le-mali.pdf',
    ),
    const CoursModel(
      id: 2,
      idMatiere: 0,
      titre: 'Les Royaume bamana',
      sousTitre: 'Le declin et la chite des royaumes de segou',
      urlFichier:
          'https://example-bucket.s3.amazonaws.com/cours/royaume-bamana.pdf',
    ),
    const CoursModel(
      id: 3,
      idMatiere: 0,
      titre: 'Irregulary verbe',
      sousTitre: 'Several type of irregulary verb in English',
      urlFichier:
          'https://example-bucket.s3.amazonaws.com/cours/irregular-verbs.pdf',
    ),
    const CoursModel(
      id: 4,
      idMatiere: 0,
      titre: 'Les Royaume bamana',
      sousTitre: 'Le declin et la chite des royaumes de segou',
      urlFichier:
          'https://example-bucket.s3.amazonaws.com/cours/royaume-bamana-2.pdf',
    ),
    const CoursModel(
      id: 5,
      idMatiere: 0,
      titre: 'Le Mali',
      sousTitre: 'Situation géographique du Mali',
      urlFichier:
          'https://example-bucket.s3.amazonaws.com/cours/le-mali-2.pdf',
    ),
    const CoursModel(
      id: 6,
      idMatiere: 0,
      titre: 'Irregulary verbe',
      sousTitre: 'Several type of irregulary verb in English',
      urlFichier:
          'https://example-bucket.s3.amazonaws.com/cours/irregular-verbs-2.pdf',
    ),
  ],
};

/// Retourne des leçons par défaut (réutilise "Language") pour
/// toute matière qui n'a pas encore de données factices dédiées,
/// afin que l'UI reste démontrable pour toutes les matières.
List<CoursModel> getMockCoursForMatiere(String nomMatiere) {
  return mockCoursParMatiere[nomMatiere] ?? mockCoursParMatiere['Language']!;
}