import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/text_input_form_field.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/controllers/vehicle_controller.dart';
import 'package:project_evydhence/models/vehicle_model.dart';
import 'package:project_evydhence/services/api_service.dart';
import 'package:project_evydhence/views/vehicle_list_page.dart';

class VehicleRegisterForm extends StatefulWidget {
  final VehicleModel? vehicle;
  final int? vehicleId;

  const VehicleRegisterForm({Key? key, this.vehicle, this.vehicleId})
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VehicleListPage(),
      ),
    );

    if (widget.vehicleId != null) {
      // Se o ID do cliente estiver definido, chama o método de atualização
      await updateVehicle();
    } else {
      // Caso contrário, chama o método de criação de veículo
      await createVehicle();
    }

    if (!_formKey.currentState!.validate()) return;

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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffE9E9EF),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Adicionar veículo',
                        style: TextStyle(
                          color: Color(0xff484853),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: const Color(0xff74747E),
                        onPressed: _cancel,
                      ),
                    ],
                  ),
                ),
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
                            child: const Text('Preencha os campos abaixo'),
                          ),
                          Wrap(
                            runSpacing: 26.0,
                            children: [
                              TextInputFormField(
                                labelText: 'Placa do veículo',
                                required: true,
                                controller: _placaController,
                                keyboardType: TextInputType.text,
                                onChanged: veiculo.setPlaca,
                                maxLength: 20,
                              ),
                              TextInputFormField(
                                labelText: 'Marca do veículo',
                                required: true,
                                controller: _marcaController,
                                keyboardType: TextInputType.text,
                                onChanged: veiculo.setMarca,
                              ),
                              TextInputFormField(
                                labelText: 'Modelo do veículo',
                                required: true,
                                controller: _modeloController,
                                keyboardType: TextInputType.text,
                                onChanged: veiculo.setModelo,
                                maxLength: 20,
                              ),
                              TextInputFormField(
                                labelText: 'Tipo do veículo',
                                required: true,
                                controller: _tipoVeiculoController,
                                keyboardType: TextInputType.text,
                                onChanged: veiculo.setTipoVeiculo,
                                maxLength: 20,
                              ),
                              TextInputFormField(
                                labelText: 'Ano de fabricação',
                                required: true,
                                controller: _anoFabricacaoController,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: veiculo.setAnoFabricacao,
                                maxLength: 4,
                              ),
                              TextInputFormField(
                                labelText: 'Ano do modelo',
                                required: true,
                                controller: _anoModeloEmailController,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: veiculo.setAnoModelo,
                                maxLength: 4,
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
            padding: const EdgeInsets.all(24.0),
            child: Observer(
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Button(
                    flavor: ButtonFlavor.outlined,
                    onPressed: _cancel,
                    child: const Text('CANCELAR'),
                  ),
                  Button(
                    flavor: ButtonFlavor.elevated,
                    onPressed: _submit,
                    child: const Text('ADICIONAR/EDITAR'),
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
