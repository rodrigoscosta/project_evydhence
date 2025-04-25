import 'dart:convert';

List<VehicleModel> vehicleModelFromJson(String str) => List<VehicleModel>.from(
    json.decode(str).map((x) => VehicleModel.fromJson(x)));

String vehicleModelToJson(List<VehicleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleModel {
  int idCliente;
  int idVeiculo;
  String placa;
  String marca;
  String modelo;
  String tipoVeiculo;
  String anoFabricacao;
  String anoModelo;

  VehicleModel({
    required this.idCliente,
    required this.idVeiculo,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.tipoVeiculo,
    required this.anoFabricacao,
    required this.anoModelo,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
      idCliente: json['idCliente'],
      idVeiculo: json['idVeiculo'],
      placa: json['placa'],
      marca: json['marca'],
      modelo: json['modelo'],
      tipoVeiculo: json['tipoVeiculo'],
      anoFabricacao: json['anoFabricacao'],
      anoModelo: json['anoModelo']);
  
  Map<String, dynamic> toJson() => {
        "idCliente": idCliente,
        "idVeiculo": idVeiculo,
        "placa": placa,
        "marca": marca,
        "modelo": modelo,
        "tipoVeiculo": tipoVeiculo,
        "anoFabricacao": anoFabricacao,
        "anoModelo": anoModelo
      };
}

class TotalVehiclesModel {
  final int qtdVeiculos;

  TotalVehiclesModel({required this.qtdVeiculos});

  factory TotalVehiclesModel.fromJson(Map<String, dynamic> json) {
    return TotalVehiclesModel(
      qtdVeiculos: json['qtdVeiculos'] ?? 0,
    );
  }
}
