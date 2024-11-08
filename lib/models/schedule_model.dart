import 'dart:convert';

List<ScheduleModel> scheduleModelFromJson(String str) => List<ScheduleModel>.from(
    json.decode(str).map((x) => ScheduleModel.fromJson(x)));

String scheduleModelToJson(List<ScheduleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ScheduleModel {
  int idSchedule;
  int idVeiculo;
  String dtaAgendamento;
  String horaAgendamento;
  String localAgendamento;
  String observacao;

  ScheduleModel({
    required this.idSchedule,
    required this.idVeiculo,
    required this.dtaAgendamento,
    required this.horaAgendamento,
    required this.localAgendamento,
    required this.observacao,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
      idSchedule: json['idSchedule'],
      idVeiculo: json['idVeiculo'],
      dtaAgendamento: json['dtaAgendamento'],
      horaAgendamento: json['horaAgendamento'],
      localAgendamento: json['localAgendamento'],
      observacao: json['observacao']);

  Map<String, dynamic> toJson() => {
        "idSchedule": idSchedule,
        "idVeiculo": idVeiculo,
        "dtaAgendamento": dtaAgendamento,
        "horaAgendamento": horaAgendamento,
        "localAgendamento": localAgendamento,
        "observacao": observacao,
      };
}
