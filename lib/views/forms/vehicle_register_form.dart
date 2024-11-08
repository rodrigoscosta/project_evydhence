import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/text_input_form_field.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/controllers/vehicle_controller.dart';
import 'package:project_evydhence/models/vehicle_model.dart';
import 'package:project_evydhence/provider/zoom_provider.dart';
import 'package:project_evydhence/services/api_service.dart';
import 'package:project_evydhence/views/vehicle_list_page.dart';

class VehicleRegisterForm extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final VehicleModel? vehicle;
  final int? vehicleId;

  const VehicleRegisterForm(
      {Key? key,
      required this.isDarkMode,
      required this.onThemeChanged,
      this.vehicle,
      this.vehicleId})
      : super(key: key);

  @override
  State<VehicleRegisterForm> createState() => _VehicleRegisterFormState();
}

class _VehicleRegisterFormState extends State<VehicleRegisterForm> {
  bool _isInitializing = true;
  final veiculo = GetIt.I<VehicleController>();
  final cliente = GetIt.I<ClientController>();
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController(text: '');
  final _marcaController = TextEditingController(text: '');
  final _modeloController = TextEditingController(text: '');
  final _tipoVeiculoController = TextEditingController(text: '');
  final _anoFabricacaoController = TextEditingController(text: '');
  final _anoModeloEmailController = TextEditingController(text: '');
  final zoomProvider = GetIt.I<ZoomProvider>();

  @override
  void didChangeDependencies() {
    if (_isInitializing) {
      _initialization();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _placaController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _tipoVeiculoController.dispose();
    _anoFabricacaoController.dispose();
    _anoModeloEmailController.dispose();
    super.dispose();
  }

  void _initialization() {
    _isInitializing = false;

    if (widget.vehicle != null) {
      final vehicle = widget.vehicle!;

      _placaController.text = vehicle.placa;
      veiculo.setPlaca(vehicle.placa);

      _marcaController.text = vehicle.marca;
      veiculo.setMarca(vehicle.marca);

      _modeloController.text = vehicle.modelo;
      veiculo.setModelo(vehicle.modelo);

      _tipoVeiculoController.text = vehicle.tipoVeiculo;
      veiculo.setTipoVeiculo(vehicle.tipoVeiculo);

      _anoFabricacaoController.text = vehicle.anoFabricacao;
      veiculo.setAnoFabricacao(vehicle.anoFabricacao);

      _anoModeloEmailController.text = vehicle.anoModelo;
      veiculo.setAnoModelo(vehicle.anoModelo);
    }
  }

  void _cancel() {
    veiculo.clearForm();
    Navigator.pop(context);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.vehicleId != null) {
      // Se o ID do cliente estiver definido, chama o método de atualização
      await updateVehicle();
    } else {
      // Caso contrário, chama o método de criação de cliente
      await createVehicle();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.white,
          title: Text(
            'Sucesso',
            style: TextStyle(
              fontSize: 16.0 * zoomProvider.scaleFactor,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            'Veículo cadastrado/editado com sucesso!',
            style: TextStyle(
              fontSize: 16.0 * zoomProvider.scaleFactor,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          actions: <Widget>[
            Button(
              flavor: ButtonFlavor.elevated,
              child: Text(
                'Voltar',
                style: TextStyle(
                  fontSize: 16.0 * zoomProvider.scaleFactor,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleListPage(
                        isDarkMode: widget.isDarkMode,
                        onThemeChanged: widget.onThemeChanged),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
    veiculo.clearForm();
  }

  Future<void> createVehicle() async {
    await ApiService().postVehicle(
        cliente.idClient,
        veiculo.placa,
        veiculo.marca,
        veiculo.modelo,
        veiculo.tipoVeiculo,
        veiculo.anoFabricacao,
        veiculo.anoModelo);
  }

  Future<void> updateVehicle() async {
    await ApiService().putVehicle(
        widget.vehicleId!,
        cliente.idClient,
        veiculo.placa,
        veiculo.marca,
        veiculo.modelo,
        veiculo.tipoVeiculo,
        veiculo.anoFabricacao,
        veiculo.anoModelo);
  }

  List<Widget> _buildAppBarActions() {
    return [
      Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              IconButton(
                iconSize: 28.0 * zoomProvider.scaleFactor,
                tooltip: 'Cancelar',
                icon: const Icon(Icons.close),
                color: widget.isDarkMode ? Colors.white : Colors.black,
                onPressed: _cancel,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Adicionar veículo',
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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 29.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.only(top: 30.0, bottom: 26.0),
                            child: Text(
                              'Preencha os campos abaixo',
                              style: TextStyle(
                                fontSize: 24.0 * zoomProvider.scaleFactor,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          Wrap(
                            runSpacing: 26.0,
                            children: [
                              TextInputFormField(
                                labelText: 'Placa do veículo',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _placaController,
                                keyboardType: TextInputType.text,
                                onChanged: veiculo.setPlaca,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: widget.isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 16.0 * zoomProvider.scaleFactor,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              TextInputFormField(
                                labelText: 'Marca do veículo',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _marcaController,
                                keyboardType: TextInputType.text,
                                onChanged: veiculo.setMarca,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: widget.isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 16.0 * zoomProvider.scaleFactor,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              TextInputFormField(
                                labelText: 'Modelo do veículo',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _modeloController,
                                keyboardType: TextInputType.text,
                                onChanged: veiculo.setModelo,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: widget.isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 16.0 * zoomProvider.scaleFactor,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              TextInputFormField(
                                labelText: 'Tipo do veículo',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _tipoVeiculoController,
                                keyboardType: TextInputType.text,
                                onChanged: veiculo.setTipoVeiculo,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: widget.isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 16.0 * zoomProvider.scaleFactor,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              TextInputFormField(
                                labelText: 'Ano de fabricação',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _anoFabricacaoController,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: veiculo.setAnoFabricacao,
                                maxLength: 4,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: widget.isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 16.0 * zoomProvider.scaleFactor,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              TextInputFormField(
                                labelText: 'Ano do modelo',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _anoModeloEmailController,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: veiculo.setAnoModelo,
                                maxLength: 4,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: widget.isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 16.0 * zoomProvider.scaleFactor,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0 * zoomProvider.scaleFactor),
            child: Observer(
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Button(
                    flavor: ButtonFlavor.elevated,
                    onPressed: _cancel,
                    child: Text(
                      'CANCELAR',
                      style: TextStyle(
                        fontSize: 16.0 * zoomProvider.scaleFactor,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Button(
                    flavor: ButtonFlavor.elevated,
                    onPressed: _submit,
                    child: Text(
                      'ADICIONAR/EDITAR',
                      style: TextStyle(
                        fontSize: 16.0 * zoomProvider.scaleFactor,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
