import 'dart:convert';

List<ClientModel> userModelFromJson(String str) => List<ClientModel>.from(
    json.decode(str).map((x) => ClientModel.fromJson(x)));

String userModelToJson(List<ClientModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClientModel {
  ClientModel({
    required this.idClient,
    required this.nomeRazao,
    required this.cpfCnpj,
    required this.rg,
    required this.dataNascFund,
    required this.email,
    required this.confirmarEmail,
    required this.telefone,
  });

  int idClient;
  String nomeRazao;
  String cpfCnpj;
  String rg;
  String dataNascFund;
  String email;
  String confirmarEmail;
  String telefone;

  // void addVeiculo(VehicleModel veiculo) {
  //   listaVeiculos.add(veiculo);
  // }

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
      idClient: json["idClient"],
      nomeRazao: json["nomeRazao"],
      cpfCnpj: json["cpfCnpj"],
      rg: json["rg"],
      dataNascFund: json["dataNascFund"],
      email: json["email"],
      confirmarEmail: json["confirmarEmail"],
      telefone: json["telefone"]
      //listaVeiculos: json['listaVeiculos']
      );

  Map<String, dynamic> toJson() => {
        "idClient": idClient,
        "nomeRazao": nomeRazao,
        "cpfCnpj": cpfCnpj,
        "rg": rg,
        "dataNascFund": dataNascFund,
        "email": email,
        "confirmarEmail": confirmarEmail,
        "telefone": telefone,
      };
}
