import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_evydhence/api_constants.dart';
import 'package:project_evydhence/models/client_model.dart';

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

  Future<bool> postClient(
      String nomeRazao,
      String cpfCnpj,
      String rg,
      String dataNascFund,
      String email,
      String confirmarEmail,
      String telefone) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/persons/create/');
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
      print('Pessoa cadastrada com sucesso');
      return true;
    }
    print('Falha ao cadastrar');
    return false;
  }

  Future<bool> deleteClient(int idClient) async {
    var url = Uri.parse('${ApiConstants.baseUrl}/persons/$idClient/delete/');
    var response = await http.delete(url);
    getClients();
    if (response.statusCode == HttpStatus.ok) {
      return true; // Retornar o true se o cliente foi deletado
    } else {
      return false; // Retorna false se não foi excluido
    }
  }

  Future<List<ClientModel>?> getVehicles() async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.getVehiclesEndpoint);
    var response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      return userModelFromJson(
          response.body); // Retornar o modelo se a resposta for OK
    } else {
      return []; // Retornar uma lista vazia se o status da resposta não for OK
    }
  }
}
