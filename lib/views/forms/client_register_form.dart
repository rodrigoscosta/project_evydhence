import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/cep_mask.dart';
import 'package:project_evydhence/components/cpf_cnpj_mask.dart';
import 'package:project_evydhence/components/date_mask.dart';
import 'package:project_evydhence/components/date_parser.dart';
import 'package:project_evydhence/components/keep_only_digits.dart';
import 'package:project_evydhence/components/phone_mask.dart';
import 'package:project_evydhence/components/text_formatter.dart';
import 'package:project_evydhence/components/text_input_form_field.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/models/client_model.dart';
import 'package:project_evydhence/provider/zoom_provider.dart';
import 'package:project_evydhence/services/api_service.dart';

class ClientRegisterForm extends StatefulWidget {
  final bool isDarkMode;
  final ClientModel? client;
  final int? clientId;

  const ClientRegisterForm(
      {Key? key, required this.isDarkMode, this.client, this.clientId})
      : super(key: key);

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
  final _cpfCnpjMask = CpfCnpjMask();
  final _phoneMask = PhoneMask();
  final _cepMask = CepMask();
  final _cepController = TextEditingController(text: '');
  final _logradouroController = TextEditingController(text: '');
  final _numeroResidenciaController = TextEditingController(text: '');
  final _complementoController = TextEditingController(text: '');
  final _bairroController = TextEditingController(text: '');
  final _cidadeController = TextEditingController(text: '');
  final _estadoController = TextEditingController(text: '');
  final _ufController = TextEditingController(text: '');
  final zoomProvider = GetIt.I<ZoomProvider>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitializing || widget.clientId != null) {
      _initialization();
    }
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
    _cepController.dispose();
    _logradouroController.dispose();
    _numeroResidenciaController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  ClientModel? _currentClient;

  void _initialization() async {
    _isInitializing = false;

    if (widget.client != null && widget.clientId != null) {
      ApiService apiService = ApiService(); // Create an instance of ApiService
      ClientModel? updatedClient =
          await apiService.getClientById(widget.clientId!);
      if (updatedClient != null) {
        setState(() {
          _currentClient = updatedClient;
        });
      }
    } else {
      _currentClient = widget.client;
    }

    if (_currentClient != null) {
      final client = _currentClient!;

      _nomeController.text = client.nomeRazao;
      cliente.setNomeRazao(client.nomeRazao);

      _cpfCnpjController.text = _cpfCnpjMask.format(client.cpfCnpj);
      cliente.setCpfCnpj(client.cpfCnpj);

      _rgController.text = client.rg;
      cliente.setRg(client.rg);

      cliente.setSexo(client.sexo);

      _telefoneController.text = _phoneMask.format(client.telefone);
      cliente.setTelefone(client.telefone);

      _emailController.text = client.email;
      cliente.setEmail(client.email);

      _confirmarEmailController.text = client.confirmarEmail;
      cliente.setConfirmarEmail(client.confirmarEmail);

      final formattedDate =
          fromDateTimeToDateUsingPattern(DateTime.parse(client.dataNascFund));
      _dataNascFundController.text = formattedDate;
      cliente.setDataNascFund(formattedDate);

      _cepController.text = _cepMask.format(client.cep);
      cliente.setCep(client.cep);

      _logradouroController.text = client.logradouro;
      cliente.setLogradouro(client.logradouro);

      _numeroResidenciaController.text = client.numeroResidencia;
      cliente.setNumeroResidencia(client.numeroResidencia);

      _complementoController.text = client.complemento;
      cliente.setComplemento(client.complemento);

      _cidadeController.text = client.cidade;
      cliente.setCidade(client.cidade);

      _bairroController.text = client.bairro;
      cliente.setBairro(client.bairro);

      _estadoController.text = client.estado;
      cliente.setEstado(client.estado);

      _ufController.text = client.uf;
      cliente.setUf(client.uf);
    }
  }

  // void _initialization() {
  //   _isInitializing = false;

  //   if (widget.client != null) {
  //     final client = widget.client!;

  //     _nomeController.text = client.nomeRazao;
  //     cliente.setNomeRazao(client.nomeRazao);

  //     _cpfCnpjController.text = _cpfCnpjMask.format(client.cpfCnpj);
  //     cliente.setCpfCnpj(client.cpfCnpj);

  //     _rgController.text = client.rg;
  //     cliente.setRg(client.rg);

  //     _telefoneController.text = _phoneMask.format(client.telefone);
  //     cliente.setTelefone(client.telefone);

  //     _emailController.text = client.email;
  //     cliente.setEmail(client.email);

  //     _confirmarEmailController.text = client.confirmarEmail;
  //     cliente.setConfirmarEmail(client.confirmarEmail);

  //     final formattedDate =
  //         fromDateTimeToDateUsingPattern(DateTime.parse(client.dataNascFund));
  //     _dataNascFundController.text = formattedDate;
  //     cliente.setDataNascFund(formattedDate);

  //     _cepController.text = _cepMask.format(client.cep);
  //     cliente.setCep(client.cep);

  //     _logradouroController.text = client.logradouro;
  //     cliente.setLogradouro(client.logradouro);

  //     _numeroResidenciaController.text = client.numeroResidencia;
  //     cliente.setNumeroResidencia(client.numeroResidencia);

  //     _complementoController.text = client.complemento;
  //     cliente.setComplemento(client.complemento);

  //     _cidadeController.text = client.cidade;
  //     cliente.setCidade(client.cidade);

  //     _bairroController.text = client.bairro;
  //     cliente.setBairro(client.bairro);

  //     _estadoController.text = client.estado;
  //     cliente.setEstado(client.estado);

  //     _ufController.text = client.uf;
  //     cliente.setUf(client.uf);
  //   }
  // }

  void _handleDataDeFundacaoChanged(
    String value, {
    bool changeControllerText = false,
  }) {
    cliente.setDataNascFund(value);
    if (changeControllerText) {
      _dataNascFundController.text = cliente.dataNascFund.split(' ').first;
    }
  }

  Future<void> _buscarCep(String cep) async {
    if (cep.length == 8) {
      final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final decodedData = utf8.decode(response.bodyBytes);
          final data = json.decode(decodedData);

          if (data.containsKey('erro')) {
            _mostrarErro('CEP não encontrado.');
          } else {
            setState(() {
              _logradouroController.text = data['logradouro'] ?? '';
              _bairroController.text = data['bairro'] ?? '';
              _cidadeController.text = data['localidade'] ?? '';
              _estadoController.text = data['estado'] ?? '';
              _ufController.text = data['uf'] ?? '';

              cliente.setLogradouro(data['logradouro'] ?? '');
              cliente.setBairro(data['bairro'] ?? '');
              cliente.setCidade(data['localidade'] ?? '');
              cliente.setEstado(data['estado'] ?? '');
              cliente.setUf(data['uf'] ?? '');
            });
          }
        } else {
          _mostrarErro('Erro ao buscar o CEP.');
        }
      } catch (e) {
        _mostrarErro('Erro ao conectar com o servidor.');
      }
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(mensagem, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red),
    );
  }

  void _cancel() {
    cliente.clearForm();
    Navigator.pop(context);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.clientId != null) {
      // Se o ID do cliente estiver definido, chama o método de atualização
      await updateClient();
    } else {
      // Caso contrário, chama o método de criação de cliente
      await createClient();
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
            'Cliente cadastrado/editado com sucesso!',
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    cliente.clearForm();
  }

  Future<void> createClient() async {
    await ApiService().postClient(
        cliente.nomeRazao,
        keepOnlyDigits(cliente.cpfCnpj),
        cliente.rg,
        cliente.dataNascFund,
        cliente.sexo!,
        cliente.email,
        cliente.confirmarEmail,
        keepOnlyDigits(cliente.telefone),
        keepOnlyDigits(cliente.cep),
        cliente.logradouro,
        cliente.numeroResidencia,
        cliente.complemento,
        cliente.bairro,
        cliente.cidade,
        cliente.estado,
        cliente.uf);
  }

  Future<void> updateClient() async {
    await ApiService().putClient(
        widget.clientId!,
        cliente.nomeRazao,
        cliente.cpfCnpj,
        cliente.rg,
        cliente.dataNascFund,
        cliente.sexo!,
        cliente.email,
        cliente.confirmarEmail,
        keepOnlyDigits(cliente.telefone),
        keepOnlyDigits(cliente.cep),
        cliente.logradouro,
        cliente.numeroResidencia,
        cliente.complemento,
        cliente.bairro,
        cliente.cidade,
        cliente.estado,
        cliente.uf);
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
            'Adicionar cliente',
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
                                labelText: 'Nome/Razão Social',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _nomeController,
                                keyboardType: TextInputType.text,
                                onChanged: cliente.setNomeRazao,
                                maxLength: 60,
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
                                labelText: 'CPF/CNPJ',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _cpfCnpjController,
                                keyboardType: TextInputType.number,
                                onChanged: cliente.setCpfCnpj,
                                inputFormatters: [_cpfCnpjMask],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                labelText: 'RG',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _rgController,
                                keyboardType: TextInputType.visiblePassword,
                                onChanged: cliente.setRg,
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
                                labelText: 'Data de Nascimento/Fundação',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                controller: _dataNascFundController,
                                required: true,
                                keyboardType: TextInputType.datetime,
                                inputFormatters: [DateMask()],
                                onChanged: (value) {
                                  if (isUsingDatePattern(value)) {
                                    _handleDataDeFundacaoChanged(value);
                                  }
                                },
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
                                  suffixIcon: IconButton(
                                    iconSize: 20.0 * zoomProvider.scaleFactor,
                                    icon: Icon(
                                      Icons.event_rounded,
                                      color: widget.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
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
                                          fromDateUsingPatternToFormattedString(
                                              result.toString()),
                                          changeControllerText: true,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    label: Text.rich(
                                      TextSpan(
                                        text: 'Gênero',
                                        children: [
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(
                                              fontSize: 16.0 *
                                                  zoomProvider.scaleFactor,
                                              color: widget.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: widget.isDarkMode
                                        ? Colors.grey[800]
                                        : Colors.white,
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    labelStyle: TextStyle(
                                      fontSize: 16.0 * zoomProvider.scaleFactor,
                                      color: widget.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  dropdownColor: widget.isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  value: (cliente.sexo == 'M' ||
                                          cliente.sexo == 'F')
                                      ? cliente.sexo
                                      : null,
                                  onChanged: cliente.setSexo,
                                  items: [
                                    DropdownMenuItem(
                                      value: 'M',
                                      child: Text(
                                        'Masculino',
                                        style: TextStyle(
                                          fontSize:
                                              16.0 * zoomProvider.scaleFactor,
                                          color: widget.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'F',
                                      child: Text(
                                        'Feminino',
                                        style: TextStyle(
                                          fontSize:
                                              16.0 * zoomProvider.scaleFactor,
                                          color: widget.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextInputFormField(
                                labelText: 'Telefone',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _telefoneController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [_phoneMask],
                                onChanged: cliente.setTelefone,
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
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
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
                                labelText: 'Confirmar email',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
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
                                labelText: 'CEP',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _cepController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _buscarCep(
                                      value.replaceAll(RegExp(r'[^0-9]'), ''));

                                  cliente.setCep(
                                      value.replaceAll(RegExp(r'[^0-9]'), ''));
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                inputFormatters: [_cepMask],
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
                                labelText: 'Logradouro',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _logradouroController,
                                keyboardType: TextInputType.streetAddress,
                                onChanged: cliente.setLogradouro,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                labelText: 'Número',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _numeroResidenciaController,
                                keyboardType: TextInputType.streetAddress,
                                onChanged: cliente.setNumeroResidencia,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                labelText: 'Complemento',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: false,
                                controller: _complementoController,
                                keyboardType: TextInputType.text,
                                onChanged: cliente.setComplemento,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                labelText: 'Bairro',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _bairroController,
                                keyboardType: TextInputType.text,
                                onChanged: cliente.setBairro,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                labelText: 'Cidade',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _cidadeController,
                                keyboardType: TextInputType.text,
                                onChanged: cliente.setCidade,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                labelText: 'Estado',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _estadoController,
                                keyboardType: TextInputType.streetAddress,
                                onChanged: cliente.setEstado,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                labelText: 'UF',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _ufController,
                                keyboardType: TextInputType.streetAddress,
                                onChanged: cliente.setUf,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
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
    );
  }
}
