import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/controllers/schedule_controller.dart';
import 'package:project_evydhence/controllers/vehicle_controller.dart';
import 'package:project_evydhence/models/vehicle_model.dart';
import 'package:project_evydhence/provider/zoom_provider.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:project_evydhence/services/api_service.dart';
import 'package:project_evydhence/views/forms/vehicle_register_form.dart';

class VehicleListPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const VehicleListPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<VehicleListPage> createState() => _VehicleListPagePageState();
}

class _VehicleListPagePageState extends State<VehicleListPage> {
  late List<VehicleModel>? _vehicleModel = [];
  final cliente = GetIt.I<ClientController>();
  final veiculo = GetIt.I<VehicleController>();
  final agendamento = GetIt.I<ScheduleController>();
  bool _isInitializing = true;
  final zoomProvider = GetIt.I<ZoomProvider>();

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

  void _toggleTheme(bool isDarkMode) {
    widget.onThemeChanged(isDarkMode);
  }

  List<Widget> _buildAppBarActions() {
    return [
      Container(
        margin: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
        child: IconButton(
          iconSize: 28.0 * zoomProvider.scaleFactor,
          color: widget.isDarkMode ? Colors.white : Colors.black,
          onPressed: () {
            Navigator.of(context).pushNamed(
              AppRoutes.vehicleForm,
            );
          },
          icon: const Icon(Icons.add),
          tooltip: 'Adicionar veículo',
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isDarkMode ? Icons.brightness_2 : Icons.brightness_5,
            color: widget.isDarkMode ? Colors.white : Colors.black,
            size: 28.0 * zoomProvider.scaleFactor,
          ),
          Switch(
            value: widget.isDarkMode,
            onChanged: (value) {
              _toggleTheme(value);
            },
            activeColor: Colors.blue,
            inactiveTrackColor: Colors.grey,
            inactiveThumbColor: Colors.white,
            activeTrackColor: Colors.blueAccent,
          ),
          // Botão de Zoom
          IconButton(
            iconSize: 28.0 * zoomProvider.scaleFactor,
            tooltip: 'Aumentar zoom',
            icon: Icon(
              Icons.zoom_in,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                zoomProvider.increaseZoom();
              });
            },
          ),
          IconButton(
            iconSize: 28.0 * zoomProvider.scaleFactor,
            tooltip: 'Diminuir zoom',
            icon: Icon(
              Icons.zoom_out,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                zoomProvider.decreaseZoom();
              });
            },
          ),
        ],
      ),
    ];
  }

  Widget _buildCardActions(int index) {
    return SizedBox(
      width: 150 * zoomProvider.scaleFactor,
      child: Row(
        children: [
          IconButton(
            iconSize: 28.0 * zoomProvider.scaleFactor,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.schedulePage,
                  arguments: _vehicleModel![index].idVeiculo);
              veiculo.setIdVeiculo(_vehicleModel![index].idVeiculo);
            },
            icon: Icon(
              Icons.wysiwyg_sharp,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            tooltip: 'Agendamentos',
          ),
          IconButton(
            iconSize: 28.0 * zoomProvider.scaleFactor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VehicleRegisterForm(
                  vehicle: _vehicleModel![index],
                  vehicleId: _vehicleModel![index].idVeiculo,
                  isDarkMode: widget.isDarkMode,
                  onThemeChanged: widget.onThemeChanged,
                ),
              ));
              veiculo.setIndexVehicle(index);
            },
            icon: Icon(
              Icons.edit,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            tooltip: 'Editar veículo',
          ),
          IconButton(
            iconSize: 28.0 * zoomProvider.scaleFactor,
            onPressed: () async {
              await ApiService().deleteVehicle(_vehicleModel![index].idVeiculo);
              _getData();
            },
            icon: Icon(
              Icons.delete,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            tooltip: 'Deletar veículo',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarVehicle = CircleAvatar(
        radius: 24.0 * zoomProvider.scaleFactor,
        child: const Icon(Icons.directions_car));
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Veículos',
          style: TextStyle(
            fontSize: 24.0 * zoomProvider.scaleFactor,
            fontWeight: FontWeight.w500,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          tooltip: 'Voltar',
          iconSize: 28.0 * zoomProvider.scaleFactor,
          icon: Icon(
            Icons.arrow_back,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: _buildAppBarActions(),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0 * zoomProvider.scaleFactor),
        child: ListView.builder(
          itemCount: _vehicleModel!.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(
                vertical: 8.0 * zoomProvider.scaleFactor,
                horizontal: 16.0 * zoomProvider.scaleFactor,
              ),
              color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
              child: Padding(
                padding: EdgeInsets.all(12.0 * zoomProvider.scaleFactor),
                child: ListTile(
                  leading: avatarVehicle,
                  title: Text(
                    _vehicleModel![index].placa,
                    style: TextStyle(
                      fontSize: 16.0 * zoomProvider.scaleFactor,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Marca: ${_vehicleModel![index].marca}',
                              style: TextStyle(
                                fontSize: 14.0 * zoomProvider.scaleFactor,
                                color: widget.isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            Text(
                              'Modelo: ${_vehicleModel![index].modelo}',
                              style: TextStyle(
                                fontSize: 14.0 * zoomProvider.scaleFactor,
                                color: widget.isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            Text(
                              'Tipo veículo: ${_vehicleModel![index].tipoVeiculo}',
                              style: TextStyle(
                                fontSize: 14.0 * zoomProvider.scaleFactor,
                                color: widget.isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            Text(
                              'Ano fabricação: ${_vehicleModel![index].anoFabricacao}',
                              style: TextStyle(
                                fontSize: 14.0 * zoomProvider.scaleFactor,
                                color: widget.isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            Text(
                              'Ano modelo: ${_vehicleModel![index].anoModelo}',
                              style: TextStyle(
                                fontSize: 14.0 * zoomProvider.scaleFactor,
                                color: widget.isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: _buildCardActions(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
