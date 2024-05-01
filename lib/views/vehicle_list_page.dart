import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/custom_expansion_tile.dart';
import 'package:project_evydhence/components/grid.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/controllers/vehicle_controller.dart';
import 'package:project_evydhence/views/forms/vehicle_register_form.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({super.key});

  @override
  State<VehicleListPage> createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  //final _contractingStore = GetIt.I<AuthenticatedContractingStore>();
  final _controllerVehicle = GetIt.I<VehicleController>();
  final _controllerClient = GetIt.I<ClientController>();

  void editVeiculo(int index) {
    _controllerVehicle.setIdVeiculo(index);
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (BuildContext context) => const VehicleRegisterForm(),
    ).whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          leading: const SizedBox.shrink(),
          leadingWidth: 0,
          title: const Text(
            'Contratação',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 26,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(26.0).copyWith(top: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                  child: const Text(
                    'Veículos:',
                    style: TextStyle(
                      color: Color.fromRGBO(72, 72, 83, 1),
                    ),
                  ),
                ),
                Button(
                  flavor: ButtonFlavor.dotted,
                  onPressed:
                      _controllerVehicle.clienteAtual!.listaVeiculos.isEmpty
                          ? () {
                              _controllerVehicle.setIdVeiculo(_controllerVehicle
                                      .clienteAtual!.listaVeiculos.length +
                                  1);
                              showModalBottomSheet(
                                isScrollControlled: true,
                                isDismissible: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    const VehicleRegisterForm(),
                              );
                            }
                          : null,
                  child: const Text('+ adicionar representante'),
                ),
                const SizedBox(height: 24.0),
                Observer(
                  builder: (context) => ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                    itemCount:
                        _controllerVehicle.clienteAtual!.listaVeiculos.length,
                    itemBuilder: (context, index) {
                      int aux = _controllerClient.indexClient;
                      final veiculo =
                          _controllerClient.list[aux].listaVeiculos[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(
                            color: Color(0xFFE9E9EF),
                          ),
                        ),
                        child: CustomExpansionTile(
                          trailingActions: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                  tooltip: 'Editar veículo',
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    editVeiculo(index);
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                  tooltip: 'Excluir veículo',
                                  icon:
                                      const Icon(Icons.delete_outline_rounded),
                                  onPressed: () {
                                    _controllerVehicle
                                        .clienteAtual!.listaVeiculos
                                        .remove(_controllerVehicle.clienteAtual!
                                            .listaVeiculos[index]);
                                    setState(() {});
                                  }),
                            ),
                          ],
                          tilePadding:
                              const EdgeInsets.all(16).copyWith(top: 4),
                          childrenPadding:
                              const EdgeInsets.all(16).copyWith(top: 0),
                          title: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               GridItem(
                                label: 'Placa do veículo',
                                value: "AAA-3343",
                                //value: veiculo.placa,
                              ),
                              CustomGrid(
                                columns: 2,
                                spacing: 8.0,
                                content: [
                                  GridItem(
                                    label: 'Marca do veículo',
                                    value: 'qualqur coisa',
                                    //value: veiculo.marca,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          children: [
                             const GridItem(
                              label: 'Modelo do veículo',
                              value: "qualquer coisa",
                              //value: veiculo.modelo,
                            ),
                             const CustomGrid(
                              columns: 2,
                              spacing: 8.0,
                              content: [
                                GridItem(
                                  label: 'Tipo do veículo',
                                  value: 'qualquer coisa',
                                  //value: veiculo.tipoVeiculo,
                                ),
                                GridItem(
                                  label: 'Ano de fabricação',
                                  value: '2010',
                                  //value: veiculo.anoFabricacao,
                                ),
                              ],
                            ),
                            GridItem(
                              label: 'Ano do modelo',
                              value: veiculo.anoModelo,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 24.0)
              .copyWith(top: 0.0),
          child: Button(
            flavor: ButtonFlavor.elevated,
            child: const Text('CONTINUAR'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleListPage(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
