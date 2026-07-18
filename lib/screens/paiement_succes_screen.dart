import 'package:flutter/material.dart';
import '../models/abonnement_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaiementSuccesScreen extends StatelessWidget {
  const PaiementSuccesScreen({super.key});

  String _formatDate(DateTime d) {
    const mois = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    return '${d.day} ${mois[d.month - 1]} ${d.year} à ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final forfait = args['forfait'] as ForfaitModel;
    final methode = args['methode'] as MethodePaiement?;
    final numero = args['numero'] as String;
    final idTransaction = (args['idTransaction'] as String?) ??
        'TXN-${DateTime.now().millisecondsSinceEpoch}';

    final now = DateTime.now();
    final dateFin = now.add(Duration(days: forfait.dureeJours));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header vert avec icône succès ────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
              decoration: BoxDecoration(
                color: Color(0xFF7A9E7E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_rounded,
                        color: Color(0xFF2E7D32), size: 42.sp),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Paiement réussi !',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Votre abonnement est maintenant actif',
                    style: TextStyle(fontSize: 13.sp, color: Colors.white),
                  ),
                ],
              ),
            ),

            // ── Facture ───────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Facture',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Color(0xFF2E7D32).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Payé',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Référence : $idTransaction',
                        style: TextStyle(
                            fontSize: 12.sp, color: Color(0xFF6B7280)),
                      ),
                      SizedBox(height: 20.h),
                      _FactureRow(label: 'Forfait', value: forfait.typeForfait),
                      _FactureRow(
                          label: 'Montant', value: '${forfait.montant} FCFA'),
                      _FactureRow(
                          label: 'Mode de paiement',
                          value: methode?.label ?? '-'),
                      _FactureRow(label: 'Numéro', value: numero),
                      _FactureRow(
                          label: 'Date de paiement', value: _formatDate(now)),
                      SizedBox(height: 16.h),
                      Container(height: 1, color: Colors.grey.shade200),
                      SizedBox(height: 16.h),
                      _FactureRow(
                        label: 'Début abonnement',
                        value: '${now.day}/${now.month}/${now.year}',
                      ),
                      _FactureRow(
                        label: 'Fin abonnement',
                        value:
                            '${dateFin.day}/${dateFin.month}/${dateFin.year}',
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color: Color(0xFF2E7D32), size: 18.sp),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Vous avez maintenant accès à toutes nos ressources pendant 1 mois.',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Color(0xFF2E7D32),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bouton retour accueil ──────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 16.h),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/accueil', (route) => false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Retour à l'accueil",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
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

class _FactureRow extends StatelessWidget {
  final String label;
  final String value;

  const _FactureRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 13.sp, color: Color(0xFF6B7280))),
          Text(value,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E))),
        ],
      ),
    );
  }
}
