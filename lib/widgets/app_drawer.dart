import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../services/session_manager.dart';

class AppDrawer extends StatelessWidget {
  /// Infos du client connecté. Si null, on utilise automatiquement
  /// celles de la session courante (SessionManager).
  final ClientModel? client;

  const AppDrawer({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    final effectiveClient = client ?? SessionManager.instance.client;
    final nomComplet = effectiveClient?.nomComplet.isNotEmpty == true
        ? effectiveClient!.nomComplet
        : 'Utilisateur';
    final telephone = effectiveClient?.telephone.isNotEmpty == true
        ? effectiveClient!.telephone
        : '+223 00 00 00 00';

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── En-tête vert avec avatar ─────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: const BoxDecoration(
                color: Color(0xFF4A7C59),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 44, color: Color(0xFF4A7C59)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nomComplet,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    telephone,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Items menu ─────────────────────────────────────
            _DrawerItem(
              icon: Icons.workspace_premium_outlined,
              label: 'Abonement',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/abonnement');
              },
            ),
            _DrawerItem(
              icon: Icons.info_outline_rounded,
              label: 'A propos de nous',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/a-propos');
              },
            ),

            const Spacer(),

            // ── Déconnexion ──────────────────────────────────
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'Déconnexion',
              color: Colors.red,
              onTap: () async {
                await SessionManager.instance.clear();
                if (!context.mounted) return;
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/connexion', (route) => false);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFF1A1A2E);
    return ListTile(
      leading: Icon(icon, color: c),
      title: Text(
        label,
        style: TextStyle(
          color: c,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}