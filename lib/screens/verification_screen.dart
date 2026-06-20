import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupère le numéro passé par ConnexionScreen / InscriptionScreen.
    final telephone =
        ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return ChangeNotifierProvider(
      create: (_) => AuthProvider()
        ..setPhone(telephone)
        ..startTimer(),
      child: const _VerificationView(),
    );
  }
}

class _VerificationView extends StatelessWidget {
  const _VerificationView();

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
                title: 'Verification',
                onBack: () => Navigator.pop(context),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Entre votre\ncode de verification',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── 4 cases OTP ───────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (i) =>
                        _OtpBox(index: i),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // // ── DEBUG TEMPORAIRE — à retirer après diagnostic ──
                    // Container(
                    //   padding: const EdgeInsets.all(8),
                    //   color: Colors.yellow.shade100,
                    //   child: Text(
                    //     'DEBUG → tel: "${auth.phoneNumber}" | otp: "${auth.otpDigits.join("-")}" | complete: ${auth.otpComplete} | loading: ${auth.isLoading} | error: ${auth.errorMessage}',
                    //     style: const TextStyle(fontSize: 10, color: Colors.black87),
                    //   ),
                    // ),
                    // const SizedBox(height: 8),

                    // Timer
                    Text(
                      auth.timerText,
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Message info
                    const Text(
                      'Nous avons envoyé un code de vérification à votre numéro de téléphone.Veuillez consulter vos SMS.',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Bouton Verifier
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: (!auth.otpComplete || auth.isLoading)
                            ? null
                            : () async {
                                final ok = await auth.verifyOtp();
                                if (ok && context.mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, '/accueil');
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          disabledBackgroundColor:
                              const Color(0xFF2E7D32).withOpacity(0.5),
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
                                'Verifier',
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

                    // Renvoi code si timer expiré
                    if (auth.timerExpired) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: GestureDetector(
                          onTap: () => auth.resendOtp(),
                          child: const Text(
                            'Renvoyer le code',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
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

// ── Widget case OTP individuelle ────────────────────────────────
class _OtpBox extends StatefulWidget {
  final int index;
  const _OtpBox({required this.index});

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return SizedBox(
      width: 64,
      height: 64,
      child: TextField(
        controller: _controller,
        focusNode: _focus,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A2E),
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF2E7D32), width: 2.5),
          ),
        ),
        onChanged: (val) {
          auth.setOtpDigit(widget.index, val);
          if (val.isNotEmpty && widget.index < 3) {
            // Passer à la case suivante
            FocusScope.of(context).nextFocus();
          } else if (val.isEmpty && widget.index > 0) {
            // Revenir à la case précédente
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}