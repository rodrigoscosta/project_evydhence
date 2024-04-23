import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/cnpj_mask.dart';
import 'package:project_evydhence/components/cpf_cnpj_mask.dart';
import 'package:project_evydhence/components/cpf_mask.dart';
import 'package:project_evydhence/components/date_mask.dart';
import 'package:project_evydhence/components/date_parser.dart';
import 'package:project_evydhence/components/phone_mask.dart';
import 'package:project_evydhence/components/text_formatter.dart';
import 'package:project_evydhence/components/text_input_form_field.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/views/home_page.dart';

class ClientRegisterForm extends StatefulWidget {
  const ClientRegisterForm({super.key});

  @override
  State<ClientRegisterForm> createState() => _ClientRegisterFormState();
}

class _ClientRegisterFormState extends State<ClientRegisterForm> {
  bool _isInitializing = true;
  final cliente = GetIt.I<ClientController>();
  final _formKey = GlobalKey<FormState>();
  final _cpfCnpjController = TextEditingController(text: '');
  final _rgController = TextEditingController(text: '');
  final _nomeController = TextEditingController(text: '');
  final _telefoneController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _confirmarEmailController = TextEditingController(text: '');
  final _dataNascFundController = TextEditingController(text: '');
  final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final _cpfMask = CpfMask();
  final _cnpjMask = CnpjMask();
  final _cpfCnpjMask = CpfCnpjMask();
  final _phoneMask = PhoneMask();

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

  void _handleDataDeFundacaoChanged(
    String value, {
    bool changeControllerText = false,
  }) {
    cliente.setDataNascFund(value);
    if (changeControllerText) {
      _dataNascFundController.text = cliente.dataNascFund.split(' ').first;
    }
  }

  void _cancel() {
    cliente.clearForm();
    Navigator.pop(context);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    cliente.clearForm();

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
                          'Adicionar cliente',
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
                                  labelText: 'Nome/Razão Social',
                                  required: true,
                                  controller: _nomeController,
                                  keyboardType: TextInputType.visiblePassword,
                                  onChanged: cliente.setNomeRazao,
                                  maxLength: 60,
                                ),
                                TextInputFormField(
                                  labelText: 'CPF/CNPJ',
                                  required: true,
                                  controller: _cpfCnpjController,
                                  keyboardType: TextInputType.number,
                                  onChanged: cliente.setCpfCnpj,
                                  inputFormatters: [_cpfCnpjMask],
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                                TextInputFormField(
                                  labelText: 'RG',
                                  required: true,
                                  controller: _rgController,
                                  keyboardType: TextInputType.visiblePassword,
                                  onChanged: cliente.setRg,
                                  maxLength: 20,
                                ),
                                TextInputFormField(
                                  labelText: 'Telefone',
                                  required: true,
                                  controller: _telefoneController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [_phoneMask],
                                  onChanged: cliente.setTelefone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return null;
                                    }
                                    if (!_phoneMask.validationRegExp
                                        .hasMatch(value)) {
                                      return 'Telefone incompleto';
                                    }
                                    return null;
                                  },
                                ),
                                TextInputFormField(
                                  labelText: 'Email',
                                  required: true,
                                  maxLength: 60,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: cliente.setEmail,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return null;
                                    }
                                    return emailRegExp.hasMatch(value)
                                        ? null
                                        : 'Email inválido';
                                  },
                                  inputFormatters: [LowerCaseTextFormatter()],
                                  textCapitalization: TextCapitalization.none,
                                  enableInteractiveSelection: false,
                                ),
                                TextInputFormField(
                                  labelText: 'Confirmar email',
                                  required: true,
                                  maxLength: 60,
                                  controller: _confirmarEmailController,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: cliente.setConfirmarEmail,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return null;
                                    }
                                    return cliente.confirmarEmailEqualsToEmail
                                        ? null
                                        : 'Email diferente do digitado';
                                  },
                                  inputFormatters: [LowerCaseTextFormatter()],
                                  textCapitalization: TextCapitalization.none,
                                  enableInteractiveSelection: false,
                                ),
                                TextInputFormField(
                                  labelText: 'Data de Nascimento/Fundação',
                                  controller: _dataNascFundController,
                                  required: true,
                                  keyboardType: TextInputType.datetime,
                                  inputFormatters: [DateMask()],
                                  onChanged: (value) {
                                    if (isUsingDatePattern(value)) {
                                      _handleDataDeFundacaoChanged(
                                          '$value 00:00:00');
                                    }
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.event_rounded),
                                      onPressed: () async {
                                        final result = await showDatePicker(
                                          context: context,
                                          locale: const Locale('pt', 'BR'),
                                          initialDate:
                                              cliente.dataFundacaoAsDateTime ??
                                                  DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                          helpText:
                                              'Selecione a data de fundação',
                                          cancelText: 'Cancelar',
                                          confirmText: 'Confirmar',
                                        );
                                        if (result != null) {
                                          _handleDataDeFundacaoChanged(
                                            fromDateTimeToDateUsingPattern(
                                                result),
                                            changeControllerText: true,
                                          );
                                        }
                                      },
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
