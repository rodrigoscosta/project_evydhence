import 'dart:convert';

import 'package:http/http.dart';
import 'package:project_evydhence/models/client_model.dart';

class ApiService {
  /// Client HTTP pré-configurado para lidar com os endpoints da API de clientes
  Future getApi() async {
    var clientList = [];
    var path = Uri.parse('http://127.0.0.1:8000/persons/');
    var response = await get(path);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      for (Map<String, dynamic> item in data) {
        clientList.add(ClientModel.fromJson(item));
      }
    }
    return clientList;
  }

}
