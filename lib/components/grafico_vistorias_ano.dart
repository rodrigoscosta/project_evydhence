import 'package:flutter/material.dart';
import 'package:project_evydhence/models/schedule_model.dart';
import 'package:project_evydhence/views/dashboard_page.dart';

class GraficoVistoriasAno extends StatefulWidget {
  final List<TotalVistoriasRealizadasPorMesModel> dados;
  final String anoSelecionado;
  final Function(String?) onAnoSelecionado;

  const GraficoVistoriasAno({
    super.key,
    required this.dados,
    required this.anoSelecionado,
    required this.onAnoSelecionado,
  });

  @override
  State<GraficoVistoriasAno> createState() => _GraficoVistoriasAnoState();
}

class _GraficoVistoriasAnoState extends State<GraficoVistoriasAno> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: widget.anoSelecionado,
          items: _buildAnoDropdown(),
          onChanged: (String? newValue) {
            if (newValue != null && newValue != widget.anoSelecionado) {
              widget.onAnoSelecionado(newValue);
            }
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: SimpleBarChart<TotalVistoriasRealizadasPorMesModel>(
            data: widget.dados,
            getValue: (vistoria) => vistoria.qtdVistorias.toDouble(),
            getLabel: (vistoria) => vistoria.mes,
            isDarkMode: true,
            scale: 1.0,
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildAnoDropdown() {
    final int anoAtual = DateTime.now().year;
    final List<String> anos = [
      for (int ano = 2023; ano <= anoAtual; ano++) ano.toString()
    ];

    return anos.map((ano) {
      return DropdownMenuItem<String>(
        value: ano,
        child: Text(ano),
      );
    }).toList();
  }
}
