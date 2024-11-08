import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/date_mask.dart';
import 'package:project_evydhence/components/date_parser.dart';
import 'package:project_evydhence/components/text_input_form_field.dart';
import 'package:project_evydhence/components/time_input_formatter.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/controllers/schedule_controller.dart';
import 'package:project_evydhence/controllers/vehicle_controller.dart';
import 'package:project_evydhence/models/schedule_model.dart';
import 'package:project_evydhence/provider/zoom_provider.dart';
import 'package:project_evydhence/services/api_service.dart';
import 'package:project_evydhence/views/scheduling_list_page.dart';

class SchedulingRegisterForm extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final ScheduleModel? schedule;
  final int? scheduleId;

  const SchedulingRegisterForm(
      {Key? key,
      required this.isDarkMode,
      required this.onThemeChanged,
      this.schedule,
      this.scheduleId})
      : super(key: key);

  @override
  State<SchedulingRegisterForm> createState() => _SchedulingRegisterFormState();
}

class _SchedulingRegisterFormState extends State<SchedulingRegisterForm> {
  bool _isInitializing = true;
  final veiculo = GetIt.I<VehicleController>();
  final cliente = GetIt.I<ClientController>();
  final agendamento = GetIt.I<ScheduleController>();
  final _formKey = GlobalKey<FormState>();
  final _dtaAgendamentoController = TextEditingController(text: '');
  final _horasController = TextEditingController(text: '');
  final _localAgendamentoController = TextEditingController(text: '');
  final _observacaoController = TextEditingController(text: '');
  final zoomProvider = GetIt.I<ZoomProvider>();

  @override
  void didChangeDependencies() {
    if (_isInitializing) {
      _initialization();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dtaAgendamentoController.dispose();
    _horasController.dispose();
    _observacaoController.dispose();
    _localAgendamentoController.dispose();
    super.dispose();
  }

  void _initialization() {
    _isInitializing = false;

    if (widget.schedule != null) {
      final schedule = widget.schedule!;

      final formattedDate = fromDateTimeToDateUsingPattern(
          DateTime.parse(schedule.dtaAgendamento));
      _dtaAgendamentoController.text = formattedDate;
      agendamento.setDtaAgendamento(formattedDate);

      _horasController.text = schedule.horaAgendamento;
      agendamento.setHoraAgendamento(schedule.horaAgendamento);

      _localAgendamentoController.text = schedule.localAgendamento;
      agendamento.setLocalAgendamento(schedule.localAgendamento);

      _observacaoController.text = schedule.observacao;
      agendamento.setObservacao(schedule.observacao);
    }
  }

  void _handleDataDeFundacaoChanged(
    String value, {
    bool changeControllerText = false,
  }) {
    agendamento.setDtaAgendamento(value);
    if (changeControllerText) {
      _dtaAgendamentoController.text =
          agendamento.dtaAgendamento.split(' ').first;
    }
  }

  void _cancel() {
    veiculo.clearForm();
    Navigator.pop(context);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.scheduleId != null) {
      // Se o ID do cliente estiver definido, chama o método de atualização
      await updateSchedule();
    } else {
      // Caso contrário, chama o método de criação de cliente
      await createSchedule();
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
            'Agendamento cadastrado/editado com sucesso!',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SchedulingListPage(
                        isDarkMode: widget.isDarkMode,
                        onThemeChanged: widget.onThemeChanged),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
    agendamento.clearForm();
  }

  Future<void> createSchedule() async {
    await ApiService().postSchedule(
        veiculo.idVeiculo,
        agendamento.dtaAgendamento,
        agendamento.horaAgendamento,
        agendamento.localAgendamento,
        agendamento.observacao);
  }

  Future<void> updateSchedule() async {
    await ApiService().putSchedule(
        widget.scheduleId!,
        veiculo.idVeiculo,
        agendamento.dtaAgendamento,
        agendamento.horaAgendamento,
        agendamento.localAgendamento,
        agendamento.observacao);
  }

  Radio<bool?> buildRadio({
    required bool value,
    required bool? groupValue,
    required void Function(bool?)? onChanged,
  }) =>
      Radio<bool?>(
        activeColor: widget.isDarkMode ? Colors.white : Colors.black,
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        toggleable: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
      );

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
            'Adicionar agendamento',
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
                                labelText: 'Data da vistoria',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                controller: _dtaAgendamentoController,
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
                                        initialDate: agendamento
                                                .dataVistoriaAsDateTime ??
                                            DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                        helpText:
                                            'Selecione a data da vistoria',
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
                              TextInputFormField(
                                labelText: 'Horas (HH:MM)',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller:
                                    _horasController,
                                keyboardType: TextInputType
                                    .number,
                                onChanged: agendamento.setHoraAgendamento ,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(
                                      r'[0-9:]')),
                                  LengthLimitingTextInputFormatter(
                                      5),
                                  TimeInputFormatter(), // Formata automaticamente o campo para HH:MM
                                ],
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
                                labelText: 'Local do agendamento',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: true,
                                controller: _localAgendamentoController,
                                keyboardType: TextInputType.text,
                                onChanged: agendamento.setLocalAgendamento,
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
                                labelText: 'Observação',
                                style: TextStyle(
                                  fontSize: 16.0 * zoomProvider.scaleFactor,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                required: false,
                                controller: _observacaoController,
                                keyboardType: TextInputType.text,
                                onChanged: agendamento.setObservacao,
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
            padding: EdgeInsets.all(24.0 * zoomProvider.scaleFactor),
            child: Observer(
              builder: (context) => Column(
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
      ),
    );
  }
}
