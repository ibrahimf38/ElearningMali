import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/connexion_screen.dart';
import 'screens/inscription_screen.dart';
import 'screens/verification_screen.dart';
import 'screens/accueil_screen.dart';
import 'screens/cours_screen.dart';
import 'screens/tutoriel_screen.dart';
import 'screens/matiere_detail_screen.dart';
import 'screens/bibliotheque_screen.dart';
import 'screens/brochure_screen.dart';
import 'screens/sujets_examen_screen.dart';
import 'screens/tuto_player_screen.dart';
import 'screens/abonnement_screen.dart';
import 'screens/paiement_screen.dart';
import 'screens/paiement_succes_screen.dart';
import 'providers/abonnement_provider.dart';
import 'services/session_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Charge le token + infos client sauvegardés (si déjà connecté).
  await SessionManager.instance.loadSession();
  runApp(const ElearningApp());
}

class ElearningApp extends StatelessWidget {
  const ElearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = SessionManager.instance.isLoggedIn;

    return MaterialApp(
      title: 'Elearning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
        ),
        useMaterial3: true,
      ),
      // Si déjà connecté, on passe directement à l'accueil.
      initialRoute: isLoggedIn ? '/accueil' : '/onboarding',
      routes: {
        '/onboarding':   (_) => const OnboardingScreen(),
        '/connexion':    (_) => const ConnexionScreen(),
        '/inscription':  (_) => const InscriptionScreen(),
        '/verification': (_) => const VerificationScreen(),
        '/accueil':      (_) => const AccueilScreen(),
        '/cours':        (_) => const CoursScreen(),
        '/tutoriel':     (_) => const TutorielScreen(),
        '/matiere-detail': (_) => const MatiereDetailScreen(),
        '/bibliotheque':   (_) => const BibliothequeScreen(),
        '/brochure':       (_) => const BrochureScreen(),
        '/sujets':         (_) => const SujetsExamenScreen(),
        '/tuto-player':    (_) => const TutoPlayerScreen(),

        // ── Flux Abonnement / Paiement ────────────────────────
        // Un seul AbonnementProvider partagé entre les 3 écrans
        // (Abonnement -> Paiement -> Succès) via ChangeNotifierProvider
        // posé au-dessus du Navigator dans AbonnementFlow.
        '/abonnement': (_) => const AbonnementFlow(child: AbonnementScreen()),
        '/paiement':   (_) => const AbonnementFlow(child: PaiementScreen()),
        '/paiement-succes': (_) =>
            const AbonnementFlow(child: PaiementSuccesScreen()),
      },
    );
  }
}

/// Fournit un [AbonnementProvider] partagé pour tout le flux
/// Abonnement -> Paiement -> Succès, afin que la sélection de
/// méthode de paiement et le résultat de transaction soient
/// conservés entre les écrans de ce flux.
///
/// NOTE: Comme chaque route crée une nouvelle instance via
/// MaterialApp.routes, on utilise un Provider statique unique
/// (singleton applicatif) pour ce flux précis.
class AbonnementFlow extends StatelessWidget {
  final Widget child;
  const AbonnementFlow({super.key, required this.child});

  static final AbonnementProvider _sharedProvider = AbonnementProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _sharedProvider,
      child: child,
    );
  }
}