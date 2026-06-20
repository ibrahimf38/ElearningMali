import 'package:flutter/material.dart';
import '../models/abonnement_model.dart';
import '../services/paiement_service.dart';

enum PaiementStatus { idle, loading, success, error }

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
  PaiementResult? lastResult;

  void selectionnerMethode(MethodePaiement methode) {
    methodeSelectionnee = methode;
    notifyListeners();
  }

  void setNumero(String value) {
    numeroTelephone = value;
    errorMessage = null;
    notifyListeners();
  }

  bool get numeroValide =>
      RegExp(r'^[0-9]{8}$').hasMatch(numeroTelephone);

  /// Lance le paiement pour le forfait donné.
  Future<bool> confirmerPaiement(ForfaitModel forfait) async {
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

    status = PaiementStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.payer(
        methode: methodeSelectionnee!,
        numeroTelephone: numeroTelephone,
        forfait: forfait,
      );
      lastResult = result;
      status = result.success ? PaiementStatus.success : PaiementStatus.error;
      if (!result.success) {
        errorMessage = result.message.isNotEmpty
            ? result.message
            : 'Le paiement a échoué';
      }
      notifyListeners();
      return result.success;
    } catch (e) {
      status = PaiementStatus.error;
      errorMessage = 'Erreur lors du paiement. Veuillez réessayer.';
      notifyListeners();
      return false;
    }
  }

  /// Réinitialise le flux pour un nouveau paiement.
  void reset() {
    methodeSelectionnee = null;
    numeroTelephone = '';
    status = PaiementStatus.idle;
    errorMessage = null;
    lastResult = null;
    notifyListeners();
  }
}