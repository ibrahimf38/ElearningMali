/// Configuration centrale de l'API backend (Node.js/Express).
///
/// Le backend est en cours de développement par l'équipe.
/// Une fois l'URL définitive connue, change uniquement `baseUrl`
/// ci-dessous (ou utilise --dart-define lors du build).
class ApiConfig {
  /// URL de base de l'API.
  /// Exemple final attendu : "https://api.elearning-mali.com/api"
  ///
  /// En développement local (émulateur Android) :
  ///   "http://10.0.2.2:3000/api"
  /// Sur device physique (même réseau) :
  ///   "http://192.168.x.x:3000/api"
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api',
  );

  // ── Endpoints Auth ──────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';

  // ── Endpoints Filtrage (Domaine -> Niveau -> Matiere) ───────
  static const String domaines = '/domaines';
  static String niveauxByDomaine(int idDomaine) =>
      '/domaines/$idDomaine/niveaux';
  static String matieresByNiveau(int idNiveau) =>
      '/niveaux/$idNiveau/matieres';

  /// Matières liées à un domaine pour la page Tutoriel
  /// (table d'association DomaineMatiereTutoriel)
  static String matieresByDomaineTuto(int idDomaine) =>
      '/domaines/$idDomaine/matieres-tutoriels';

  // ── Endpoints Contenus ───────────────────────────────────────
  static String coursByMatiere(int idMatiere) =>
      '/matieres/$idMatiere/cours';

  static String tutosByMatiere(int idMatiere) =>
      '/matieres/$idMatiere/tutoriels';

  /// Liste globale de tutoriels avec filtres optionnels
  /// ?id_domaine=...&id_matiere=...&search=...
  static const String tutoriels = '/tutoriels';

  static const String ebooks = '/ebooks';
  static const String brochures = '/brochures';
  static const String sujetsExamen = '/sujets-examen';

  // ── Endpoints Abonnement / Paiement ─────────────────────────
  static const String abonnement = '/abonnements';
  static const String paiementOrangeMoney = '/paiements/orange-money';
  static const String paiementMoovMoney = '/paiements/moov-money';
  static String paiementStatut(String idTransaction) =>
      '/paiements/$idTransaction/statut';

  // ── Headers communs ──────────────────────────────────────────
  static Map<String, String> headers({String? token}) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
}