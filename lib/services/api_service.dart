import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_evydhence/api_constants.dart';
import 'package:project_evydhence/models/client_model.dart';
import 'package:project_evydhence/models/schedule_model.dart';
import 'package:project_evydhence/models/vehicle_model.dart';

class ApiService {
  Future<List<ClientModel>?> getClients() async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getClientsEndpoint);
    var response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      return userModelFromJson(
          response.body); // Retornar o modelo se a resposta for OK
    } else {
      return []; // Retornar uma lista vazia se o status da resposta não for OK
    }
  }

  Future<ClientModel?> getClient(String cpfCnpj) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/persons/$cpfCnpj/');
    var response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      return ClientModel.fromJson(jsonDecode(response.body));
    } else {
      return null; // Retornar uma lista vazia se o status da resposta não for OK
    }
  }

  Future<bool> postClient(
      String nomeRazao,
      String cpfCnpj,
      String rg,
      String dataNascFund,
      String email,
      String confirmarEmail,
      String telefone) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.postClientEndpoint);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nomeRazao': nomeRazao,
        'cpfCnpj': cpfCnpj,
        'rg': rg,
        'dataNascFund': dataNascFund,
        'email': email,
        'confirmarEmail': confirmarEmail,
        'telefone': telefone
      }),
    );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  Future<bool> putClient(
      int idClient,
      String nomeRazao,
      String cpfCnpj,
      String rg,
      String dataNascFund,
      String email,
      String confirmarEmail,
      String telefone) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/persons/$idClient/update/');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'nomeRazao': nomeRazao,
        'cpfCnpj': cpfCnpj,
        'rg': rg,
        'dataNascFund': dataNascFund,
        'email': email,
        'confirmarEmail': confirmarEmail,
        'telefone': telefone
      }),
    );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  Future<bool> deleteClient(int idClient) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/persons/$idClient/delete/');
    var response = await http.delete(url);
    if (response.statusCode == HttpStatus.ok) {
      return true; // Retornar o true se o cliente foi deletado
    } else {
      return false; // Retorna false se não foi excluido
    }
  }

  Future<List<VehicleModel>?> getVehicles() async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getVehiclesEndpoint);
    var response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      return vehicleModelFromJson(
          response.body); // Retornar o modelo se a resposta for OK
    } else {
      return []; // Retornar uma lista vazia se o status da resposta não for OK
    }
  }

  Future<List<VehicleModel>?> getVehiclesByClient(int idCliente) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/vehicles/$idCliente/');
    var response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      return vehicleModelFromJson(
          response.body); // Retornar o modelo se a resposta for OK
    } else {
      return []; // Retornar uma lista vazia se o status da resposta não for OK
    }
  }

  Future<bool> postVehicle(
      int idCliente,
      String placa,
      String marca,
      String modelo,
      String tipoVeiculo,
      String anoFabricacao,
      String anoModelo) async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.postVehicleEndpoint);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idCliente': idCliente,
        'placa': placa,
        'marca': marca,
        'modelo': modelo,
        'tipoVeiculo': tipoVeiculo,
        'anoFabricacao': anoFabricacao,
        'anoModelo': anoModelo
      }),
    );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  Future<bool> putVehicle(
      int idVeiculo,
      int idCliente,
      String placa,
      String marca,
      String modelo,
      String tipoVeiculo,
      String anoFabricacao,
      String anoModelo) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/vehicles/$idVeiculo/update/');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idCliente': idCliente,
        'placa': placa,
        'marca': marca,
        'modelo': modelo,
        'tipoVeiculo': tipoVeiculo,
        'anoFabricacao': anoFabricacao,
        'anoModelo': anoModelo
      }),
    );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  Future<bool> deleteVehicle(int idVeiculo) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/vehicles/$idVeiculo/delete/');
    var response = await http.delete(url);
    if (response.statusCode == HttpStatus.ok) {
      return true; // Retornar o true se o veiculo foi deletado
    } else {
      return false; // Retorna false se não foi excluido
    }
  }

  Future<List<ScheduleModel>?> getSchedules() async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getSchedulesEndpoint);
    var response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      return scheduleModelFromJson(
          response.body); // Retornar o modelo se a resposta for OK
    } else {
      return []; // Retornar uma lista vazia se o status da resposta não for OK
    }
  }

  Future<List<ScheduleModel>?> getSchedulesByVehicle(int idVeiculo) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/schedules/$idVeiculo/');
    var response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      return scheduleModelFromJson(
          response.body); // Retornar o modelo se a resposta for OK
    } else {
      return []; // Retornar uma lista vazia se o status da resposta não for OK
    }
  }

  Future<bool> postSchedule(
      int idVeiculo,
      String dtaAgendamento,
      String horaAgendamento,
      String localAgendamento,
      String observacao) async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.postSchedulesEndpoint);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idVeiculo': idVeiculo,
        'dtaAgendamento': dtaAgendamento,
        'horaAgendamento': horaAgendamento,
        'localAgendamento': localAgendamento,
        'observacao': observacao
      }),
    );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  Future<bool> putSchedule(
      int idSchedule,
      int idVeiculo,
      String dtaAgendamento,
      String horaAgendamento,
      String localAgendamento,
      String observacao) async {
    var url =
        Uri.parse('${ApiConstants.baseUrl}/schedules/$idSchedule/update/');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'idVeiculo': idVeiculo,
        'dtaAgendamento': dtaAgendamento,
        'horaAgendamento': horaAgendamento,
        'localAgendamento': localAgendamento,
        'observacao': observacao,
      }),
    );
    if (response.statusCode == HttpStatus.ok) {
      return true;
    }
    return false;
  }

  Future<bool> deleteSchedule(int idSchedule) async {
    var url =
        Uri.parse('${ApiConstants.baseUrl}/schedules/$idSchedule/delete/');
    var response = await http.delete(url);
    if (response.statusCode == HttpStatus.ok) {
      return true; // Retornar o true se o veiculo foi deletado
    } else {
      return false; // Retorna false se não foi excluido
    }
  }
}
