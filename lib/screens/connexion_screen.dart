// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../widgets/auth_header.dart';

// class ConnexionScreen extends StatelessWidget {
//   const ConnexionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => AuthProvider(),
//       child: const _ConnexionView(),
//     );
//   }
// }

// class _ConnexionView extends StatefulWidget {
//   const _ConnexionView();

//   @override
//   State<_ConnexionView> createState() => _ConnexionViewState();
// }

// class _ConnexionViewState extends State<_ConnexionView> {
//   final _phoneController = TextEditingController();

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Header vert ──────────────────────────────────
//               AuthHeader(
//                 title: 'Se connecter',
//                 onBack: () => Navigator.pop(context),
//               ),

//               // ── Formulaire ───────────────────────────────────
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Connecter\nvous a votre compte',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1A1A2E),
//                         height: 1.3,
//                       ),
//                     ),
//                     const SizedBox(height: 28),

//                     // Champ téléphone
//                     TextField(
//                       controller: _phoneController,
//                       keyboardType: TextInputType.phone,
//                       onChanged: auth.setPhone,
//                       decoration: InputDecoration(
//                         hintText: '+223 Numero de telephone',
//                         hintStyle: const TextStyle(
//                           color: Color(0xFF9E9E9E),
//                           fontSize: 14,
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 16),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(
//                             color: Color(0xFF2E7D32), width: 1.5),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: const BorderSide(
//                             color: Color(0xFF2E7D32), width: 2),
//                         ),
//                       ),
//                     ),

//                     // Message d'erreur
//                     if (auth.errorMessage != null) ...[
//                       const SizedBox(height: 8),
//                       Text(
//                         auth.errorMessage!,
//                         style: const TextStyle(
//                           color: Colors.red, fontSize: 13),
//                       ),
//                     ],

//                     const SizedBox(height: 24),

//                     // Bouton Connectez-vous
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: auth.isLoading
//                             ? null
//                             : () async {
//                                 final ok = await auth.login();
//                                 if (ok && context.mounted) {
//                                   Navigator.pushReplacementNamed(
//                                     context,
//                                     '/verification',
//                                     arguments: auth.phoneNumberE164,
//                                   );
//                                 }
//                               },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF2E7D32),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                           elevation: 0,
//                         ),
//                         child: auth.isLoading
//                             ? const SizedBox(
//                                 width: 22, height: 22,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white, strokeWidth: 2),
//                               )
//                             : const Text(
//                                 'Connectez-vous',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600),
//                               ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Lien S'inscrire
//                     Center(
//                       child: GestureDetector(
//                         onTap: () => Navigator.pushNamed(
//                             context, '/inscription'),
//                         child: RichText(
//                           text: const TextSpan(
//                             text: "je n'ai pas de compte? ",
//                             style: TextStyle(
//                               color: Color(0xFF6B7280), fontSize: 14),
//                             children: [
//                               TextSpan(
//                                 text: "S'inscrire",
//                                 style: TextStyle(
//                                   color: Color(0xFF2E7D32),
//                                   fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/phone_input_field.dart';

class ConnexionScreen extends StatelessWidget {
  const ConnexionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const _ConnexionView(),
    );
  }
}

class _ConnexionView extends StatefulWidget {
  const _ConnexionView();

  @override
  State<_ConnexionView> createState() => _ConnexionViewState();
}

class _ConnexionViewState extends State<_ConnexionView> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header vert ──────────────────────────────────
              AuthHeader(
                title: 'Se connecter',
                onBack: () => Navigator.pop(context),
              ),

              // ── Formulaire ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Connecter\nvous a votre compte',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Champ téléphone — préfixe +223 fixe, non éditable
                    PhoneInputField(
                      controller: _phoneController,
                      onChanged: auth.setPhone,
                    ),

                    // Message d'erreur
                    if (auth.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        auth.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red, fontSize: 13),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Bouton Connectez-vous
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                final ok = await auth.login();
                                if (ok && context.mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/verification',
                                    arguments: auth.phoneNumberE164,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Connectez-vous',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Lien S'inscrire
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, '/inscription'),
                        child: RichText(
                          text: const TextSpan(
                            text: "je n'ai pas de compte? ",
                            style: TextStyle(
                              color: Color(0xFF6B7280), fontSize: 14),
                            children: [
                              TextSpan(
                                text: "S'inscrire",
                                style: TextStyle(
                                  color: Color(0xFF2E7D32),
                                  fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
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
    );
  }
}