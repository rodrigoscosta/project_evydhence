import 'package:mobx/mobx.dart';
import 'package:project_evydhence/models/client_model.dart';
import 'package:project_evydhence/models/vehicle_model.dart';

class VehicleController with Store {

  @observable
  List<VehicleModel> list = ObservableList.of(<VehicleModel>[]);

  @observable
  ClientModel? clienteAtual;

  @action
  void setClienteAtual(ClientModel value) =>
      clienteAtual = value;

  // @action
  // void edit(VehicleModel representanteLegal, int index) {
  //   clienteAtual!.listaVeiculos[index] = representanteLegal;
  // }

  // @action
  // void remove(int index) {
  //   clienteAtual!.listaVeiculos.removeAt(index);
  // }

  @action
  void clearForm() {
    setPlaca('');
    setMarca('');
    setModelo('');
    setTipoVeiculo('');
    setAnoFabricacao('');
    setAnoModelo('');
  }

  @computed
  bool get isFormComplete =>
      placa.isNotEmpty &&
      marca.isNotEmpty &&
      modelo.isNotEmpty &&
      tipoVeiculo.isNotEmpty &&
      anoFabricacao.isNotEmpty &&
      anoModelo.isNotEmpty;

  VehicleModel createClientFromForm() {
    return VehicleModel(
        idCliente: idCliente,
        idVeiculo: idVeiculo,
        placa: placa,
        marca: marca,
        modelo: modelo,
        tipoVeiculo: tipoVeiculo,
        anoFabricacao: anoFabricacao,
        anoModelo: anoModelo);
  }

  @observable
  int indexVehicle = 0;

  @action
  void setIndexVehicle(int value) => indexVehicle = value;

  @observable
  int idCliente = 0;

  @action
  void setId(int value) => idCliente = value;

  @observable
  int idVeiculo = 0;

  @action
  void setIdVeiculo(int value) => idVeiculo = value;

  @observable
  String placa = '';

  @action
  void setPlaca(String value) => placa = value;

  @observable
  String marca = '';

  @action
  void setMarca(String value) => marca = value;

  @observable
  String modelo = '';

  @action
  void setModelo(String value) => modelo = value;

  @observable
  String tipoVeiculo = '';

  @action
  void setTipoVeiculo(String value) => tipoVeiculo = value;

  @observable
  String anoFabricacao = '';

  @action
  void setAnoFabricacao(String value) => anoFabricacao = value;

  @observable
  String anoModelo = '';

  @action
  void setAnoModelo(String value) => anoModelo = value;
}
