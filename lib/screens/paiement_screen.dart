import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/abonnement_model.dart';
import '../providers/abonnement_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final forfait =
        ModalRoute.of(context)!.settings.arguments as ForfaitModel;
    final provider = context.watch<AbonnementProvider>();
    final methode = provider.methodeSelectionnee;

    final isLoading = provider.status == PaiementStatus.loading;

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
                        'Votre paiement sera effectué via le service ${methode?.label ?? ''}.\n'
                        'Merci de saisir votre numéro de téléphone pour continuer la transaction :',
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
                                  ? 'assets/images/orange.png'
                                  : 'assets/images/moov.png',
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
                                  : () async {
                                      final success = await provider
                                          .confirmerPaiement(forfait);
                                      if (success && context.mounted) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/paiement-succes',
                                          arguments: {
                                            'forfait': forfait,
                                            'methode': methode,
                                            'numero':
                                                provider.numeroTelephone,
                                            'idTransaction': provider
                                                .lastResult?.idTransaction,
                                          },
                                        );
                                      }
                                    },
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