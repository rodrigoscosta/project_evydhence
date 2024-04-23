import 'package:flutter/material.dart';
import 'package:project_evydhence/components/client_tile.dart';
import 'package:project_evydhence/provider/clients.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:provider/provider.dart';

class ClientListPage extends StatelessWidget {
  const ClientListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Clients clientes = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Lista de clientes',
          style: TextStyle(
            color: Color(0xff484853),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.clientForm);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar cliente',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            tooltip: 'Buscar cliente',
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: clientes.count,
        itemBuilder: (context, i) => ClientTile(clientes.byIndex(i)),
      ),
    );
  }
}
