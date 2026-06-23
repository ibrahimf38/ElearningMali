// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../widgets/auth_header.dart';

// class InscriptionScreen extends StatelessWidget {
//   const InscriptionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => AuthProvider(),
//       child: const _InscriptionView(),
//     );
//   }
// }

// class _InscriptionView extends StatefulWidget {
//   const _InscriptionView();

//   @override
//   State<_InscriptionView> createState() => _InscriptionViewState();
// }

// class _InscriptionViewState extends State<_InscriptionView> {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();

//   @override
//   void dispose() {
//     _nameController.dispose();
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
//                 title: "S'inscrire",
//                 onBack: () => Navigator.pop(context),
//               ),

//               // ── Formulaire ───────────────────────────────────
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Creer un compte\npour se connecter',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1A1A2E),
//                         height: 1.3,
//                       ),
//                     ),
//                     const SizedBox(height: 28),

//                     // Champ Nom complet
//                     TextField(
//                       controller: _nameController,
//                       onChanged: auth.setFullName,
//                       textCapitalization: TextCapitalization.words,
//                       decoration: _inputDecoration('Nom complet'),
//                     ),
//                     const SizedBox(height: 16),

//                     // Champ Téléphone
//                     TextField(
//                       controller: _phoneController,
//                       keyboardType: TextInputType.phone,
//                       onChanged: auth.setPhone,
//                       decoration:
//                           _inputDecoration('+223 Numero de telephone'),
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

//                     // Bouton Inscrivez-vous
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: auth.isLoading
//                             ? null
//                             : () async {
//                                 final ok = await auth.register();
//                                 if (ok && context.mounted) {
//                                   Navigator.pushReplacementNamed(
//                                     context,
//                                     '/verification',
//                                     arguments: auth.phoneNumber,
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
//                                 'Inscrivez-vous',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600),
//                               ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Lien Se connecter
//                     Center(
//                       child: GestureDetector(
//                         onTap: () => Navigator.pushReplacementNamed(
//                             context, '/connexion'),
//                         child: RichText(
//                           text: const TextSpan(
//                             text: "j'ai deja un compte? ",
//                             style: TextStyle(
//                               color: Color(0xFF6B7280), fontSize: 14),
//                             children: [
//                               TextSpan(
//                                 text: "Se connecter",
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

//   InputDecoration _inputDecoration(String hint) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
//       contentPadding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide:
//             const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';

class InscriptionScreen extends StatelessWidget {
  const InscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const _InscriptionView(),
    );
  }
}

class _InscriptionView extends StatefulWidget {
  const _InscriptionView();

  @override
  State<_InscriptionView> createState() => _InscriptionViewState();
}

class _InscriptionViewState extends State<_InscriptionView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
                title: "S'inscrire",
                onBack: () => Navigator.pop(context),
              ),

              // ── Formulaire ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Creer un compte\npour se connecter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Champ Nom complet
                    TextField(
                      controller: _nameController,
                      onChanged: auth.setFullName,
                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDecoration('Nom complet'),
                    ),
                    const SizedBox(height: 16),

                    // Champ Téléphone
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: auth.setPhone,
                      decoration:
                          _inputDecoration('+223 Numero de telephone'),
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

                    // Bouton Inscrivez-vous
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                final ok = await auth.register();
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
                                'Inscrivez-vous',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Lien Se connecter
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, '/connexion'),
                        child: RichText(
                          text: const TextSpan(
                            text: "j'ai deja un compte? ",
                            style: TextStyle(
                              color: Color(0xFF6B7280), fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Se connecter",
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
      ),
    );
  }
}