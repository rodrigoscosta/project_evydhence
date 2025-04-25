class TotalClientesModel {
  final int qtdClientes;

  TotalClientesModel({required this.qtdClientes});

  factory TotalClientesModel.fromJson(Map<String, dynamic> json) {
    return TotalClientesModel(
      qtdClientes: json['qtdClientes'] ?? 0,
    );
  }
}


