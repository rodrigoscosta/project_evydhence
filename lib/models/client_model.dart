class ClientModel {
  int idClient;
  String cpfCnpj;
  String rg;
  String nomeRazao;
  String telefone;
  String email;
  String confirmarEmail;
  DateTime dataNascFund;

  ClientModel({
    required this.idClient,
    required this.cpfCnpj,
    required this.rg,
    required this.nomeRazao,
    required this.telefone,
    required this.email,
    required this.confirmarEmail,
    required this.dataNascFund,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
    idClient: json['idClient'],
    cpfCnpj: json['cpfCnpj'],
    rg: json['rg'],
    nomeRazao: json['nomeRazao'],
    telefone: json['telefone'],
    email: json['email'],
    confirmarEmail: json['confirmarEmail'],
    dataNascFund: json['dataNascFund']);
}
