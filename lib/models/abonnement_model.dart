/// Représente `Abonnement` du diagramme de classe.
class AbonnementModel {
  final int id;
  final int idClient;
  final String idTransaction;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String statut; // 'Actif' | 'Expire'
  final int montant;

  const AbonnementModel({
    required this.id,
    required this.idClient,
    required this.idTransaction,
    required this.dateDebut,
    required this.dateFin,
    required this.statut,
    required this.montant,
  });

  factory AbonnementModel.fromJson(Map<String, dynamic> json) {
    return AbonnementModel(
      id: json['id'] as int,
      idClient: json['id_client'] as int,
      idTransaction: json['id_transaction'] as String,
      dateDebut: DateTime.parse(json['date_debut'] as String),
      dateFin: DateTime.parse(json['date_fin'] as String),
      statut: json['statut'] as String,
      montant: json['montant'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_client': idClient,
        'id_transaction': idTransaction,
        'date_debut': dateDebut.toIso8601String(),
        'date_fin': dateFin.toIso8601String(),
        'statut': statut,
        'montant': montant,
      };

  bool get estActif => statut == 'Actif' && dateFin.isAfter(DateTime.now());
}

/// Moyens de paiement disponibles (OrangeMoney / MoovMoney).
enum MethodePaiement { orangeMoney, moovMoney }

extension MethodePaiementX on MethodePaiement {
  String get label {
    switch (this) {
      case MethodePaiement.orangeMoney:
        return 'Orange Money Mali';
      case MethodePaiement.moovMoney:
        return 'Moov Money';
    }
  }

  /// Endpoint correspondant (voir ApiConfig)
  String get champNumero {
    switch (this) {
      case MethodePaiement.orangeMoney:
        return 'numero_orange';
      case MethodePaiement.moovMoney:
        return 'numero_moov';
    }
  }
}

/// Représente un forfait d'abonnement proposé (donnée d'affichage,
/// le backend utilise un montant fixe ABONNEMENT_MONTANT/DUREE_JOURS).
class ForfaitModel {
  final String typeForfait;
  final int montant;
  final String description;
  final int dureeJours;

  const ForfaitModel({
    required this.typeForfait,
    required this.montant,
    required this.description,
    required this.dureeJours,
  });
}

/// Forfait actuellement proposé sur la page Abonnement.
const ForfaitModel kForfaitDecouverte = ForfaitModel(
  typeForfait: 'Découverte',
  montant: 1000,
  description: 'Abonnez-vous et accédez à toutes nos ressources pendant 1 mois !',
  dureeJours: 30,
);

/// Résultat de l'INITIATION d'un paiement (juste après l'appel
/// POST /paiements/orange-money ou /paiements/moov-money).
///
/// Le paiement n'est pas encore confirmé à ce stade :
/// - Orange Money : `paymentUrl` doit être ouvert dans une WebView
/// - Moov Money    : le client doit confirmer via notification USSD
class PaiementInitiationResult {
  final String idTransaction;
  final String message;
  final String? paymentUrl;  // Orange Money uniquement
  final String? referenceId; // Moov Money uniquement

  const PaiementInitiationResult({
    required this.idTransaction,
    required this.message,
    this.paymentUrl,
    this.referenceId,
  });

  factory PaiementInitiationResult.fromJson(Map<String, dynamic> json) {
    return PaiementInitiationResult(
      idTransaction: json['id_transaction'] as String,
      message: json['message'] as String? ?? '',
      paymentUrl: json['payment_url'] as String?,
      referenceId: json['reference_id'] as String?,
    );
  }
}

/// Résultat du POLLING de statut (GET /paiements/:id/statut).
class PaiementStatutResult {
  final String statut; // 'En attente' | 'Succes' | 'Echec'
  final AbonnementModel? abonnement;

  const PaiementStatutResult({
    required this.statut,
    this.abonnement,
  });

  bool get estConfirme => statut == 'Succes';
  bool get aEchoue => statut == 'Echec';
  bool get estEnAttente => statut == 'En attente';

  factory PaiementStatutResult.fromJson(Map<String, dynamic> json) {
    return PaiementStatutResult(
      statut: json['statut'] as String,
      abonnement: json['abonnement'] != null
          ? AbonnementModel.fromJson(json['abonnement'] as Map<String, dynamic>)
          : null,
    );
  }
}