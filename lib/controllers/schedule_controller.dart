import 'package:mobx/mobx.dart';
import 'package:project_evydhence/components/date_parser.dart';
import 'package:project_evydhence/models/schedule_model.dart';

class ScheduleController with Store {
  @observable
  List<ScheduleModel> list = ObservableList.of(<ScheduleModel>[]);

  @observable
  ScheduleModel? scheduleAtual;

  @action
  void setScheduleAtual(ScheduleModel value) => scheduleAtual = value;

  @action
  void clearForm() {
    setDtaAgendamento('');
    setObservacao('');
  }

  @computed
  bool get isFormComplete =>
      dtaAgendamento.isNotEmpty &&
      horaAgendamento.isNotEmpty &&
      horaAgendamento.isNotEmpty &&
      localAgendamento.isNotEmpty &&
      observacao.isNotEmpty;

  ScheduleModel createScheduleFromForm() {
    return ScheduleModel(
        idVeiculo: idVeiculo,
        idSchedule: idSchedule,
        dtaAgendamento: dtaAgendamento,
        horaAgendamento: horaAgendamento,
        localAgendamento: localAgendamento,
        observacao: observacao);
  }

  @observable
  int indexSchedule = 0;

  @action
  void setIndexSchedule(int value) => indexSchedule = value;

  @observable
  int idSchedule = 0;

  @action
  void setIdSchedule(int value) => idSchedule = value;

  @observable
  int idVeiculo = 0;

  @action
  void setIdVeiculo(int value) => idVeiculo = value;

  @observable
  String dtaAgendamento = '';

  @action
  void setDtaAgendamento(String value) => dtaAgendamento = value;

  @computed
  DateTime? get dataVistoriaAsDateTime => dtaAgendamento.isEmpty
      ? null
      : fromDateUsingPatternToDateTime(dtaAgendamento);

  @observable
  String horaAgendamento = '';

  @action
  void setHoraAgendamento(String value) => horaAgendamento = value;

  @observable
  String localAgendamento = '';

  @action
  void setLocalAgendamento(String value) => localAgendamento = value;

  @observable
  String observacao = '';

  @action
  void setObservacao(String value) => observacao = value;

  @observable
  String situacao = '';

  @action
  void setSituacao(String value) => situacao = value;

  @observable
  bool? situacaoVeiculo;

  @action
  void setSituacaoVeiculo(bool? value) => situacaoVeiculo = value;
}
