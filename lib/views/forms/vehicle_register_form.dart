import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/cpf_cnpj_mask.dart';
import 'package:project_evydhence/components/phone_mask.dart';
import 'package:project_evydhence/components/text_input_form_field.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/controllers/vehicle_controller.dart';
import 'package:project_evydhence/views/home_page.dart';

class VehicleRegisterForm extends StatefulWidget {
  const VehicleRegisterForm({super.key});

  @override
  State<VehicleRegisterForm> createState() => _VehicleRegisterFormState();
}

class _VehicleRegisterFormState extends State<VehicleRegisterForm> {
  bool _isInitializing = true;
  final veiculo = GetIt.I<VehicleController>();
  final _formKey = GlobalKey<FormState>();
  final _cpfCnpjController = TextEditingController(text: '');
  final _rgController = TextEditingController(text: '');
  final _nomeController = TextEditingController(text: '');
  final _telefoneController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _confirmarEmailController = TextEditingController(text: '');
  final _dataNascFundController = TextEditingController(text: '');

  @override
  void didChangeDependencies() {
    if (_isInitializing) {
      _initialization();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _cpfCnpjController.dispose();
    _rgController.dispose();
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _confirmarEmailController.dispose();
    _dataNascFundController.dispose();
    super.dispose();
  }

  void _initialization() {
    _isInitializing = false;
  }


  void _cancel() {
    veiculo.clearForm();
    Navigator.pop(context);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    veiculo.clearForm();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
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
          child: Observer(
            builder: (context) => Form(
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
                              margin: const EdgeInsets.only(
                                  top: 30.0, bottom: 26.0),
                              child: const Text('Preencha os campos abaixo'),
                            ),
                            Wrap(
                              runSpacing: 26.0,
                              children: [
                                TextInputFormField(
                                  labelText: 'Placa do veículo',
                                  required: true,
                                  controller: _nomeController,
                                  keyboardType: TextInputType.text,                 
                                  onChanged: veiculo.setPlaca,
                                  maxLength: 20,
                                ),
                                TextInputFormField(
                                  labelText: 'Marca do veículo',
                                  required: true,
                                  controller: _cpfCnpjController,
                                  keyboardType: TextInputType.text,
                                  onChanged: veiculo.setMarca,
                                ),
                                TextInputFormField(
                                  labelText: 'Modelo do veículo',
                                  required: true,
                                  controller: _rgController,
                                  keyboardType: TextInputType.text,
                                  onChanged: veiculo.setModelo,
                                  maxLength: 20,
                                ),
                                TextInputFormField(
                                  labelText: 'Tipo do veículo',
                                  required: true,
                                  controller: _rgController,
                                  keyboardType: TextInputType.text,
                                  onChanged: veiculo.setTipoVeiculo,
                                  maxLength: 20,
                                ),
                                TextInputFormField(
                                  labelText: 'Ano de fabricação',
                                  required: true,
                                  controller: _rgController,
                                  keyboardType: TextInputType.visiblePassword,
                                  onChanged: veiculo.setAnoFabricacao,
                                  maxLength: 4,
                                ),
                                TextInputFormField(
                                  labelText: 'Ano do modelo',
                                  required: true,
                                  controller: _rgController,
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
                    onPressed:
                        _submit, //cliente.isFormComplete ? _submit : null,
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
