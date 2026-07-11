import 'package:flutter/material.dart';
import 'paiement_service.dart';
import 'session_manager.dart';

/// Vérifie si le client connecté a un abonnement actif.
/// Si oui → exécute [onAbonne].
/// Si non → affiche un dialog et redirige vers /abonnement.
Future<void> verifierAbonnementEtAcceder({
  required BuildContext context,
  required VoidCallback onAbonne,
  PaiementService? service,
}) async {
  if (!context.mounted) return;

  if (!SessionManager.instance.isLoggedIn) {
    if (!context.mounted) return;
    _showConnexionDialog(context);
    return;
  }

  try {
    final paiementService = service ?? PaiementService();
    final historique = await paiementService.getHistorique();

    if (!context.mounted) return;

    final aAbonnementActif = historique.any((a) => a.estActif);

    if (aAbonnementActif) {
      onAbonne();
    } else {
      _showAbonnementDialog(context);
    }
  } catch (_) {
    // En cas d'erreur réseau, on laisse accéder (fail-open)
    // pour ne pas bloquer l'utilisateur inutilement.
    if (!context.mounted) return;
    onAbonne();
  }
}

void _showConnexionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        '🔐 Connexion requise',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Vous devez être connecté pour accéder à ce contenu.',
        style: TextStyle(fontSize: 14, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Plus tard', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            if (context.mounted) {
              Navigator.of(context).pushNamed('/connexion');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Se connecter'),
        ),
      ],
    ),
  );
}

void _showAbonnementDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        '🔒 Contenu réservé',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'Ce contenu est réservé aux abonnés.\n\n'
        'Abonnez-vous pour accéder à tous nos cours, tutoriels, ebooks et bien plus encore !',
        style: TextStyle(fontSize: 14, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Plus tard', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            if (context.mounted) {
              Navigator.of(context).pushNamed('/abonnement');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("S'abonner"),
        ),
      ],
    ),
  );
}
