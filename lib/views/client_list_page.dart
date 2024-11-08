import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/cpf_cnpj_mask.dart';
import 'package:project_evydhence/components/date_parser.dart';
import 'package:project_evydhence/components/phone_mask.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/models/client_model.dart';
import 'package:project_evydhence/provider/zoom_provider.dart';
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
              fontSize: 16.0 * zoomProvider.scaleFactor,
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
                fontSize: 16.0 * zoomProvider.scaleFactor,
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
                  fontSize: 16.0 * zoomProvider.scaleFactor,
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
                        fontSize: 16.0 * zoomProvider.scaleFactor,
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
          itemCount: _clientModel?.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(
                vertical: 8.0 * zoomProvider.scaleFactor,
                horizontal: 16.0 * zoomProvider.scaleFactor,
              ),
              color: widget.isDarkMode ? Colors.grey[850] : Colors.white,
              child: Padding(
                padding: EdgeInsets.all(12.0 * zoomProvider.scaleFactor),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24.0 * zoomProvider.scaleFactor,
                    child: Icon(
                      Icons.person,
                      size: 24.0 * zoomProvider.scaleFactor,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  title: Text(
                    _clientModel![index].nomeRazao,
                    style: TextStyle(
                      fontSize: 16.0 * zoomProvider.scaleFactor,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CPF/CNPJ: ${_cpfCnpjMask.format(_clientModel![index].cpfCnpj)}',
                        style: TextStyle(
                          fontSize: 14.0 * zoomProvider.scaleFactor,
                          color: widget.isDarkMode
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                      Text(
                        'RG: ${_clientModel![index].rg}',
                        style: TextStyle(
                          fontSize: 14.0 * zoomProvider.scaleFactor,
                          color: widget.isDarkMode
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                      Text(
                        'Data de nascimento: ${fromDateTimeToDateUsingPattern(DateTime.parse(_clientModel![index].dataNascFund))}',
                        style: TextStyle(
                          fontSize: 14.0 * zoomProvider.scaleFactor,
                          color: widget.isDarkMode
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                      Text(
                        'Telefone: ${_phoneMask.format(_clientModel![index].telefone)}',
                        style: TextStyle(
                          fontSize: 14.0 * zoomProvider.scaleFactor,
                          color: widget.isDarkMode
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                      Text(
                        'Email: ${_clientModel![index].email}',
                        style: TextStyle(
                          fontSize: 14.0 * zoomProvider.scaleFactor,
                          color: widget.isDarkMode
                              ? Colors.white70
                              : Colors.black87,
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      Row(
        children: [
          IconButton(
            color: widget.isDarkMode ? Colors.white : Colors.black,
            iconSize: 28.0 * zoomProvider.scaleFactor,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.clientForm);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar cliente',
          ),
          IconButton(
            color: widget.isDarkMode ? Colors.white : Colors.black,
            iconSize: 28.0 * zoomProvider.scaleFactor,
            icon: const Icon(Icons.search),
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
            iconSize: 28.0 * zoomProvider.scaleFactor,
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
            iconSize: 28.0 * zoomProvider.scaleFactor,
            onPressed: () async {
              await ApiService().deleteClient(_clientModel![index].idClient);
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
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.0 * zoomProvider.scaleFactor),
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
                  fontSize: 16.0 * zoomProvider.scaleFactor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
