/// Représente `Abonnement` du diagramme de classe.
class AbonnementModel {
  final int id;
  final int idClient;
  final String idTransaction;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String statut; // 'actif' | 'expire' | 'en_attente'
  final int montant;
  final String typeForfait;

  const AbonnementModel({
    required this.id,
    required this.idClient,
    required this.idTransaction,
    required this.dateDebut,
    required this.dateFin,
    required this.statut,
    required this.montant,
    required this.typeForfait,
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
      typeForfait: json['type_forfait'] as String? ?? 'Découverte',
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
        'type_forfait': typeForfait,
      };

  bool get estActif => statut == 'actif' && dateFin.isAfter(DateTime.now());
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

/// Représente un forfait d'abonnement proposé.
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

/// Forfait actuellement proposé sur la page Abonnement (Image 1).
const ForfaitModel kForfaitDecouverte = ForfaitModel(
  typeForfait: 'Découverte',
  montant: 1000,
  description: 'Abonnez-vous et accédez à toutes nos ressources pendant 1 mois !',
  dureeJours: 30,
);

/// Résultat retourné après une tentative de paiement.
class PaiementResult {
  final bool success;
  final String idTransaction;
  final String message;
  final AbonnementModel? abonnement;

  const PaiementResult({
    required this.success,
    required this.idTransaction,
    required this.message,
    this.abonnement,
  });

  factory PaiementResult.fromJson(Map<String, dynamic> json) {
    return PaiementResult(
      success: json['success'] as bool? ?? false,
      idTransaction: json['id_transaction'] as String,
      message: json['message'] as String? ?? '',
      abonnement: json['abonnement'] != null
          ? AbonnementModel.fromJson(json['abonnement'] as Map<String, dynamic>)
          : null,
    );
  }
}