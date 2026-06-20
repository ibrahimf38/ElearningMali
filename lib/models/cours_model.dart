class NiveauData {
  final String label;
  final List<String> matieres;

  const NiveauData({required this.label, required this.matieres});
}

final Map<String, List<NiveauData>> coursData = {
  'Fondamental': [
    NiveauData(label: '1ere', matieres: [
      'Language', 'Lecture', 'Chante', 'Calcule', 'Ortographe', 'Compte', 'Ecriture',
    ]),
    NiveauData(label: '2eme', matieres: [
      'Language', 'Lecture', 'Calcule', 'Ortographe', 'Ecriture',
    ]),
    NiveauData(label: '3eme', matieres: [
      'Language', 'Calcule', 'Ortographe', 'Ecriture', 'Sciences',
    ]),
    NiveauData(label: '4eme', matieres: [
      'Language', 'Calcule', 'Sciences', 'Histoire', 'Geographie',
    ]),
  ],
  'Secondaire': [
    NiveauData(label: '1ere', matieres: [
      'Mathematique', 'Physique', 'Chimie', 'Francais', 'Anglais', 'Histoire',
    ]),
    NiveauData(label: '2eme', matieres: [
      'Mathematique', 'Physique', 'Chimie', 'SVT', 'Francais', 'Anglais',
    ]),
    NiveauData(label: '3eme', matieres: [
      'Mathematique', 'Physique', 'Chimie', 'SVT', 'Philosophie',
    ]),
    NiveauData(label: '4eme', matieres: [
      'Mathematique', 'Physique', 'Chimie', 'Philosophie', 'Anglais',
    ]),
  ],
  'Universitaire': [
    NiveauData(label: '1ere', matieres: [
      'Algebre', 'Analyse', 'Informatique', 'Anglais',
    ]),
    NiveauData(label: '2eme', matieres: [
      'Algebre', 'Analyse', 'Statistiques', 'Informatique',
    ]),
    NiveauData(label: '3eme', matieres: [
      'Probabilites', 'Algorithmique', 'Bases de donnees',
    ]),
    NiveauData(label: '4eme', matieres: [
      'Reseaux', 'Intelligence artificielle', 'Projet tutore',
    ]),
  ],
  'Technique': [
    NiveauData(label: '1ere', matieres: [
      'Electricite', 'Mecanique', 'Dessin technique',
    ]),
    NiveauData(label: '2eme', matieres: [
      'Electronique', 'Mecanique', 'Automatisme',
    ]),
    NiveauData(label: '3eme', matieres: [
      'Electronique', 'Automatisme', 'Maintenance',
    ]),
    NiveauData(label: '4eme', matieres: [
      'Robotique', 'Maintenance', 'Projet technique',
    ]),
  ],
  'Art-culture': [
    NiveauData(label: '1ere', matieres: [
      'Dessin', 'Musique', "Histoire de l'art",
    ]),
    NiveauData(label: '2eme', matieres: [
      'Peinture', 'Musique', 'Theatre',
    ]),
    NiveauData(label: '3eme', matieres: [
      'Peinture', 'Sculpture', 'Theatre',
    ]),
    NiveauData(label: '4eme', matieres: [
      'Arts plastiques', 'Cinema', 'Projet artistique',
    ]),
  ],
  'Defense': [
    NiveauData(label: '1ere', matieres: [
      'Education civique', 'Sport', 'Discipline',
    ]),
    NiveauData(label: '2eme', matieres: [
      'Education civique', 'Sport', 'Strategie',
    ]),
    NiveauData(label: '3eme', matieres: [
      'Strategie', 'Logistique', 'Sport',
    ]),
    NiveauData(label: '4eme', matieres: [
      'Strategie avancee', 'Logistique', 'Commandement',
    ]),
  ],
};