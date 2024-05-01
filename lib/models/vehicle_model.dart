class VehicleModel {
  int idVeiculo;
  String placa;
  String marca;
  String modelo;
  String tipoVeiculo;
  String anoFabricacao;
  String anoModelo;

  VehicleModel({
    required this.idVeiculo,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.tipoVeiculo,
    required this.anoFabricacao,
    required this.anoModelo,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
      idVeiculo: json['idVeiculo'],
      placa: json['placa'],
      marca: json['marca'],
      modelo: json['modelo'],
      tipoVeiculo: json['tipoVeiculo'],
      anoFabricacao: json['anoFabricacao'],
      anoModelo: json['anoModelo']);
}