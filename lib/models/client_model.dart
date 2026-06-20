/// Représente `Utilisateur` + `Client` du diagramme de classe.
/// Le `mot_de_passe` et `code_otp` ne sont jamais stockés côté client
/// après authentification — uniquement utilisés lors des requêtes.
class ClientModel {
  final int id;
  final String telephone;
  final String nomComplet;
  final DateTime? dateInscription;
  final DateTime? dateDerniereConnexion;
  final bool estActif;

  const ClientModel({
    required this.id,
    required this.telephone,
    required this.nomComplet,
    this.dateInscription,
    this.dateDerniereConnexion,
    this.estActif = true,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int,
      telephone: json['telephone'] as String,
      nomComplet: json['nom_complet'] as String? ?? '',
      dateInscription: json['date_inscription'] != null
          ? DateTime.tryParse(json['date_inscription'] as String)
          : null,
      dateDerniereConnexion: json['date_derniere_connexion'] != null
          ? DateTime.tryParse(json['date_derniere_connexion'] as String)
          : null,
      estActif: json['est_actif'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'telephone': telephone,
        'nom_complet': nomComplet,
        'date_inscription': dateInscription?.toIso8601String(),
        'date_derniere_connexion': dateDerniereConnexion?.toIso8601String(),
        'est_actif': estActif,
      };
}