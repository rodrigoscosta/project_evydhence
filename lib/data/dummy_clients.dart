import 'package:faker/faker.dart';
import 'package:project_evydhence/models/client_model.dart';

final DUMMY_CLIENTS = {
  '1': ClientModel(
      //indexClient: faker.randomGenerator.integer(100),
      idClient: faker.randomGenerator.integer(100),
      cpfCnpj: faker.randomGenerator.string(14),
      rg: faker.randomGenerator.string(16),
      nomeRazao: faker.person.name(),
      telefone: faker.randomGenerator.string(11),
      email: faker.internet.email(),
      confirmarEmail: faker.internet.email(),
      dataNascFund: DateTime.now().toString(),
      //listaVeiculos: []
      ),
  '2': ClientModel(
      //indexClient: faker.randomGenerator.integer(100),
      idClient: faker.randomGenerator.integer(100),
      cpfCnpj: faker.randomGenerator.string(14),
      rg: faker.randomGenerator.string(16),
      nomeRazao: faker.person.name(),
      telefone: faker.randomGenerator.string(11),
      email: faker.internet.email(),
      confirmarEmail: faker.internet.email(),
      dataNascFund: DateTime.now().toString(),
      //listaVeiculos: []
      ),
  '3': ClientModel(
      //indexClient: faker.randomGenerator.integer(100),
      idClient: faker.randomGenerator.integer(100),
      cpfCnpj: faker.randomGenerator.string(14),
      rg: faker.randomGenerator.string(16),
      nomeRazao: faker.person.name(),
      telefone: faker.randomGenerator.string(11),
      email: faker.internet.email(),
      confirmarEmail: faker.internet.email(),
      dataNascFund: DateTime.now().toString(),
      //listaVeiculos: []
      ),
};