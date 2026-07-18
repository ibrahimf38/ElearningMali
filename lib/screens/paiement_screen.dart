import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/abonnement_model.dart';
// import '../providers/abonnement_provider.dart';
// import 'orange_money_webview_screen.dart';

// class PaiementScreen extends StatefulWidget {
//   const PaiementScreen({super.key});

//   @override
//   State<PaiementScreen> createState() => _PaiementScreenState();
// }

// class _PaiementScreenState extends State<PaiementScreen> {
//   final _numeroController = TextEditingController();

//   @override
//   void dispose() {
//     _numeroController.dispose();
//     super.dispose();
//   }

//   Future<void> _lancerPaiement(
//     BuildContext context,
//     AbonnementProvider provider,
//     ForfaitModel forfait,
//   ) async {
//     final ok = await provider.initierPaiement();
//     if (!ok || !context.mounted) return;

//     if (provider.methodeSelectionnee == MethodePaiement.orangeMoney) {
//       // Ouvre la WebView Orange Money pour que le client confirme.
//       final paymentUrl = provider.initiation?.paymentUrl;
//       if (paymentUrl == null) return;

//       final returned = await Navigator.push<bool>(
//         context,
//         MaterialPageRoute(
//           builder: (_) => OrangeMoneyWebViewScreen(paymentUrl: paymentUrl),
//         ),
//       );

//       if (!context.mounted) return;

//       if (returned == true) {
//         // L'utilisateur est revenu depuis la page Orange -> on démarre
//         // le polling pour confirmer le statut réel du paiement.
//         provider.demarrerPolling();
//       } else {
//         // Fermeture manuelle de la WebView -> on laisse l'utilisateur
//         // réessayer depuis cet écran.
//         return;
//       }
//     }
//     // Pour Moov Money, le polling a déjà démarré automatiquement
//     // dans initierPaiement().

//     if (!context.mounted) return;
//     _attendreResultat(context, provider, forfait);
//   }

//   /// Affiche un dialog d'attente pendant le polling, puis redirige
//   /// vers l'écran de succès ou affiche l'erreur.
//   Future<void> _attendreResultat(
//     BuildContext context,
//     AbonnementProvider provider,
//     ForfaitModel forfait,
//   ) async {
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) => PopScope(
//         canPop: false,
//         child: Consumer<AbonnementProvider>(
//           builder: (context, p, _) {
//             if (p.status == PaiementStatus.success) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 Navigator.of(dialogContext).pop(); // ferme le dialog
//                 Navigator.pushReplacementNamed(
//                   context,
//                   '/paiement-succes',
//                   arguments: {
//                     'forfait': forfait,
//                     'methode': p.methodeSelectionnee,
//                     'numero': p.numeroTelephone,
//                     'idTransaction': p.initiation?.idTransaction,
//                   },
//                 );
//               });
//             } else if (p.status == PaiementStatus.error) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 Navigator.of(dialogContext).pop();
//               });
//             }

//             return AlertDialog(
//               backgroundColor: Colors.white,
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const CircularProgressIndicator(color: Color(0xFF2E7D32)),
//                   const SizedBox(height: 16.h),
//                   const Text(
//                     'Confirmation du paiement en cours...',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 14.sp),
//                   ),
//                   const SizedBox(height: 8.h),
//                   Text(
//                     p.methodeSelectionnee == MethodePaiement.moovMoney
//                         ? 'Vérifiez votre téléphone et confirmez avec votre code Moov Money.'
//                         : 'Veuillez patienter...',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 12.sp, color: Color(0xFF6B7280)),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final forfait =
//         ModalRoute.of(context)!.settings.arguments as ForfaitModel;
//     final provider = context.watch<AbonnementProvider>();
//     final methode = provider.methodeSelectionnee;

//     final isLoading = provider.status == PaiementStatus.initiating ||
//         provider.status == PaiementStatus.polling;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Header vert ─────────────────────────────────
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
//               decoration: const BoxDecoration(
//                 color: Color(0xFF7A9E7E),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(24),
//                   bottomRight: Radius.circular(24),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: const Icon(Icons.arrow_back,
//                         color: Color(0xFF1A1A2E), size: 24.sp),
//                   ),
//                   const SizedBox(width: 12.w),
//                   const Text(
//                     'Paiement',
//                     style: TextStyle(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1A1A2E),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // ── Corps ─────────────────────────────────────────
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.r),
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(20.r),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF8FAE93),
//                     borderRadius: BorderRadius.circular(18.r),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Center(
//                         child: Text(
//                           'Paiement',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 4.h),
//                       Center(
//                         child: Text(
//                           methode?.label ?? '',
//                           style: const TextStyle(
//                             fontSize: 14.sp,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 18.h),

//                       // Type de forfait / Montant
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('Type de forfais :',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 13.sp,
//                                         fontWeight: FontWeight.w600)),
//                                 const SizedBox(height: 4.h),
//                                 Text(forfait.typeForfait,
//                                     style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.bold)),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text('Montant :',
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 13.sp,
//                                         fontWeight: FontWeight.w600)),
//                                 const SizedBox(height: 4.h),
//                                 Text('${forfait.montant} FCFA',
//                                     style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.bold)),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 14.h),

//                       const Text('Description :',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w600)),
//                       const SizedBox(height: 4.h),
//                       Text(
//                         forfait.description,
//                         style: const TextStyle(
//                             color: Colors.white, fontSize: 13.sp, height: 1.4),
//                       ),

//                       const SizedBox(height: 18.h),
//                       Container(height: 1, color: Colors.white.withOpacity(0.3)),
//                       const SizedBox(height: 18.h),

//                       Text(
//                         methode == MethodePaiement.orangeMoney
//                             ? 'Vous serez redirigé vers une page sécurisée Orange Money pour confirmer le paiement avec votre code.'
//                             : 'Vous recevrez une notification sur votre téléphone Moov Money pour confirmer le paiement avec votre code PIN.',
//                         style: const TextStyle(
//                             color: Colors.white, fontSize: 13.sp, height: 1.5),
//                       ),
//                       const SizedBox(height: 12.h),

//                       // Logo méthode + label
//                       Row(
//                         children: [
//                           Container(
//                             width: 32.w,
//                             height: 32.h,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(8.r),
//                               border: Border.all(color: Colors.grey.shade200),
//                             ),
//                             child: Image.asset(
//                               methode == MethodePaiement.orangeMoney
//                                   ? 'assets/images/orange_money_logo.png'
//                                   : 'assets/images/moov_money_logo.png',
//                               fit: BoxFit.contain,
//                               errorBuilder: (_, __, ___) => Icon(
//                                 methode == MethodePaiement.orangeMoney
//                                     ? Icons.call_made_rounded
//                                     : Icons.account_balance_wallet_rounded,
//                                 color: const Color(0xFFFF6600),
//                                 size: 18.sp,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8.w),
//                           Text(
//                             methode?.label ?? '',
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13.sp),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12.h),

//                       const Text('Numéro de téléphone (8 chiffres) :',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w600)),
//                       const SizedBox(height: 8.h),

//                       TextField(
//                         controller: _numeroController,
//                         keyboardType: TextInputType.phone,
//                         maxLength: 8,
//                         onChanged: provider.setNumero,
//                         decoration: InputDecoration(
//                           hintText: 'Ex : 74XXXXXX',
//                           counterText: '',
//                           filled: true,
//                           fillColor: Colors.white,
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 14.w, vertical: 14.h),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),

//                       if (provider.errorMessage != null) ...[
//                         const SizedBox(height: 8.h),
//                         Text(
//                           provider.errorMessage!,
//                           style: const TextStyle(
//                               color: Color(0xFFFFCDD2), fontSize: 12.sp),
//                         ),
//                       ],

//                       const SizedBox(height: 16.h),
//                       Text(
//                         'En confirmant, vous reconnaissez avoir lu et '
//                         "approuvé les conditions générales d'utilisation du "
//                         'service.',
//                         style: TextStyle(
//                             color: Colors.white.withOpacity(0.85),
//                             fontSize: 11.5.sp,
//                             height: 1.4),
//                       ),

//                       const SizedBox(height: 18.h),

//                       // Boutons Annuler / Confirmer
//                       Row(
//                         children: [
//                           Expanded(
//                             child: OutlinedButton(
//                               onPressed: isLoading
//                                   ? null
//                                   : () => Navigator.pop(context),
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 side: BorderSide.none,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 14.h),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                 ),
//                               ),
//                               child: const Text('Annuler',
//                                   style: TextStyle(
//                                       color: Color(0xFF1A1A2E),
//                                       fontWeight: FontWeight.w600)),
//                             ),
//                           ),
//                           const SizedBox(width: 12.w),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: isLoading
//                                   ? null
//                                   : () => _lancerPaiement(
//                                       context, provider, forfait),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF2E7D32),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 14.h),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               child: isLoading
//                                   ? const SizedBox(
//                                       width: 20.w,
//                                       height: 20.h,
//                                       child: CircularProgressIndicator(
//                                         color: Colors.white,
//                                         strokeWidth: 2,
//                                       ),
//                                     )
//                                   : const Text('Confirmer',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w600)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






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
    if (!context.mounted) return;
    if (!ok) {
      // Petit message qui apparaît en bas de l'écran (SnackBar),
      // ex: "Vous avez déjà un abonnement actif".
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Une erreur est survenue.'),
          backgroundColor: const Color(0xFFC62828),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

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
      builder: (dialogContext) => ChangeNotifierProvider.value(
        // On passe directement l'instance du provider au dialog.
        // showDialog() utilise le root navigator par défaut, donc le
        // dialog n'est PAS forcément descendant du widget qui fournit
        // AbonnementProvider dans l'arbre — on ne peut pas compter sur
        // context.watch/Consumer pour le retrouver automatiquement.
        value: provider,
        child: PopScope(
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
                  CircularProgressIndicator(color: Color(0xFF2E7D32)),
                  SizedBox(height: 16.h),
                  Text(
                    'Confirmation du paiement en cours...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    p.methodeSelectionnee == MethodePaiement.moovMoney
                        ? 'Vérifiez votre téléphone et confirmez avec votre code Moov Money.'
                        : 'Veuillez patienter...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            );
            },
          ),
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
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              decoration: BoxDecoration(
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
                    child: Icon(Icons.arrow_back,
                        color: Color(0xFF1A1A2E), size: 24.sp),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Paiement',
                    style: TextStyle(
                      fontSize: 18.sp,
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
                padding: EdgeInsets.all(16.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Color(0xFF8FAE93),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Paiement',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Center(
                        child: Text(
                          methode?.label ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),

                      // Type de forfait / Montant
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Type de forfais :',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 4.h),
                                Text(forfait.typeForfait,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Montant :',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 4.h),
                                Text('${forfait.montant} FCFA',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),

                      Text('Description :',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 4.h),
                      Text(
                        forfait.description,
                        style: TextStyle(
                            color: Colors.white, fontSize: 13.sp, height: 1.4),
                      ),

                      SizedBox(height: 18.h),
                      Container(height: 1, color: Colors.white.withOpacity(0.3)),
                      SizedBox(height: 18.h),

                      Text(
                        methode == MethodePaiement.orangeMoney
                            ? 'Vous serez redirigé vers une page sécurisée Orange Money pour confirmer le paiement avec votre code.'
                            : 'Vous recevrez une notification sur votre téléphone Moov Money pour confirmer le paiement avec votre code PIN.',
                        style: TextStyle(
                            color: Colors.white, fontSize: 13.sp, height: 1.5),
                      ),
                      SizedBox(height: 12.h),

                      // Logo méthode + label
                      Row(
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
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
                                color: Color(0xFFFF6600),
                                size: 18.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            methode?.label ?? '',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      Text('Numéro de téléphone (8 chiffres) :',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),

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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 14.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      if (provider.errorMessage != null) ...[
                        SizedBox(height: 8.h),
                        Text(
                          provider.errorMessage!,
                          style: TextStyle(
                              color: Color(0xFFFFCDD2), fontSize: 12.sp),
                        ),
                      ],

                      SizedBox(height: 16.h),
                      Text(
                        'En confirmant, vous reconnaissez avoir lu et '
                        "approuvé les conditions générales d'utilisation du "
                        'service.',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11.5.sp,
                            height: 1.4),
                      ),

                      SizedBox(height: 18.h),

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
                                padding: EdgeInsets.symmetric(
                                    vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: const Text('Annuler',
                                  style: TextStyle(
                                      color: Color(0xFF1A1A2E),
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _lancerPaiement(
                                      context, provider, forfait),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.h,
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
