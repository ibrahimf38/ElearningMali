import 'dart:async';
import 'package:flutter/material.dart';
import '../models/abonnement_model.dart';
import '../services/paiement_service.dart';

enum PaiementStatus {
  idle,
  initiating,   // appel POST en cours
  awaitingUser, // en attente que l'utilisateur confirme (WebView Orange / USSD Moov)
  polling,      // vérification du statut en cours
  success,
  error,
}

class AbonnementProvider extends ChangeNotifier {
  final PaiementService _service;

  AbonnementProvider({PaiementService? service})
      : _service = service ?? PaiementService();

  // ── Historique ────────────────────────────────────────────
  List<AbonnementModel> historique = [];
  bool isLoadingHistorique = false;

  Future<void> chargerHistorique() async {
    isLoadingHistorique = true;
    notifyListeners();
    try {
      historique = await _service.getHistorique();
    } catch (_) {
      historique = [];
    } finally {
      isLoadingHistorique = false;
      notifyListeners();
    }
  }

  // ── Flux paiement ─────────────────────────────────────────
  MethodePaiement? methodeSelectionnee;
  String numeroTelephone = '';
  PaiementStatus status = PaiementStatus.idle;
  String? errorMessage;

  PaiementInitiationResult? initiation;
  AbonnementModel? abonnementConfirme;

  Timer? _pollingTimer;
  static const _pollingInterval = Duration(seconds: 3);
  static const _pollingTimeout = Duration(minutes: 5);

  void selectionnerMethode(MethodePaiement methode) {
    methodeSelectionnee = methode;
    notifyListeners();
  }

  void setNumero(String value) {
    numeroTelephone = value;
    errorMessage = null;
    notifyListeners();
  }

  bool get numeroValide => RegExp(r'^[0-9]{8}$').hasMatch(numeroTelephone);

  /// Étape 1 : initie le paiement.
  /// - Orange Money : retourne true, `initiation.paymentUrl` doit être
  ///   ouvert dans une WebView par l'écran appelant.
  /// - Moov Money : démarre directement le polling de statut.
  Future<bool> initierPaiement() async {
    if (methodeSelectionnee == null) {
      errorMessage = 'Veuillez choisir un mode de paiement';
      notifyListeners();
      return false;
    }
    if (!numeroValide) {
      errorMessage = 'Numéro invalide (8 chiffres requis)';
      notifyListeners();
      return false;
    }

    status = PaiementStatus.initiating;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.initierPaiement(
        methode: methodeSelectionnee!,
        numeroTelephone: numeroTelephone,
      );
      initiation = result;

      if (methodeSelectionnee == MethodePaiement.orangeMoney) {
        // L'écran appelant doit maintenant ouvrir result.paymentUrl
        // dans une WebView, puis appeler demarrerPolling() une fois
        // que la WebView signale une redirection de retour.
        status = PaiementStatus.awaitingUser;
      } else {
        // Moov Money : pas de WebView, on attend la confirmation USSD.
        status = PaiementStatus.awaitingUser;
        demarrerPolling();
      }
      notifyListeners();
      return true;
    } catch (e) {
      status = PaiementStatus.error;
      errorMessage = 'Erreur lors de l\'initiation du paiement. Réessayez.';
      notifyListeners();
      return false;
    }
  }

  /// Étape 2 : démarre le polling de statut (appelé après la WebView
  /// Orange Money, ou automatiquement pour Moov Money).
  void demarrerPolling() {
    if (initiation == null) return;
    final idTransaction = initiation!.idTransaction;
    final deadline = DateTime.now().add(_pollingTimeout);

    status = PaiementStatus.polling;
    notifyListeners();

    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (timer) async {
      if (DateTime.now().isAfter(deadline)) {
        timer.cancel();
        status = PaiementStatus.error;
        errorMessage = 'Délai dépassé. Vérifiez votre abonnement plus tard.';
        notifyListeners();
        return;
      }

      try {
        final result = await _service.verifierStatut(idTransaction);
        if (result.estConfirme) {
          timer.cancel();
          abonnementConfirme = result.abonnement;
          status = PaiementStatus.success;
          notifyListeners();
        } else if (result.aEchoue) {
          timer.cancel();
          status = PaiementStatus.error;
          errorMessage = 'Le paiement a échoué ou a été annulé.';
          notifyListeners();
        }
        // Sinon 'En attente' -> on continue le polling silencieusement
      } catch (_) {
        // Erreur réseau ponctuelle -> on continue d'essayer
      }
    });
  }

  /// Arrête le polling manuellement (ex: l'utilisateur quitte l'écran).
  void arreterPolling() {
    _pollingTimer?.cancel();
  }

  /// Réinitialise le flux pour un nouveau paiement.
  void reset() {
    _pollingTimer?.cancel();
    methodeSelectionnee = null;
    numeroTelephone = '';
    status = PaiementStatus.idle;
    errorMessage = null;
    initiation = null;
    abonnementConfirme = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}