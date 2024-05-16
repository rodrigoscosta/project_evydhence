import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/cpf_cnpj_mask.dart';
import 'package:project_evydhence/components/date_parser.dart';
import 'package:project_evydhence/components/phone_mask.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/models/client_model.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:project_evydhence/services/api_service.dart';
import 'package:project_evydhence/views/forms/client_register_form.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({super.key});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  late List<ClientModel>? _clientModel = [];
  final cliente = GetIt.I<ClientController>();
  bool _isInitializing = true;
  final avatarClient = const CircleAvatar(child: Icon(Icons.person));
  final _cpfCnpjMask = CpfCnpjMask();
  final _phoneMask = PhoneMask();

  @override
  void didChangeDependencies() {
    if (_isInitializing) {
      _initialization();
    }
    super.didChangeDependencies();
  }

  void _initialization() {
    _isInitializing = false;
  }

  @override
  void initState() {
    super.initState();
  }

  void _getData() async {
    _clientModel = (await ApiService().getClients())!;
    cliente.setClients(_clientModel);
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void showSearchDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buscar cliente por CPF'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Digite o CPF (apenas números)',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // int id = int.tryParse(controller.text) ?? -1;
                // ClientModel? result = await ApiService().getClient(id);
                String cpfCnpj = controller.text;
                ClientModel? result = await ApiService().getClient(cpfCnpj);
                if (result != null) {
                  Navigator.of(context).pop();
                  showResult(context, result);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cliente não encontrado')),
                  );
                }
              },
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  void showResult(BuildContext context, ClientModel result) {
    ListView.builder(itemBuilder: (context, index) {
      return ListTile(
          leading: avatarClient,
          title: Text(result.nomeRazao),
          subtitle: Text(result.email));
    });

    setState(() {
      _clientModel = [result];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Clientes',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
            child: IconButton(
              //padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.clientForm,
                );
              },
              icon: const Icon(Icons.add),
              tooltip: 'Adicionar cliente',
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            padding: const EdgeInsets.fromLTRB(0, 0, 30.0, 0),
            onPressed: () {
              showSearchDialog(context);
            },
            tooltip: 'Buscar cliente',
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _clientModel!.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: avatarClient,
              title: Text(_clientModel![index].nomeRazao),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CPF/CNPJ: ${_cpfCnpjMask.format(_clientModel![index].cpfCnpj)}',
                        ),
                        Text(
                          'Data de Nascimento: ${fromDateTimeToDateUsingPattern(DateTime.parse(_clientModel![index].dataNascFund))}',
                        ),
                        Text(
                          'Telefone: ${_phoneMask.format(_clientModel![index].telefone)}',
                        ),
                        Text(
                          'Email: ${_clientModel![index].email}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              trailing: SizedBox(
                width: 120,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.vehiclePage,
                            arguments: _clientModel![index].idClient);

                        cliente.setId(_clientModel![index].idClient);
                      },
                      icon: const Icon(Icons.directions_car),
                      tooltip: 'Veículos',
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ClientRegisterForm(
                            client: _clientModel![index],
                            clientId: _clientModel![index].idClient,
                          ),
                        ));
                        cliente.setIndexClient(index);
                      },
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar cliente',
                    ),
                    IconButton(
                      onPressed: () async {
                        await ApiService()
                            .deleteClient(_clientModel![index].idClient);
                        _getData();
                      },
                      icon: const Icon(Icons.delete),
                      tooltip: 'Deletar cliente',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Button(
                flavor: ButtonFlavor.elevated,
                onPressed: _getData,
                child: const Text('LISTAR TODOS OS CLIENTES'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
