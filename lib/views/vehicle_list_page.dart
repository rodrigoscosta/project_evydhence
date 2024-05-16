import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/controllers/vehicle_controller.dart';
import 'package:project_evydhence/models/vehicle_model.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:project_evydhence/services/api_service.dart';
import 'package:project_evydhence/views/forms/vehicle_register_form.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({super.key});

  @override
  State<VehicleListPage> createState() => _VehicleListPagePageState();
}

class _VehicleListPagePageState extends State<VehicleListPage> {
  late List<VehicleModel>? _vehicleModel = [];
  final cliente = GetIt.I<ClientController>();
  final veiculo = GetIt.I<VehicleController>();
  bool _isInitializing = true;
  final avatarVehicle = const CircleAvatar(child: Icon(Icons.directions_car));

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
    _getData();
    super.initState();
  }

  void _getData() async {
    _vehicleModel = (await ApiService().getVehiclesByClient(cliente.idClient))!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Veículos',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.vehicleForm,
                );
              },
              icon: const Icon(Icons.add),
              tooltip: 'Adicionar veículo',
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _vehicleModel!.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: avatarVehicle,
              title: Text(_vehicleModel![index].placa),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Marca: ${_vehicleModel![index].marca}',
                        ),
                        Text(
                          'Modelo: ${_vehicleModel![index].modelo}',
                        ),
                        Text(
                          'Tipo veículo: ${_vehicleModel![index].tipoVeiculo}',
                        ),
                        Text(
                          'Ano fabricação: ${_vehicleModel![index].anoFabricacao}',
                        ),
                        Text(
                          'Ano modelo: ${_vehicleModel![index].anoModelo}',
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
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VehicleRegisterForm(
                            vehicle: _vehicleModel![index],
                            vehicleId: _vehicleModel![index].idVeiculo,
                          ),
                        ));
                        veiculo.setIndexVehicle(index);
                      },
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar veículo',
                    ),
                    IconButton(
                      onPressed: () async {
                        await ApiService()
                            .deleteVehicle(_vehicleModel![index].idVeiculo);
                        _getData();
                      },
                      icon: const Icon(Icons.delete),
                      tooltip: 'Deletar veículo',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
