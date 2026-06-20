import 'package:flutter/material.dart';
import '../models/abonnement_model.dart';

/// Affiche le bottom sheet "Choisissez un mode de paiement"
/// (Image 2). Retourne la méthode choisie, ou null si annulé.
Future<MethodePaiement?> showPaymentMethodSheet(BuildContext context) {
  return showModalBottomSheet<MethodePaiement>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF8FAE93),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choisissez un mode de paiement',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 16),
            _PaymentOption(
              methode: MethodePaiement.orangeMoney,
              onTap: () => Navigator.pop(context, MethodePaiement.orangeMoney),
            ),
            const SizedBox(height: 10),
            _PaymentOption(
              methode: MethodePaiement.moovMoney,
              onTap: () => Navigator.pop(context, MethodePaiement.moovMoney),
            ),
          ],
        ),
      );
    },
  );
}

class _PaymentOption extends StatelessWidget {
  final MethodePaiement methode;
  final VoidCallback onTap;

  const _PaymentOption({required this.methode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOrange = methode == MethodePaiement.orangeMoney;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Logo
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Image.asset(
                isOrange
                    ? 'assets/images/orange.png'
                    : 'assets/images/moov.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  isOrange
                      ? Icons.call_made_rounded
                      : Icons.account_balance_wallet_rounded,
                  color: isOrange
                      ? const Color(0xFFFF6600)
                      : const Color(0xFFFF6600),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              methode.label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}