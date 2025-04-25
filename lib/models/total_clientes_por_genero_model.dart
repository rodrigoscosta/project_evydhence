class TotalClientesPorGeneroModel {
  final int qtdClientes;
  final String sexo;

  TotalClientesPorGeneroModel({required this.qtdClientes, required this.sexo});

  factory TotalClientesPorGeneroModel.fromJson(Map<String, dynamic> json) {
    return TotalClientesPorGeneroModel(
      qtdClientes: json['qtdClientes'] ?? 0,
      sexo: json['sexo'] ?? '',
    );
  }
}
