class AntecedenteFamiliaresModel {
  String antecedenteDescripcion;

  AntecedenteFamiliaresModel({this.antecedenteDescripcion});

  factory AntecedenteFamiliaresModel.fromJson(Map<String, dynamic> json) {
    return AntecedenteFamiliaresModel(
        antecedenteDescripcion: json['nombre_evento']);
  }
}
