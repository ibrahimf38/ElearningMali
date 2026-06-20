/// ─────────────────────────────────────────────────────────────
/// Système de filtrage : Domaine -> Niveau -> Matiere
/// (Bloc 3 du diagramme de classe)
/// ─────────────────────────────────────────────────────────────

class DomaineModel {
  final int id;
  final String nomDomaine;

  const DomaineModel({
    required this.id,
    required this.nomDomaine,
  });

  factory DomaineModel.fromJson(Map<String, dynamic> json) {
    return DomaineModel(
      id: json['id'] as int,
      nomDomaine: json['nom_domaine'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom_domaine': nomDomaine,
      };

  @override
  bool operator ==(Object other) =>
      other is DomaineModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class NiveauModel {
  final int id;
  final int idDomaine;
  final String nomNiveau;

  const NiveauModel({
    required this.id,
    required this.idDomaine,
    required this.nomNiveau,
  });

  factory NiveauModel.fromJson(Map<String, dynamic> json) {
    return NiveauModel(
      id: json['id'] as int,
      idDomaine: json['id_domaine'] as int,
      nomNiveau: json['nom_niveau'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_domaine': idDomaine,
        'nom_niveau': nomNiveau,
      };

  @override
  bool operator ==(Object other) => other is NiveauModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class MatiereModel {
  final int id;
  final int idNiveau;
  final String nomMatiere;

  const MatiereModel({
    required this.id,
    required this.idNiveau,
    required this.nomMatiere,
  });

  factory MatiereModel.fromJson(Map<String, dynamic> json) {
    return MatiereModel(
      id: json['id'] as int,
      idNiveau: json['id_niveau'] as int,
      nomMatiere: json['nom_matiere'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_niveau': idNiveau,
        'nom_matiere': nomMatiere,
      };

  @override
  bool operator ==(Object other) => other is MatiereModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}