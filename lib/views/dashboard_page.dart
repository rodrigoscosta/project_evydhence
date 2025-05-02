import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:project_evydhence/components/date_parser.dart';
import 'package:project_evydhence/controllers/dashboard_controller.dart';
import 'package:project_evydhence/models/schedule_model.dart';
import 'package:project_evydhence/models/total_clientes_model.dart';
import 'package:project_evydhence/models/total_clientes_por_genero_model.dart';
import 'package:project_evydhence/provider/zoom_provider.dart';

final List<Color> colorPalette = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.orange,
  Colors.purple,
  Colors.yellow,
];

class DashboardPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const DashboardPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final zoomProvider = GetIt.I<ZoomProvider>();
  final DashboardController _dashboard = GetIt.I<DashboardController>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final anoAtual = DateTime.now().year.toString();
    _dashboard.anoSelecionado = anoAtual;
    await Future.wait([
      _dashboard.loadTotalClientes(),
      _dashboard.loadTotalClientesPorGenero(),
      _dashboard.loadTotalVeiculos(),
      _dashboard.loadTotalVistoriasFeitasPorMes(anoAtual),
      _dashboard.loadProximasVistorias(),
    ]);
    if (mounted) setState(() {});
  }

  void _toggleTheme(bool isDarkMode) {
    widget.onThemeChanged(isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final scale = zoomProvider.scaleFactor;
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      appBar: _buildAppBar(scale),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0 * scale),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Total de clientes cadastrados',
                      isDarkMode: widget.isDarkMode,
                      scale: scale,
                      child: _dashboard.loadingTotalClientes
                          ? const Center(child: CircularProgressIndicator())
                          : Center(
                              child: Text(
                                _dashboard.totalClientes.isNotEmpty
                                    ? _dashboard.totalClientes[0].qtdClientes
                                        .toString()
                                    : '0',
                                style: TextStyle(
                                  fontSize: 40 * scale,
                                  fontWeight: FontWeight.w500,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 16.0 * scale),
                  Expanded(
                    child: DashboardCard(
                      title: 'Total de veículos cadastrados',
                      isDarkMode: widget.isDarkMode,
                      scale: scale,
                      child: _dashboard.loadingTotalVeiculos
                          ? const Center(child: CircularProgressIndicator())
                          : Center(
                              child: Text(
                                _dashboard.totalVeiculos.isNotEmpty
                                    ? _dashboard.totalVeiculos[0].qtdVeiculos
                                        .toString()
                                    : '0',
                                style: TextStyle(
                                  fontSize: 40 * scale,
                                  fontWeight: FontWeight.w500,
                                  color: widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 16.0 * scale),
                  Expanded(
                    child: DashboardCard(
                      title: 'Total de clientes por gênero',
                      isDarkMode: widget.isDarkMode,
                      scale: scale,
                      child: _dashboard.loadingTotalClientesPorGenero
                          ? const Center(child: CircularProgressIndicator())
                          : TotalClientesPorGenero(
                              isDarkMode: widget.isDarkMode,
                              scale: scale,
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0 * scale),
              Observer(
                builder: (_) {
                  return DashboardCard(
                    title: 'Total de vistorias realizadas por mês/ano',
                    isDarkMode: widget.isDarkMode,
                    scale: scale,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: DropdownButton<String>(
                              value: _dashboard.anoSelecionado,
                              onChanged: _dashboard
                                      .loadingTotalVistoriasFeitasPorMes
                                  ? null
                                  : (String? newValue) async {
                                      if (newValue != null &&
                                          newValue !=
                                              _dashboard.anoSelecionado) {
                                        _dashboard.setAnoSelecionado(newValue);
                                        await _dashboard
                                            .loadTotalVistoriasFeitasPorMes(
                                                newValue);
                                      }
                                    },
                              items: List.generate(
                                5,
                                (index) {
                                  final ano =
                                      (DateTime.now().year - index).toString();
                                  return DropdownMenuItem(
                                    value: ano,
                                    child: Text(
                                      ano,
                                      style: TextStyle(
                                        fontSize: 16 * scale,
                                        fontWeight: FontWeight.w500,
                                        color: widget.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              style: TextStyle(
                                fontSize: 16 * scale,
                                fontWeight: FontWeight.w500,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              dropdownColor: widget.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _dashboard.loadingTotalVistoriasFeitasPorMes
                              ? const Center(child: CircularProgressIndicator())
                              : SimpleBarChart<
                                  TotalVistoriasRealizadasPorMesModel>(
                                  data: _dashboard.totalVistoriasFeitasPorMes
                                      .toList(),
                                  getValue: (vistoria) =>
                                      vistoria.qtdVistorias.toDouble(),
                                  getLabel: (vistoria) => vistoria.mes,
                                  isDarkMode: widget.isDarkMode,
                                  scale: scale,
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Proximas vistorias agendadas',
                      isDarkMode: widget.isDarkMode,
                      scale: scale,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _dashboard.proximasVistorias.length,
                        itemBuilder: (context, index) {
                          final vistoria = _dashboard.proximasVistorias[index];
                          return ListTile(
                            title: Text(
                              vistoria.cliente,
                              style: TextStyle(
                                fontSize: 16 * scale,
                                fontWeight: FontWeight.w500,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'Data: ${fromDateTimeToDateUsingPattern(DateTime.parse(vistoria.data))}, às ${vistoria.horario} - Local: ${vistoria.local}',
                              style: TextStyle(
                                fontSize: 16 * scale,
                                fontWeight: FontWeight.w500,
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            leading: Icon(
                              Icons.assignment,
                              size: 28.0 * zoomProvider.scaleFactor,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(double scale) {
    return AppBar(
      centerTitle: false,
      title: Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 24.0 * scale,
          fontWeight: FontWeight.w500,
          color: widget.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      leading: IconButton(
        tooltip: 'Voltar',
        iconSize: 28.0 * scale,
        icon: Icon(
          Icons.arrow_back,
          color: widget.isDarkMode ? Colors.white : Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Icon(
          widget.isDarkMode ? Icons.brightness_2 : Icons.brightness_5,
          color: widget.isDarkMode ? Colors.white : Colors.black,
          size: 28.0 * scale,
        ),
        Switch(
          value: widget.isDarkMode,
          onChanged: _toggleTheme,
          activeColor: Colors.blue,
          inactiveTrackColor: Colors.grey,
          inactiveThumbColor: Colors.white,
          activeTrackColor: Colors.blueAccent,
        ),
        IconButton(
          iconSize: 28.0 * scale,
          tooltip: 'Aumentar zoom',
          icon: Icon(Icons.zoom_in,
              color: widget.isDarkMode ? Colors.white : Colors.black),
          onPressed: () => setState(() => zoomProvider.increaseZoom()),
        ),
        IconButton(
          iconSize: 28.0 * scale,
          tooltip: 'Diminuir zoom',
          icon: Icon(Icons.zoom_out,
              color: widget.isDarkMode ? Colors.white : Colors.black),
          onPressed: () => setState(() => zoomProvider.decreaseZoom()),
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDarkMode;
  final double scale;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.child,
    required this.isDarkMode,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8 * scale),
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0 * scale),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16 * scale,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(height: 200 * scale, child: child),
        ],
      ),
    );
  }
}

class SimpleBarChart<T> extends StatelessWidget {
  final List<T> data;
  final double Function(T) getValue;
  final String Function(T) getLabel;
  final bool isDarkMode;
  final double scale;

  const SimpleBarChart({
    super.key,
    required this.data,
    required this.getValue,
    required this.getLabel,
    required this.isDarkMode,
    required this.scale,
  });

  List<BarChartGroupData> _generateBarGroup() {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      T item = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: getValue(item),
            color: colorPalette[index % colorPalette.length],
            width: 25 * scale,
            borderRadius: BorderRadius.circular(4 * scale),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Transform.rotate(
                    angle: -0.3,
                    child: Text(
                      getLabel(data[index]),
                      style: TextStyle(
                        fontSize: 10 * scale,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 12 * scale,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDarkMode ? Colors.white12 : Colors.black12,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _generateBarGroup(),
      ),
    );
  }
}

class TotalClientesPorGenero extends StatelessWidget {
  final bool isDarkMode;
  final double scale;
  const TotalClientesPorGenero(
      {super.key, required this.isDarkMode, required this.scale});

  @override
  Widget build(BuildContext context) {
    final dashboard = GetIt.I<DashboardController>();
    return SimpleBarChart<TotalClientesPorGeneroModel>(
      data: dashboard.totalClientesPorGenero,
      getValue: (cliente) => cliente.qtdClientes.toDouble(),
      getLabel: (cliente) => cliente.sexo,
      isDarkMode: isDarkMode,
      scale: scale,
    );
  }
}

class TotalVistoriasRealizadas extends StatelessWidget {
  final bool isDarkMode;
  final double scale;

  const TotalVistoriasRealizadas({
    super.key,
    required this.isDarkMode,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final dashboard = GetIt.I<DashboardController>();

    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: dashboard.anoSelecionado,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                if (newValue != null && newValue != dashboard.anoSelecionado) {
                  dashboard.anoSelecionado = newValue;
                  dashboard.loadTotalVistoriasFeitasPorMes(newValue);
                }
              },
              items: List.generate(5, (index) {
                final ano = (DateTime.now().year - index).toString();
                return DropdownMenuItem<String>(
                  value: ano,
                  child: Text(ano),
                );
              }),
            ),
            const SizedBox(height: 16),
            SimpleBarChart<TotalVistoriasRealizadasPorMesModel>(
              data: dashboard.totalVistoriasFeitasPorMes,
              getValue: (vistoria) => vistoria.qtdVistorias.toDouble(),
              getLabel: (vistoria) => vistoria.mes,
              isDarkMode: isDarkMode,
              scale: scale,
            ),
          ],
        );
      },
    );
  }
}

class TotalClientes extends StatelessWidget {
  final bool isDarkMode;
  final double scale;
  const TotalClientes(
      {super.key, required this.isDarkMode, required this.scale});

  @override
  Widget build(BuildContext context) {
    final dashboard = GetIt.I<DashboardController>();
    return SimpleBarChart<TotalClientesModel>(
      data: dashboard.totalClientes,
      getValue: (cliente) => cliente.qtdClientes.toDouble(),
      getLabel: (cliente) => cliente.qtdClientes.toString(),
      isDarkMode: isDarkMode,
      scale: scale,
    );
  }
}
