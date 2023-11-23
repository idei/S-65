class AntecedentesPersonalesModel {
  String antecedenteDescripcion;

  AntecedentesPersonalesModel({this.antecedenteDescripcion});

  factory AntecedentesPersonalesModel.fromJson(Map<String, dynamic> json) {
    return AntecedentesPersonalesModel(
        antecedenteDescripcion: json['nombre_evento']);
  }
}
