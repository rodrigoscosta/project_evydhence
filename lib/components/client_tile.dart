import 'package:flutter/material.dart';
import 'package:project_evydhence/models/client_model.dart';
import 'package:project_evydhence/routes/app_routes.dart';

class ClientTile extends StatelessWidget {
  final ClientModel cliente;

  const ClientTile(this.cliente, {super.key});

  @override
  Widget build(BuildContext context) {
    const avatarClient = CircleAvatar(child: Icon(Icons.person));
    return ListTile(
      leading: avatarClient,
      title: Text(cliente.nomeRazao),
      subtitle: Text(cliente.email),
      trailing: SizedBox(
        width: 120,
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.directions_car),
              tooltip: 'Adicionar veículo',
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.clientForm,
                arguments: cliente);
              },
              icon: const Icon(Icons.edit),
              tooltip: 'Editar cliente',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
              tooltip: 'Deletar cliente',
            ),
          ],
        ),
      ),
    );
  }
}
