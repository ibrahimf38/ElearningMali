import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/abonnement_model.dart';
import '../providers/abonnement_provider.dart';
import 'orange_money_webview_screen.dart';

class PaiementScreen extends StatefulWidget {
  const PaiementScreen({super.key});

  @override
  State<PaiementScreen> createState() => _PaiementScreenState();
}

class _PaiementScreenState extends State<PaiementScreen> {
  final _numeroController = TextEditingController();

  @override
  void dispose() {
    _numeroController.dispose();
    super.dispose();
  }

  Future<void> _lancerPaiement(
    BuildContext context,
    AbonnementProvider provider,
    ForfaitModel forfait,
  ) async {
    final ok = await provider.initierPaiement();
    if (!ok || !context.mounted) return;

    if (provider.methodeSelectionnee == MethodePaiement.orangeMoney) {
      // Ouvre la WebView Orange Money pour que le client confirme.
      final paymentUrl = provider.initiation?.paymentUrl;
      if (paymentUrl == null) return;

      final returned = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => OrangeMoneyWebViewScreen(paymentUrl: paymentUrl),
        ),
      );

      if (!context.mounted) return;

      if (returned == true) {
        // L'utilisateur est revenu depuis la page Orange -> on démarre
        // le polling pour confirmer le statut réel du paiement.
        provider.demarrerPolling();
      } else {
        // Fermeture manuelle de la WebView -> on laisse l'utilisateur
        // réessayer depuis cet écran.
        return;
      }
    }
    // Pour Moov Money, le polling a déjà démarré automatiquement
    // dans initierPaiement().

    if (!context.mounted) return;
    _attendreResultat(context, provider, forfait);
  }

  /// Affiche un dialog d'attente pendant le polling, puis redirige
  /// vers l'écran de succès ou affiche l'erreur.
  Future<void> _attendreResultat(
    BuildContext context,
    AbonnementProvider provider,
    ForfaitModel forfait,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: Consumer<AbonnementProvider>(
          builder: (context, p, _) {
            if (p.status == PaiementStatus.success) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(dialogContext).pop(); // ferme le dialog
                Navigator.pushReplacementNamed(
                  context,
                  '/paiement-succes',
                  arguments: {
                    'forfait': forfait,
                    'methode': p.methodeSelectionnee,
                    'numero': p.numeroTelephone,
                    'idTransaction': p.initiation?.idTransaction,
                  },
                );
              });
            } else if (p.status == PaiementStatus.error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(dialogContext).pop();
              });
            }

            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF2E7D32)),
                  const SizedBox(height: 16),
                  const Text(
                    'Confirmation du paiement en cours...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.methodeSelectionnee == MethodePaiement.moovMoney
                        ? 'Vérifiez votre téléphone et confirmez avec votre code Moov Money.'
                        : 'Veuillez patienter...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final forfait =
        ModalRoute.of(context)!.settings.arguments as ForfaitModel;
    final provider = context.watch<AbonnementProvider>();
    final methode = provider.methodeSelectionnee;

    final isLoading = provider.status == PaiementStatus.initiating ||
        provider.status == PaiementStatus.polling;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header vert ─────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF7A9E7E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Color(0xFF1A1A2E), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Paiement',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            // ── Corps ─────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8FAE93),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Paiement',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          methode?.label ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Type de forfait / Montant
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Type de forfais :',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(forfait.typeForfait,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Montant :',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text('${forfait.montant} FCFA',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      const Text('Description :',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(
                        forfait.description,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13, height: 1.4),
                      ),

                      const SizedBox(height: 18),
                      Container(height: 1, color: Colors.white.withOpacity(0.3)),
                      const SizedBox(height: 18),

                      Text(
                        methode == MethodePaiement.orangeMoney
                            ? 'Vous serez redirigé vers une page sécurisée Orange Money pour confirmer le paiement avec votre code.'
                            : 'Vous recevrez une notification sur votre téléphone Moov Money pour confirmer le paiement avec votre code PIN.',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13, height: 1.5),
                      ),
                      const SizedBox(height: 12),

                      // Logo méthode + label
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Image.asset(
                              methode == MethodePaiement.orangeMoney
                                  ? 'assets/images/orange_money_logo.png'
                                  : 'assets/images/moov_money_logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                methode == MethodePaiement.orangeMoney
                                    ? Icons.call_made_rounded
                                    : Icons.account_balance_wallet_rounded,
                                color: const Color(0xFFFF6600),
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            methode?.label ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      const Text('Numéro de téléphone (8 chiffres) :',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),

                      TextField(
                        controller: _numeroController,
                        keyboardType: TextInputType.phone,
                        maxLength: 8,
                        onChanged: provider.setNumero,
                        decoration: InputDecoration(
                          hintText: 'Ex : 74XXXXXX',
                          counterText: '',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      if (provider.errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          provider.errorMessage!,
                          style: const TextStyle(
                              color: Color(0xFFFFCDD2), fontSize: 12),
                        ),
                      ],

                      const SizedBox(height: 16),
                      Text(
                        'En confirmant, vous reconnaissez avoir lu et '
                        "approuvé les conditions générales d'utilisation du "
                        'service.',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11.5,
                            height: 1.4),
                      ),

                      const SizedBox(height: 18),

                      // Boutons Annuler / Confirmer
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide.none,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Annuler',
                                  style: TextStyle(
                                      color: Color(0xFF1A1A2E),
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _lancerPaiement(
                                      context, provider, forfait),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Confirmer',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}