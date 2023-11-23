class Medicamentos_database {
  String dosis_frecuencia;
  String nombre_comercial;
  String presentacion;
  var rela_paciente;
  var rela_medicamento;
  var id_medicamento;

  Medicamentos_database(
      {this.dosis_frecuencia,
      this.rela_paciente,
      this.rela_medicamento,
      this.id_medicamento,
      this.nombre_comercial,
      this.presentacion});

  factory Medicamentos_database.fromJson(Map<String, dynamic> json) {
    return Medicamentos_database(
        id_medicamento: json['id_medicamento'],
        dosis_frecuencia: json['dosis_frecuencia'],
        rela_paciente: json['rela_paciente'],
        rela_medicamento: json['rela_medicamento'],
        nombre_comercial: json['nombre_comercial'],
        presentacion: json['presentacion']);
  }
}
