class RecordatoriosModel {
  String descripcion;
  String fecha_limite;
  var id_recordatorio;
  var id_paciente;
  var estado_recordatorio;

  RecordatoriosModel({
    this.descripcion,
    this.fecha_limite,
    this.id_recordatorio,
    this.id_paciente,
    this.estado_recordatorio,
  });

  factory RecordatoriosModel.fromJson(Map<String, dynamic> json) {
    return RecordatoriosModel(
      id_recordatorio: json['id'],
      descripcion: json['descripcion'],
      fecha_limite: json['fecha_limite'],
      id_paciente: json['rela_paciente'],
      estado_recordatorio: json['rela_estado_recordatorio'],
    );
  }
}
