import 'package:project_evydhence/models/client_model.dart';

final DUMMY_CLIENTS = {
  '1': ClientModel(
      indexClient: 1,
      idClient: 1,
      cpfCnpj: '282.690.820-07',
      rg: '98.456.045-4',
      nomeRazao: 'Rodrigo teste',
      telefone: '(11)95752-8623',
      email: 'email@email.com',
      confirmarEmail: 'email@email.com',
      dataNascFund: DateTime.now(),
      listaVeiculos: []),
  '2': ClientModel(
      indexClient: 2,
      idClient: 2,
      cpfCnpj: '282.690.820-07',
      rg: '98.456.045-4',
      nomeRazao: 'Ana Liz',
      telefone: '(11)95752-8623',
      email: 'ana@email.com',
      confirmarEmail: 'ana@email.com',
      dataNascFund: DateTime.now(),
      listaVeiculos: []),
  '3': ClientModel(
      indexClient: 3,
      idClient: 3,
      cpfCnpj: '282.690.820-07',
      rg: '98.456.045-4',
      nomeRazao: 'Pedro Silva',
      telefone: '(11)95752-8623',
      email: 'pedro@email.com',
      confirmarEmail: 'pedro@email.com',
      dataNascFund: DateTime.now(),
      listaVeiculos: []),
};
