import 'package:flutter/material.dart';
import 'package:project_evydhence/models/client_model.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:project_evydhence/services/api_service.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({super.key});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  late List<ClientModel>? _clientModel = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _clientModel = (await ApiService().getClients())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    const avatarClient = CircleAvatar(child: Icon(Icons.person));

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
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.clientForm,
              );
            },
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar cliente',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            tooltip: 'Buscar cliente',
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _clientModel == null || _clientModel!.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _clientModel!.length, //clientes.count,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: avatarClient,
                  title: Text(_clientModel![index].nomeRazao),
                  subtitle: Text(_clientModel![index].email),
                  trailing: SizedBox(
                    width: 120,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                AppRoutes.vehicleForm,
                                arguments: _clientModel![index]);
                          },
                          icon: const Icon(Icons.directions_car),
                          tooltip: 'Veículos',
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                AppRoutes.clientForm,
                                arguments: _clientModel![index]);
                          },
                          icon: const Icon(Icons.edit),
                          tooltip: 'Editar cliente',
                        ),
                        IconButton(
                          onPressed: () async {
                            await ApiService()
                                .deleteClient(_clientModel![index].idClient);
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete),
                          tooltip: 'Deletar cliente',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
