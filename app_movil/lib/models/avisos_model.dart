class AvisosModel {
  String descripcion;
  String fecha_limite;
  String url_imagen;
  var estado_leido;
  var id_aviso;
  var id_paciente;
  var rela_creador;
  var rela_medico;

  AvisosModel(
      {this.descripcion,
      this.fecha_limite,
      this.id_aviso,
      this.estado_leido,
      this.id_paciente,
      this.url_imagen,
      this.rela_creador,
      this.rela_medico});

  factory AvisosModel.fromJson(Map<String, dynamic> json) {
    return AvisosModel(
      id_aviso: json['id'],
      descripcion: json['descripcion'],
      fecha_limite: json['fecha_limite'],
      id_paciente: json['rela_paciente'],
      estado_leido: json['estado_leido'],
      url_imagen: json['url_imagen'],
      rela_creador: json['rela_creador'],
      rela_medico: json['rela_medico'],
    );
  }
}
