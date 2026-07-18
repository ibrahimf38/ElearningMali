import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entre votre\ncode de verification',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // ── 4 cases OTP ───────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (i) =>
                        _OtpBox(index: i),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // // ── DEBUG TEMPORAIRE — à retirer après diagnostic ──
                    // Container(
                    //   padding: const EdgeInsets.all(8.r),
                    //   color: Colors.yellow.shade100,
                    //   child: Text(
                    //     'DEBUG → tel: "${auth.phoneNumber}" | otp: "${auth.otpDigits.join("-")}" | complete: ${auth.otpComplete} | loading: ${auth.isLoading} | error: ${auth.errorMessage}',
                    //     style: const TextStyle(fontSize: 10.sp, color: Colors.black87),
                    //   ),
                    // ),
                    // const SizedBox(height: 8.h),

                    // Timer
                    Text(
                      auth.timerText,
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Message info
                    Text(
                      'Nous avons envoyé un code de vérification à votre numéro de téléphone.Veuillez consulter vos SMS.',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // Bouton Verifier
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
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
                          backgroundColor: Color(0xFF2E7D32),
                          disabledBackgroundColor:
                              Color(0xFF2E7D32).withOpacity(0.5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                          elevation: 0,
                        ),
                        child: auth.isLoading
                            ? SizedBox(
                                width: 22.w, height: 22.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                'Verifier',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Lien Se connecter
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, '/connexion'),
                        child: RichText(
                          text: TextSpan(
                            text: "j'ai deja un compte? ",
                            style: TextStyle(
                              color: Color(0xFF6B7280), fontSize: 14.sp),
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
                      SizedBox(height: 12.h),
                      Center(
                        child: GestureDetector(
                          onTap: () => auth.resendOtp(),
                          child: Text(
                            'Renvoyer le code',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
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
      width: 64.w,
      height: 64.h,
      child: TextField(
        controller: _controller,
        focusNode: _focus,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A2E),
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide:
                BorderSide(color: Color(0xFF2E7D32), width: 1.5.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide:
                BorderSide(color: Color(0xFF2E7D32), width: 2.5.r),
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
