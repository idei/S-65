class MedicamentoModel {
  String dosis_frecuencia;
  String nombre_comercial;
  String presentacion;
  var rela_paciente;
  var rela_medicamento;
  var id_medicamento;

  MedicamentoModel(
      {this.dosis_frecuencia,
      this.rela_paciente,
      this.rela_medicamento,
      this.id_medicamento,
      this.nombre_comercial,
      this.presentacion});

  factory MedicamentoModel.fromJson(Map<String, dynamic> json) {
    return MedicamentoModel(
        id_medicamento: json['id_medicamento'],
        dosis_frecuencia: json['dosis_frecuencia'],
        rela_paciente: json['rela_paciente'],
        rela_medicamento: json['rela_medicamento'],
        nombre_comercial: json['nombre_comercial'],
        presentacion: json['presentacion']);
  }
}