class PacienteModel {
  var rela_users;
  var rela_genero;
  var rela_nivel_instruccion;
  var rela_departamento;
  var rela_grupo_conviviente;
  String nombre;
  String apellido;
  String fecha_nacimiento;
  var dni;
  String celular;
  String contacto;
  var estado_users;
  String email;

  PacienteModel({
    this.rela_users = "",
    this.rela_genero = "",
    this.rela_nivel_instruccion = "",
    this.rela_departamento = "",
    this.rela_grupo_conviviente = "",
    this.nombre,
    this.apellido,
    this.fecha_nacimiento = "",
    this.dni,
    this.celular = "",
    this.contacto = "",
    this.estado_users,
    this.email,
  });

  factory PacienteModel.fromJson(Map<String, dynamic> json) {
    return PacienteModel(
      rela_users: json['rela_users'].toString(),
      rela_genero: json['rela_genero'].toString(),
      rela_departamento: json['rela_departamento'].toString(),
      rela_nivel_instruccion: json['rela_nivel_instruccion'].toString(),
      rela_grupo_conviviente: json['rela_grupo_conviviente'].toString(),
      nombre: json['nombre'],
      apellido: json['apellido'],
      fecha_nacimiento: json['fecha_nacimiento'],
      dni: json['dni'],
      celular: json['celular'],
      contacto: json['contacto'],
      estado_users: json['estado_users'],
      email: json['estado_users'],
    );
  }
}