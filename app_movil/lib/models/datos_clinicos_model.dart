class DatosClinicos {
  String id;
  String rela_paciente;
  String presion_alta;
  String presion_baja;
  String pulso;
  String peso;
  String circunferencia_cintura;
  String talla;
  String consume_alcohol;
  String consume_marihuana;
  String otras_drogas;
  String fuma_tabaco;
  String estado_clinico;
  String fecha_alta;

  DatosClinicos({
    this.id,
    this.rela_paciente,
    this.presion_alta,
    this.presion_baja,
    this.pulso,
    this.peso,
    this.circunferencia_cintura,
    this.talla,
    this.consume_alcohol,
    this.consume_marihuana,
    this.otras_drogas,
    this.fuma_tabaco,
    this.estado_clinico,
    this.fecha_alta,
  });

  factory DatosClinicos.fromJson(Map<String, dynamic> json) {
    return DatosClinicos(
      id: json['id'],
      rela_paciente: json['rela_paciente'],
      presion_alta: json['presion_alta'],
      presion_baja: json['presion_baja'],
      pulso: json['pulso'],
      peso: json['peso'],
      circunferencia_cintura: json['circunferencia_cintura'],
      talla: json['talla'],
      consume_alcohol: json['consume_alcohol'],
      consume_marihuana: json['consume_marihuana'],
      otras_drogas: json['otras_drogas'],
      fuma_tabaco: json['fuma_tabaco'],
      estado_clinico: json['estado_clinico'],
      fecha_alta: json['fecha_alta'],
    );
  }
}
