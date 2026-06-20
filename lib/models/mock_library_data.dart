import 'library_models.dart';

/// ─────────────────────────────────────────────────────────────
/// Données factices (fallback dev) tant que le backend n'est pas
/// branché. À remplacer par les appels API correspondants.
/// ─────────────────────────────────────────────────────────────

final List<EbookModel> mockEbooks = [
  const EbookModel(
    id: 1,
    titre: "Sous l'orage",
    typeEbook: 'Roman',
    nomAuteur: 'Seydou Badian',
    anneeSortie: 1957,
    urlFichier: 'https://example-bucket.s3.amazonaws.com/ebooks/sous-orage.pdf',
  ),
  const EbookModel(
    id: 2,
    titre: 'L\'Enfant noir',
    typeEbook: 'Récit de vie',
    nomAuteur: 'Camara Laye',
    anneeSortie: 1953,
    urlFichier: 'https://example-bucket.s3.amazonaws.com/ebooks/enfant-noir.pdf',
  ),
  const EbookModel(
    id: 3,
    titre: 'Le Sang des masques',
    typeEbook: 'Roman',
    nomAuteur: 'Seydou Badian',
    anneeSortie: 1976,
    urlFichier: 'https://example-bucket.s3.amazonaws.com/ebooks/sang-masques.pdf',
  ),
  const EbookModel(
    id: 4,
    titre: 'La Grève des battù',
    typeEbook: 'Roman',
    nomAuteur: 'Aminata Sow Fall',
    anneeSortie: 1979,
    urlFichier: 'https://example-bucket.s3.amazonaws.com/ebooks/greve-battu.pdf',
  ),
];

final List<BrochureModel> mockBrochures = [
  const BrochureModel(
    id: 1,
    editeur: 'Bembus',
    titre: 'Economie',
    sousTitre: 'Terminale',
    nomAuteur: 'Bemba Camara',
    annee: 2024,
    urlFichier: 'https://example-bucket.s3.amazonaws.com/brochures/economie-terminale.pdf',
  ),
  const BrochureModel(
    id: 2,
    editeur: 'PrepaDEF',
    titre: 'Exercice',
    sousTitre: 'Corrige',
    nomAuteur: 'Moussa Traore',
    annee: 2022,
    urlFichier: 'https://example-bucket.s3.amazonaws.com/brochures/exercice-corrige.pdf',
  ),
  const BrochureModel(
    id: 3,
    editeur: 'SuccesCAP',
    titre: 'Exercice',
    sousTitre: 'Electro-Mecavique',
    nomAuteur: 'Lamine Diarra',
    annee: 2026,
    urlFichier: 'https://example-bucket.s3.amazonaws.com/brochures/exercice-electro.pdf',
  ),
];

final List<BrochureModel> mockSujetsExamen = [
  const BrochureModel(
    id: 1,
    editeur: 'DEF',
    titre: 'Mathematique',
    sousTitre: 'Sujet + Corrige',
    nomAuteur: 'Ministere Education',
    annee: 2024,
    urlFichier: 'https://example-bucket.s3.amazonaws.com/sujets/def-math-2024.pdf',
  ),
  const BrochureModel(
    id: 2,
    editeur: 'BAC',
    titre: 'Physique-Chimie',
    sousTitre: 'Serie TSE',
    nomAuteur: 'Ministere Education',
    annee: 2023,
    urlFichier: 'https://example-bucket.s3.amazonaws.com/sujets/bac-pc-2023.pdf',
  ),
  const BrochureModel(
    id: 3,
    editeur: 'BAC',
    titre: 'Francais',
    sousTitre: 'Toutes series',
    nomAuteur: 'Ministere Education',
    annee: 2025,
    urlFichier: 'https://example-bucket.s3.amazonaws.com/sujets/bac-francais-2025.pdf',
  ),
];