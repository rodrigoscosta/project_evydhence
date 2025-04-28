import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_evydhence/api_constants.dart';
import 'package:project_evydhence/models/client_model.dart';
import 'package:project_evydhence/models/schedule_model.dart';
import 'package:project_evydhence/models/total_clientes_model.dart';
import 'package:project_evydhence/models/total_clientes_por_genero_model.dart';
import 'package:project_evydhence/models/vehicle_model.dart';

class ApiService {
  Future<List<ClientModel>?> getClients() async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getClientsEndpoint);
    var response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData =
          utf8.decode(response.bodyBytes); // Corrige caracteres especiais
      return userModelFromJson(
          decodedData); // Decodifica a resposta corretamente
    } else {
      return []; // Retornar uma lista vazia se a resposta não for OK
    }
  }

  Future<ClientModel?> getClient(String cpfCnpj) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/persons/$cpfCnpj/');
    var response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      return ClientModel.fromJson(jsonDecode(decodedData));
    } else {
      return null; // Retornar uma lista vazia se o status da resposta não for OK
    }
  }

  Future<ClientModel?> getClientById(int clientId) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/persons/id/$clientId');
    var response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final decodedData = utf8.decode(response.bodyBytes);
      return ClientModel.fromJson(jsonDecode(decodedData));
    } else {
      return null;
    }
  }

  Future<bool> postClient(
      String nomeRazao,
      String cpfCnpj,
      String rg,
      String dataNascFund,
      String sexo,
      String email,
      String confirmarEmail,
      String telefone,
      String cep,
      String logradouro,
      String numeroResidencia,
      String complemento,
      String bairro,
      String cidade,
      String estado,
      String uf) async {
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
        'sexo': sexo,
        'email': email,
        'confirmarEmail': confirmarEmail,
        'telefone': telefone,
        'cep': cep,
        'logradouro': logradouro,
        'numeroResidencia': numeroResidencia,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'uf': uf
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
      String sexo,
      String email,
      String confirmarEmail,
      String telefone,
      String cep,
      String logradouro,
      String numeroResidencia,
      String complemento,
      String bairro,
      String cidade,
      String estado,
      String uf) async {
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
        'sexo': sexo,
        'email': email,
        'confirmarEmail': confirmarEmail,
        'telefone': telefone,
        'cep': cep,
        'logradouro': logradouro,
        'numeroResidencia': numeroResidencia,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'uf': uf
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

  Future<TotalClientesModel> totalClientes() async {
    TotalClientesModel totalClientesModel = TotalClientesModel(qtdClientes: 0);
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.getTotalClientsEndpoint);
      var response = await http.get(url);

      if (response.statusCode == HttpStatus.ok) {
        final decodedData = jsonDecode(response.body);
        totalClientesModel =
            TotalClientesModel(qtdClientes: decodedData['qtdClientes'] ?? 0);
        0;
      }
    } catch (_) {
      totalClientesModel = TotalClientesModel(qtdClientes: 0);
    }

    return totalClientesModel;
  }

  Future<List<TotalClientesPorGeneroModel>> totalClientesPorGenero() async {
    List<TotalClientesPorGeneroModel> totalClientesList = [];

    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.getTotalClientsByGenderEndpoint);
      var response = await http.get(url);

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> decodedData = jsonDecode(response.body);

        totalClientesList = decodedData.map((item) {
          return TotalClientesPorGeneroModel(
            qtdClientes: item['qtdClientes'] ?? 0,
            sexo: item['sexo'] ?? '',
          );
        }).toList();
      }
    } catch (_) {
      totalClientesList = [];
    }

    return totalClientesList;
  }

  Future<List<TotalVistoriasRealizadasPorMesModel>> totalVistoriasFeitasPorMes(
      String? ano) async {
    List<TotalVistoriasRealizadasPorMesModel> totalVistoriasList = [];

    try {
      var url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.getTotalSchedulesByMonthsEndpoint +
          '?ano=$ano'); // Adicionando o parâmetro de ano
      var response = await http.get(url);

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> decodedData = jsonDecode(response.body);

        totalVistoriasList = decodedData.map((item) {
          return TotalVistoriasRealizadasPorMesModel(
            qtdVistorias: item['qtdVistorias'] ?? 0,
            mes: item['mes'] ?? '',
          );
        }).toList();
      }
    } catch (_) {
      totalVistoriasList = [];
    }

    return totalVistoriasList;
  }

  // Future<List<TotalVistoriasRealizadasPorMesModel>>
  //     totalVistoriasFeitasPorMes() async {
  //   List<TotalVistoriasRealizadasPorMesModel> totalVistoriasList = [];

  //   try {
  //     var url = Uri.parse(ApiConstants.baseUrl +
  //         ApiConstants.getTotalSchedulesByMonthsEndpoint);
  //     var response = await http.get(url);

  //     if (response.statusCode == HttpStatus.ok) {
  //       final List<dynamic> decodedData = jsonDecode(response.body);

  //       totalVistoriasList = decodedData.map((item) {
  //         return TotalVistoriasRealizadasPorMesModel(
  //           qtdVistorias: item['qtdVistorias'] ?? 0,
  //           mes: item['mes'] ?? '',
  //         );
  //       }).toList();
  //     }
  //   } catch (_) {
  //     totalVistoriasList = [];
  //   }

  //   return totalVistoriasList;
  // }

  Future<TotalVehiclesModel> totalVeiculos() async {
    TotalVehiclesModel totalVeiculosModel = TotalVehiclesModel(qtdVeiculos: 0);
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.getTotalVehiclesEndpoint);
      var response = await http.get(url);

      if (response.statusCode == HttpStatus.ok) {
        final decodedData = jsonDecode(response.body);
        totalVeiculosModel =
            TotalVehiclesModel(qtdVeiculos: decodedData['qtdVeiculos'] ?? 0);
        0;
      }
    } catch (_) {
      totalVeiculosModel = TotalVehiclesModel(qtdVeiculos: 0);
    }

    return totalVeiculosModel;
  }
}
