// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:project_evydhence/components/client_tile.dart';
// import 'package:project_evydhence/components/vehicle_tile.dart';
// import 'package:project_evydhence/controllers/client_controller.dart';
// import 'package:project_evydhence/provider/clients.dart';
// import 'package:project_evydhence/routes/app_routes.dart';
// import 'package:provider/provider.dart';

// class VehicleListPage extends StatefulWidget {
//   const VehicleListPage({super.key});

//   @override
//   State<VehicleListPage> createState() => _VehicleListPageState();
// }

// class _VehicleListPageState extends State<VehicleListPage> {
//   @override
//   Widget build(BuildContext context) {
//     final Clients clientes = Provider.of(context);
//     //final cliente = GetIt.I<ClientController>();

//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         title: const Text(
//           'Lista de veículos',
//           style: TextStyle(
//             color: Color(0xff484853),
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context).pushNamed(AppRoutes.clientForm);
//             },
//             icon: const Icon(Icons.add),
//             tooltip: 'Adicionar veículo',
//           ),
//         ],
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: ListView.builder(
//         itemCount: clientes.count, //cliente.list.length,
//         itemBuilder: (context, i) =>
//             VehicleTile(clientes.byIndex(i)), //ClientTile(cliente.byIndex(i)),
//       ),
//     );
//   }
// }
