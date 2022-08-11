class ScreeningModel {
  var tipo_screening;
  var id_resultado_screening;
  var id_paciente;
  var result_screening;
  String nombre;
  String codigo;
  String fecha;

  ScreeningModel(
      {this.tipo_screening,
      this.id_resultado_screening,
      this.id_paciente,
      this.result_screening,
      this.nombre,
      this.codigo,
      this.fecha});

  factory ScreeningModel.fromJson(Map<String, dynamic> json) {
    return ScreeningModel(
      id_resultado_screening: json['id'],
      tipo_screening: json['rela_screening'],
      id_paciente: json['rela_paciente'],
      result_screening: json['result_screening'],
      nombre: json['nombre'],
      codigo: json['codigo'],
      fecha: json['fecha_alta'],
    );
  }
}
