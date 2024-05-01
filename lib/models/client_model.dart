import 'package:project_evydhence/models/vehicle_model.dart';

class ClientModel {
  int indexClient;
  int idClient;
  String cpfCnpj;
  String rg;
  String nomeRazao;
  String telefone;
  String email;
  String confirmarEmail;
  DateTime dataNascFund;
  List<VehicleModel> listaVeiculos;

  ClientModel({
    required this.indexClient,
    required this.idClient,
    required this.cpfCnpj,
    required this.rg,
    required this.nomeRazao,
    required this.telefone,
    required this.email,
    required this.confirmarEmail,
    required this.dataNascFund,
    required this.listaVeiculos,
  });

  void addVeiculo(VehicleModel veiculo) {
    listaVeiculos.add(veiculo);
  }

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
      indexClient: json['indexClient'],
      idClient: json['idClient'],
      cpfCnpj: json['cpfCnpj'],
      rg: json['rg'],
      nomeRazao: json['nomeRazao'],
      telefone: json['telefone'],
      email: json['email'],
      confirmarEmail: json['confirmarEmail'],
      dataNascFund: json['dataNascFund'],
      listaVeiculos: json['listaVeiculos']);
}
