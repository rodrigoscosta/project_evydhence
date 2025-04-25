import 'dart:convert';

List<ClientModel> userModelFromJson(String str) => List<ClientModel>.from(
    json.decode(str).map((x) => ClientModel.fromJson(x)));

String userModelToJson(List<ClientModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

ClientModel clientModelFromJson(String str) =>
    ClientModel.fromJson(json.decode(str).map((x) => ClientModel.fromJson(x)));

class ClientModel {
  ClientModel({
    required this.idClient,
    required this.nomeRazao,
    required this.cpfCnpj,
    required this.rg,
    required this.dataNascFund,
    required this.sexo,
    required this.email,
    required this.confirmarEmail,
    required this.telefone,
    required this.cep,
    required this.logradouro,
    required this.numeroResidencia,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.uf,
  });

  int idClient;
  String nomeRazao;
  String cpfCnpj;
  String rg;
  String dataNascFund;
  String sexo;
  String email;
  String confirmarEmail;
  String telefone;
  String cep;
  String logradouro;
  String numeroResidencia;
  String complemento;
  String bairro;
  String cidade;
  String estado;
  String uf;

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
      idClient: json["idClient"],
      nomeRazao: json["nomeRazao"],
      cpfCnpj: json["cpfCnpj"],
      rg: json["rg"],
      dataNascFund: json["dataNascFund"],
      sexo: json["sexo"],
      email: json["email"],
      confirmarEmail: json["confirmarEmail"],
      telefone: json["telefone"],
      cep: json["cep"],
      logradouro: json["logradouro"],
      numeroResidencia: json["numeroResidencia"],
      complemento: json["complemento"],
      bairro: json["bairro"],
      cidade: json["cidade"],
      estado: json["estado"],
      uf: json["uf"]);

  Map<String, dynamic> toJson() => {
        "idClient": idClient,
        "nomeRazao": nomeRazao,
        "cpfCnpj": cpfCnpj,
        "rg": rg,
        "dataNascFund": dataNascFund,
        "sexo": sexo,
        "email": email,
        "confirmarEmail": confirmarEmail,
        "telefone": telefone,
        "cep": cep,
        "logradouro": logradouro,
        "numeroResidencia": numeroResidencia,
        "complemento": complemento,
        "bairro": bairro,
        "cidade": cidade,
        "estado": estado,
        "uf": uf
      };
}
