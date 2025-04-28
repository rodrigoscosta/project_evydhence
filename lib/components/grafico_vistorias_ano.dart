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
    final anos = ['2022', '2023', '2024', '2025'];
    return anos.map((ano) {
      return DropdownMenuItem<String>(
        value: ano,
        child: Text(ano),
      );
    }).toList();
  }
}

// class GraficoVistoriasAno extends StatelessWidget {
//   final List<TotalVistoriasRealizadasPorMesModel> dados;
//   final String anoSelecionado;
//   final Function(String?) onAnoSelecionado;

//   const GraficoVistoriasAno({
//     super.key,
//     required this.dados,
//     required this.anoSelecionado,
//     required this.onAnoSelecionado,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Adiciona o DropdownButton
//         DropdownButton<String>(
//           value: anoSelecionado,
//           items: _buildAnoDropdown(),
//           onChanged: onAnoSelecionado,
//         ),

//         // Adiciona Expanded para garantir que o gráfico ocupe o espaço correto
//         Expanded(
//           child: SimpleBarChart<TotalVistoriasRealizadasPorMesModel>(
//             data: dados,
//             getValue: (vistoria) => vistoria.qtdVistorias.toDouble(),
//             getLabel: (vistoria) => vistoria.mes,
//             isDarkMode: true, // Ajuste conforme necessário
//             scale: 1.0, // Aplique a escala se necessário
//           ),
//         ),
//       ],
//     );
//   }

//   List<DropdownMenuItem<String>> _buildAnoDropdown() {
//     final anos = [
//       '2022',
//       '2023',
//       '2024',
//       '2025' // Adicione os anos que você deseja como opções
//     ];
//     return anos.map((ano) {
//       return DropdownMenuItem<String>(
//         value: ano,
//         child: Text(ano),
//       );
//     }).toList();
//   }
// }
