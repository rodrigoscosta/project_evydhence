import 'package:mobx/mobx.dart';
import 'package:project_evydhence/components/date_parser.dart';
import 'package:project_evydhence/models/client_model.dart';
import 'package:project_evydhence/services/api_service.dart';

class ClientController with Store {
  clientControllerBase({
    ApiService? apiService,
  }) {
    _apiService = apiService ?? ApiService();
  }

  late final ApiService _apiService;

  @observable
  List<ClientModel>? list = ObservableList.of(<ClientModel>[]);

  @action
  void setClients(List<ClientModel>? value) => list = ObservableList.of(value!);

  @observable
  ClientModel? client;

  @action
  void setClient(ClientModel value) => client = value;

  @computed
  int get total => list!.length;

  @action
  void clearForm() {
    setCpfCnpj('');
    setRg('');
    setNomeRazao('');
    setTelefone('');
    setEmail('');
    setConfirmarEmail('');
    setDataNascFund('');
    setSexo('');
  }

  @computed
  bool get isFormComplete =>
      cpfCnpj.isNotEmpty &&
      nomeRazao.isNotEmpty &&
      telefone.isNotEmpty &&
      email.isNotEmpty &&
      confirmarEmail.isNotEmpty &&
      confirmarEmailEqualsToEmail &&
      dataNascFund.isNotEmpty &&
      sexo!.isNotEmpty &&
      cep.isNotEmpty &&
      logradouro.isNotEmpty &&
      numeroResidencia.isNotEmpty &&
      bairro.isNotEmpty &&
      cidade.isNotEmpty &&
      estado.isNotEmpty;

  ClientModel createClientFromForm() {
    return ClientModel(
        idClient: idClient,
        cpfCnpj: cpfCnpj,
        rg: rg,
        nomeRazao: nomeRazao,
        telefone: telefone,
        email: email,
        confirmarEmail: confirmarEmail,
        dataNascFund: dataNascFund,
        sexo: sexo!,
        cep: cep,
        logradouro: logradouro,
        numeroResidencia: numeroResidencia,
        complemento: complemento,
        bairro: bairro,
        cidade: cidade,
        estado: estado,
        uf: uf);
  }

  @observable
  int indexClient = 0;

  @action
  void setIndexClient(int value) => indexClient = value;

  @observable
  int idClient = 0;

  @action
  void setId(int value) => idClient = value;

  @observable
  String cpfCnpj = '';

  @action
  void setCpfCnpj(String value) => cpfCnpj = value;

  @observable
  String rg = '';

  @action
  void setRg(String value) => rg = value;

  @observable
  String nomeRazao = '';

  @action
  void setNomeRazao(String value) => nomeRazao = value;

  @observable
  String telefone = '';

  @action
  void setTelefone(String value) => telefone = value;

  @observable
  String email = '';

  @action
  void setEmail(String value) => email = value;

  @observable
  String confirmarEmail = '';

  @action
  void setConfirmarEmail(String value) => confirmarEmail = value;

  @computed
  bool get confirmarEmailEqualsToEmail => confirmarEmail == email;

  @observable
  String dataNascFund = '';

  @action
  void setDataNascFund(String value) => dataNascFund = value;

  @computed
  DateTime? get dataFundacaoAsDateTime => dataNascFund.isEmpty
      ? null
      : fromDateUsingPatternToDateTime(dataNascFund);

  @observable
  String? sexo = '';

  @action
  void setSexo(String? value) => sexo = value;

  @observable
  String cep = '';

  @action
  void setCep(String value) => cep = value;

  @observable
  String logradouro = '';

  @action
  void setLogradouro(String value) => logradouro = value;

  @observable
  String numeroResidencia = '';

  @action
  void setNumeroResidencia(String value) => numeroResidencia = value;

  @observable
  String complemento = '';

  @action
  void setComplemento(String value) => complemento = value;

  @observable
  String bairro = '';

  @action
  void setBairro(String value) => bairro = value;

  @observable
  String cidade = '';

  @action
  void setCidade(String value) => cidade = value;

  @observable
  String uf = '';

  @action
  void setUf(String value) => uf = value;

  @observable
  String estado = '';

  @action
  void setEstado(String value) => estado = value;

  @action
  Future<void> loadClients() async {
    try {
      final clients = await _apiService.getClients();
      setClients(clients!);
    } catch (_) {
      setClients([]);
    }
  }
}
