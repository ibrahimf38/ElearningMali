import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/abonnement_model.dart';
import '../providers/abonnement_provider.dart';
import '../widgets/payment_method_sheet.dart';

class AbonnementScreen extends StatefulWidget {
  const AbonnementScreen({super.key});

  @override
  State<AbonnementScreen> createState() => _AbonnementScreenState();
}

class _AbonnementScreenState extends State<AbonnementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AbonnementProvider>().chargerHistorique();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _AbonnementView();
  }
}

class _AbonnementView extends StatelessWidget {
  const _AbonnementView();

  Future<void> _ouvrirChoixPaiement(BuildContext context) async {
    final provider = context.read<AbonnementProvider>();
    provider.reset();

    final methode = await showPaymentMethodSheet(context);
    if (methode == null) return;

    provider.selectionnerMethode(methode);

    if (context.mounted) {
      Navigator.pushNamed(
        context,
        '/paiement',
        arguments: kForfaitDecouverte,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AbonnementProvider>();

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
                    'Abonement',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card forfait Découverte
                    GestureDetector(
                      onTap: () => _ouvrirChoixPaiement(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9C9C9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.local_offer_outlined,
                                size: 90,
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${kForfaitDecouverte.typeForfait} :  ${kForfaitDecouverte.montant} F',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  kForfaitDecouverte.description,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Historique  d'abonnement",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Historique
                    if (provider.isLoadingHistorique)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      )
                    else if (provider.historique.isEmpty)
                      _buildEmptyState()
                    else
                      Column(
                        children: provider.historique
                            .map((a) => _HistoriqueTile(abonnement: a))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Icon(
          Icons.not_interested_rounded,
          size: 70,
          color: Color(0xFFD9D9D9),
        ),
      ),
    );
  }
}

class _HistoriqueTile extends StatelessWidget {
  final AbonnementModel abonnement;

  const _HistoriqueTile({required this.abonnement});

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final isActif = abonnement.estActif;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActif
                  ? const Color(0xFF2E7D32).withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActif ? Icons.check_circle : Icons.history_rounded,
              color: isActif ? const Color(0xFF2E7D32) : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${abonnement.typeForfait} - ${abonnement.montant} F',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatDate(abonnement.dateDebut)} → ${_formatDate(abonnement.dateFin)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isActif
                  ? const Color(0xFF2E7D32).withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isActif ? 'Actif' : 'Expiré',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActif ? const Color(0xFF2E7D32) : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}