import 'package:flutter/material.dart';
import 'package:project_evydhence/data/dummy_clients.dart';
import 'package:project_evydhence/models/client_model.dart';

class Clients with ChangeNotifier {
  final Map<String, ClientModel> _items = {...DUMMY_CLIENTS};

  List<ClientModel> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  ClientModel byIndex(int i) {
    return _items.values.elementAt(i);
  }

  void put(ClientModel client) {
    //if (client == null) return;

    //Adiciona ou altera alguém
    if (_items.containsKey(client.cpfCnpj)) {
      _items.update(
          client.cpfCnpj,
          (_) => ClientModel(
              idClient: client.idClient,
              cpfCnpj: client.cpfCnpj,
              rg: client.rg,
              nomeRazao: client.nomeRazao,
              telefone: client.telefone,
              email: client.email,
              confirmarEmail: client.confirmarEmail,
              dataNascFund: client.dataNascFund));
    } else {
      _items.putIfAbsent(
          client.cpfCnpj,
          () => ClientModel(
              idClient: client.idClient,
              cpfCnpj: client.cpfCnpj,
              rg: client.rg,
              nomeRazao: client.nomeRazao,
              telefone: client.telefone,
              email: client.email,
              confirmarEmail: client.confirmarEmail,
              dataNascFund: client.dataNascFund));
    }
    notifyListeners();
  }

  void remove(ClientModel client) {
    _items.remove(client.cpfCnpj);
    notifyListeners();
  }
}
