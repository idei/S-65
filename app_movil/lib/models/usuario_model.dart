class UsuarioModel {
  String tokenId;
  String emailUser;

  UsuarioModel({
    this.tokenId,
    this.emailUser,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      emailUser: json['email'].toString(),
      tokenId: json['tokenId'].toString(),
    );
  }
}
