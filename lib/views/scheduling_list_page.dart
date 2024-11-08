import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/date_parser.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/controllers/schedule_controller.dart';
import 'package:project_evydhence/controllers/vehicle_controller.dart';
import 'package:project_evydhence/models/schedule_model.dart';
import 'package:project_evydhence/provider/zoom_provider.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:project_evydhence/services/api_service.dart';
import 'package:project_evydhence/views/forms/scheduling_register_form.dart';

class SchedulingListPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SchedulingListPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<SchedulingListPage> createState() => _SchedulingListPagePageState();
}

class _SchedulingListPagePageState extends State<SchedulingListPage> {
  late List<ScheduleModel>? _scheduleModel = [];
  final cliente = GetIt.I<ClientController>();
  final veiculo = GetIt.I<VehicleController>();
  final agendamento = GetIt.I<ScheduleController>();
  bool _isInitializing = true;
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
    _getData();
    super.initState();
  }

  void _getData() async {
    _scheduleModel =
        (await ApiService().getSchedulesByVehicle(veiculo.idVeiculo))!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void _toggleTheme(bool isDarkMode) {
    widget.onThemeChanged(isDarkMode);
  }

  List<Widget> _buildAppBarActions() {
    return [
      Container(
        margin: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
        child: IconButton(
          iconSize: 28.0 * zoomProvider.scaleFactor,
          color: widget.isDarkMode ? Colors.white : Colors.black,
          onPressed: () {
            Navigator.of(context).pushNamed(
              AppRoutes.scheduleForm,
            );
          },
          icon: const Icon(Icons.add),
          tooltip: 'Adicionar agendamento',
        ),
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
    ];
  }

  Widget _buildCardActions(int index) {
    return SizedBox(
      width: 100 * zoomProvider.scaleFactor,
      child: Row(
        children: [
          IconButton(
            iconSize: 28.0 * zoomProvider.scaleFactor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SchedulingRegisterForm(
                  schedule: _scheduleModel![index],
                  scheduleId: _scheduleModel![index].idSchedule,
                  isDarkMode: widget.isDarkMode,
                  onThemeChanged: widget.onThemeChanged,
                ),
              ));
              agendamento.setIndexSchedule(index);
            },
            icon: Icon(
              Icons.edit,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            tooltip: 'Editar agendamento',
          ),
          IconButton(
            iconSize: 28.0 * zoomProvider.scaleFactor,
            onPressed: () async {
              await ApiService()
                  .deleteSchedule(_scheduleModel![index].idSchedule);
              _getData();
            },
            icon: Icon(
              Icons.delete,
              color: widget.isDarkMode ? Colors.white : Colors.black,
            ),
            tooltip: 'Deletar agendamento',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatarSchedule = CircleAvatar(
        radius: 24.0 * zoomProvider.scaleFactor,
        child: const Icon(Icons.wysiwyg_sharp));
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Agendamentos',
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
          itemCount: _scheduleModel!.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(
                vertical: 8.0 * zoomProvider.scaleFactor,
                horizontal: 16.0 * zoomProvider.scaleFactor,
              ),
              color: widget.isDarkMode ? Colors.grey[800] : Colors.white,
              child: Padding(
                padding: EdgeInsets.all(12.0 * zoomProvider.scaleFactor),
                child: ListTile(
                  leading: avatarSchedule,
                  // title: Text(
                  //   fromDateTimeToDateUsingPattern(
                  //       DateTime.parse(_scheduleModel![index].dtaAgendamento)),
                  //   style: TextStyle(
                  //     fontSize: 16.0 * zoomProvider.scaleFactor,
                  //     color: widget.isDarkMode ? Colors.white : Colors.black,
                  //   ),
                  // ),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data da vistoria: ${fromDateTimeToDateUsingPattern(DateTime.parse(_scheduleModel![index].dtaAgendamento))}',
                              style: TextStyle(
                                fontSize: 14.0 * zoomProvider.scaleFactor,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              'Hora da vistoria: ${_scheduleModel![index].horaAgendamento}',
                              style: TextStyle(
                                fontSize: 14.0 * zoomProvider.scaleFactor,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              'Local da vistoria: ${_scheduleModel![index].localAgendamento}',
                              style: TextStyle(
                                fontSize: 14.0 * zoomProvider.scaleFactor,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              'Observação: ${_scheduleModel![index].observacao}',
                              style: TextStyle(
                                fontSize: 14.0 * zoomProvider.scaleFactor,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
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
    );
  }
}
