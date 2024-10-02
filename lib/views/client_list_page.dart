import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/cpf_cnpj_mask.dart';
import 'package:project_evydhence/components/date_parser.dart';
import 'package:project_evydhence/components/phone_mask.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/models/client_model.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:project_evydhence/services/api_service.dart';
import 'package:project_evydhence/views/forms/client_register_form.dart';

class ClientListPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const ClientListPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  late List<ClientModel>? _clientModel = [];
  final cliente = GetIt.I<ClientController>();
  bool _isInitializing = true;
  final avatarClient = const CircleAvatar(child: Icon(Icons.person));
  final _cpfCnpjMask = CpfCnpjMask();
  final _phoneMask = PhoneMask();

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
    super.initState();
  }

  void _getData() async {
    _clientModel = (await ApiService().getClients())!;
    cliente.setClients(_clientModel);
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void _toggleTheme(bool isDarkMode) {
    widget.onThemeChanged(isDarkMode);
  }

  void showSearchDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: widget.isDarkMode ? Colors.grey[800] : Colors.white,
          title: Text(
            'Buscar cliente por CPF',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: TextField(
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              labelText: 'Digite o CPF (apenas números)',
              labelStyle: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Button(
              flavor: ButtonFlavor.elevated,
              onPressed: () async {
                String cpfCnpj = controller.text;
                ClientModel? result = await ApiService().getClient(cpfCnpj);
                if (result != null) {
                  Navigator.pop(context);
                  showResult(context, result);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                      'Cliente não encontrado',
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    )),
                  );
                }
              },
              child: Text(
                'Buscar',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showResult(BuildContext context, ClientModel result) {
    ListView.builder(itemBuilder: (context, index) {
      return ListTile(
          leading: avatarClient,
          title: Text(result.nomeRazao),
          subtitle: Text(result.email));
    });

    setState(() {
      _clientModel = [result];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Clientes',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          tooltip: 'Voltar',
          icon: Icon(
            Icons.arrow_back,
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
            child: IconButton(
              color: widget.isDarkMode ? Colors.white : Colors.black,
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.clientForm);
              },
              icon: const Icon(Icons.add),
              tooltip: 'Adicionar cliente',
            ),
          ),
          IconButton(
            color: widget.isDarkMode ? Colors.white : Colors.black,
            icon: const Icon(Icons.search),
            padding: const EdgeInsets.fromLTRB(0, 0, 30.0, 0),
            onPressed: () {
              showSearchDialog(context);
            },
            tooltip: 'Buscar cliente',
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isDarkMode ? Icons.brightness_2 : Icons.brightness_5,
                color: widget.isDarkMode ? Colors.white : Colors.black,
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
            ],
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: _clientModel!.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: avatarClient,
              title: Text(_clientModel![index].nomeRazao),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CPF/CNPJ: ${_cpfCnpjMask.format(_clientModel![index].cpfCnpj)}',
                        ),
                        Text(
                          'RG: ${_clientModel![index].rg}',
                          style: TextStyle(
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          'Data de Nascimento: ${fromDateTimeToDateUsingPattern(DateTime.parse(_clientModel![index].dataNascFund))}',
                        ),
                        Text(
                          'Telefone: ${_phoneMask.format(_clientModel![index].telefone)}',
                        ),
                        Text(
                          'Email: ${_clientModel![index].email}',
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
                        Navigator.of(context).pushNamed(AppRoutes.vehiclePage,
                            arguments: _clientModel![index].idClient);

                        cliente.setId(_clientModel![index].idClient);
                      },
                      icon: Icon(
                        Icons.directions_car,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                      tooltip: 'Veículos',
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ClientRegisterForm(
                            client: _clientModel![index],
                            clientId: _clientModel![index].idClient,
                            isDarkMode: widget.isDarkMode,
                          ),
                        ));
                        cliente.setIndexClient(index);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                      tooltip: 'Editar cliente',
                    ),
                    IconButton(
                      onPressed: () async {
                        await ApiService()
                            .deleteClient(_clientModel![index].idClient);
                        _getData();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                      tooltip: 'Deletar cliente',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
                onPressed: _getData,
                child: Text(
                  'LISTAR TODOS OS CLIENTES',
                  style: TextStyle(
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
