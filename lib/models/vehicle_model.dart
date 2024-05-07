import 'dart:convert';

List<VehicleModel> vehicleModelFromJson(String str) => List<VehicleModel>.from(
    json.decode(str).map((x) => VehicleModel.fromJson(x)));

String vehicleModelToJson(List<VehicleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
  
  Map<String, dynamic> toJson() => {
        "idVeiculo": idVeiculo,
        "placa": placa,
        "marca": marca,
        "modelo": modelo,
        "tipoVeiculo": tipoVeiculo,
        "anoFabricacao": anoFabricacao,
        "anoModelo": anoModelo
      };
}