// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import '../services/api_client.dart';
// import '../services/session_manager.dart';
// import '../models/client_model.dart';

// class AuthProvider extends ChangeNotifier {
//   final AuthService _authService;

//   AuthProvider({AuthService? authService})
//       : _authService = authService ?? AuthService();

//   // ── Champs ─────────────────────────────────────────────────
//   String phoneNumber = '';
//   String fullName = '';
//   bool isLoading = false;
//   String? errorMessage;

//   // Stocké après verifyOtp réussi
//   String? token;
//   ClientModel? client;

//   // ── OTP ────────────────────────────────────────────────────
//   List<String> otpDigits = ['', '', '', ''];
//   int _secondsRemaining = 115; // 01:55
//   Timer? _timer;

//   String get timerText {
//     final m = _secondsRemaining ~/ 60;
//     final s = _secondsRemaining % 60;
//     return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
//   }

//   bool get timerExpired => _secondsRemaining == 0;
//   bool get otpComplete => otpDigits.every((d) => d.isNotEmpty);
//   String get otpCode => otpDigits.join();

//   void setPhone(String value) {
//     phoneNumber = value;
//     errorMessage = null;
//     notifyListeners();
//   }

//   void setFullName(String value) {
//     fullName = value;
//     notifyListeners();
//   }

//   // ── Connexion (téléphone seul → backend envoie OTP) ─────────
//   Future<bool> login() async {
//     if (phoneNumber.isEmpty) {
//       errorMessage = 'Veuillez entrer votre numéro de téléphone';
//       notifyListeners();
//       return false;
//     }
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     try {
//       await _authService.login(telephone: phoneNumber);
//       isLoading = false;
//       startTimer();
//       notifyListeners();
//       return true;
//     } on ApiException catch (e) {
//       errorMessage = e.message;
//       isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       errorMessage = 'Erreur de connexion. Vérifiez votre réseau.';
//       isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // ── Inscription (nom complet + téléphone) ───────────────────
//   Future<bool> register() async {
//     if (fullName.isEmpty || phoneNumber.isEmpty) {
//       errorMessage = 'Veuillez remplir tous les champs';
//       notifyListeners();
//       return false;
//     }
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     try {
//       await _authService.register(
//         nomComplet: fullName,
//         telephone: phoneNumber,
//       );
//       isLoading = false;
//       startTimer();
//       notifyListeners();
//       return true;
//     } on ApiException catch (e) {
//       errorMessage = e.message;
//       isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       errorMessage = 'Erreur de connexion. Vérifiez votre réseau.';
//       isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // ── OTP ────────────────────────────────────────────────────
//   void startTimer() {
//     _secondsRemaining = 115;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (_secondsRemaining > 0) {
//         _secondsRemaining--;
//         notifyListeners();
//       } else {
//         _timer?.cancel();
//         notifyListeners();
//       }
//     });
//   }

//   void setOtpDigit(int index, String value) {
//     if (index < 4) {
//       otpDigits[index] = value;
//       notifyListeners();
//     }
//   }

//   void resetOtp() {
//     otpDigits = ['', '', '', ''];
//     notifyListeners();
//   }

//   Future<void> resendOtp() async {
//     if (phoneNumber.isEmpty) return;
//     try {
//       await _authService.resendOtp(telephone: phoneNumber);
//       resetOtp();
//       startTimer();
//     } on ApiException catch (e) {
//       errorMessage = e.message;
//       notifyListeners();
//     } catch (_) {
//       errorMessage = 'Erreur lors du renvoi du code';
//       notifyListeners();
//     }
//   }

//   Future<bool> verifyOtp() async {
//     if (!otpComplete) {
//       errorMessage = 'Veuillez entrer le code complet';
//       notifyListeners();
//       return false;
//     }
//     isLoading = true;
//     errorMessage = null;
//     notifyListeners();

//     try {
//       final result = await _authService.verifyOtp(
//         telephone: phoneNumber,
//         codeOtp: otpCode,
//       );
//       token = result.token;
//       client = result.client;

//       // Sauvegarde la session (token + client) pour les futures requêtes
//       // authentifiées et pour rester connecté entre les sessions de l'app.
//       await SessionManager.instance.saveSession(result.token, result.client);

//       isLoading = false;
//       _timer?.cancel();
//       notifyListeners();
//       return true;
//     } on ApiException catch (e) {
//       errorMessage = e.message;
//       isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       errorMessage = 'Code invalide ou erreur réseau';
//       isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }



import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';
import '../services/session_manager.dart';
import '../models/client_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  // ── Champs ─────────────────────────────────────────────────
  String phoneNumber = '';
  String fullName = '';
  bool isLoading = false;
  String? errorMessage;

  // Stocké après verifyOtp réussi
  String? token;
  ClientModel? client;

  // ── OTP ────────────────────────────────────────────────────
  List<String> otpDigits = ['', '', '', ''];
  int _secondsRemaining = 115; // 01:55
  Timer? _timer;

  String get timerText {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get timerExpired => _secondsRemaining == 0;
  bool get otpComplete => otpDigits.every((d) => d.isNotEmpty);
  String get otpCode => otpDigits.join();

  /// Numéro au format international (E.164) attendu par le backend
  /// et par Twilio, ex: "+22376123456". L'utilisateur ne tape que les
  /// 8 chiffres locaux ; le préfixe +223 (Mali) est ajouté ici.
  String get phoneNumberE164 {
    final digits = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';
    if (phoneNumber.trim().startsWith('+')) return phoneNumber.trim();
    return '+223$digits';
  }

  void setPhone(String value) {
    phoneNumber = value;
    errorMessage = null;
    notifyListeners();
  }

  void setFullName(String value) {
    fullName = value;
    notifyListeners();
  }

  // ── Connexion (téléphone seul → backend envoie OTP) ─────────
  Future<bool> login() async {
    if (phoneNumber.isEmpty) {
      errorMessage = 'Veuillez entrer votre numéro de téléphone';
      notifyListeners();
      return false;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.login(telephone: phoneNumberE164);
      isLoading = false;
      startTimer();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Erreur de connexion. Vérifiez votre réseau.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Inscription (nom complet + téléphone) ───────────────────
  Future<bool> register() async {
    if (fullName.isEmpty || phoneNumber.isEmpty) {
      errorMessage = 'Veuillez remplir tous les champs';
      notifyListeners();
      return false;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(
        nomComplet: fullName,
        telephone: phoneNumberE164,
      );
      isLoading = false;
      startTimer();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Erreur de connexion. Vérifiez votre réseau.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── OTP ────────────────────────────────────────────────────
  void startTimer() {
    _secondsRemaining = 115;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  void setOtpDigit(int index, String value) {
    if (index < 4) {
      otpDigits[index] = value;
      notifyListeners();
    }
  }

  void resetOtp() {
    otpDigits = ['', '', '', ''];
    notifyListeners();
  }

  Future<void> resendOtp() async {
    if (phoneNumber.isEmpty) return;
    try {
      await _authService.resendOtp(telephone: phoneNumberE164);
      resetOtp();
      startTimer();
    } on ApiException catch (e) {
      errorMessage = e.message;
      notifyListeners();
    } catch (_) {
      errorMessage = 'Erreur lors du renvoi du code';
      notifyListeners();
    }
  }

  Future<bool> verifyOtp() async {
    if (!otpComplete) {
      errorMessage = 'Veuillez entrer le code complet';
      notifyListeners();
      return false;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.verifyOtp(
        telephone: phoneNumberE164,
        codeOtp: otpCode,
      );
      token = result.token;
      client = result.client;

      // Sauvegarde la session (token + client) pour les futures requêtes
      // authentifiées et pour rester connecté entre les sessions de l'app.
      await SessionManager.instance.saveSession(result.token, result.client);

      isLoading = false;
      _timer?.cancel();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Code invalide ou erreur réseau';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}