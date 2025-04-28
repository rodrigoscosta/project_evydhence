// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DashboardController on _DashboardControllerBase, Store {
  late final _$totalClientesAtom =
      Atom(name: '_DashboardControllerBase.totalClientes', context: context);

  @override
  List<TotalClientesModel> get totalClientes {
    _$totalClientesAtom.reportRead();
    return super.totalClientes;
  }

  @override
  set totalClientes(List<TotalClientesModel> value) {
    _$totalClientesAtom.reportWrite(value, super.totalClientes, () {
      super.totalClientes = value;
    });
  }

  late final _$totalClientesPorGeneroAtom = Atom(
      name: '_DashboardControllerBase.totalClientesPorGenero',
      context: context);

  @override
  List<TotalClientesPorGeneroModel> get totalClientesPorGenero {
    _$totalClientesPorGeneroAtom.reportRead();
    return super.totalClientesPorGenero;
  }

  @override
  set totalClientesPorGenero(List<TotalClientesPorGeneroModel> value) {
    _$totalClientesPorGeneroAtom
        .reportWrite(value, super.totalClientesPorGenero, () {
      super.totalClientesPorGenero = value;
    });
  }

  late final _$totalVistoriasFeitasPorMesAtom = Atom(
      name: '_DashboardControllerBase.totalVistoriasFeitasPorMes',
      context: context);

  @override
  ObservableList<TotalVistoriasRealizadasPorMesModel>
      get totalVistoriasFeitasPorMes {
    _$totalVistoriasFeitasPorMesAtom.reportRead();
    return super.totalVistoriasFeitasPorMes;
  }

  @override
  set totalVistoriasFeitasPorMes(
      ObservableList<TotalVistoriasRealizadasPorMesModel> value) {
    _$totalVistoriasFeitasPorMesAtom
        .reportWrite(value, super.totalVistoriasFeitasPorMes, () {
      super.totalVistoriasFeitasPorMes = value;
    });
  }

  late final _$totalVeiculosAtom =
      Atom(name: '_DashboardControllerBase.totalVeiculos', context: context);

  @override
  List<TotalVehiclesModel> get totalVeiculos {
    _$totalVeiculosAtom.reportRead();
    return super.totalVeiculos;
  }

  @override
  set totalVeiculos(List<TotalVehiclesModel> value) {
    _$totalVeiculosAtom.reportWrite(value, super.totalVeiculos, () {
      super.totalVeiculos = value;
    });
  }

  late final _$anoSelecionadoAtom =
      Atom(name: '_DashboardControllerBase.anoSelecionado', context: context);

  @override
  String get anoSelecionado {
    _$anoSelecionadoAtom.reportRead();
    return super.anoSelecionado;
  }

  @override
  set anoSelecionado(String value) {
    _$anoSelecionadoAtom.reportWrite(value, super.anoSelecionado, () {
      super.anoSelecionado = value;
    });
  }

  late final _$loadingTotalClientesAtom = Atom(
      name: '_DashboardControllerBase.loadingTotalClientes', context: context);

  @override
  bool get loadingTotalClientes {
    _$loadingTotalClientesAtom.reportRead();
    return super.loadingTotalClientes;
  }

  @override
  set loadingTotalClientes(bool value) {
    _$loadingTotalClientesAtom.reportWrite(value, super.loadingTotalClientes,
        () {
      super.loadingTotalClientes = value;
    });
  }

  late final _$loadingTotalClientesPorGeneroAtom = Atom(
      name: '_DashboardControllerBase.loadingTotalClientesPorGenero',
      context: context);

  @override
  bool get loadingTotalClientesPorGenero {
    _$loadingTotalClientesPorGeneroAtom.reportRead();
    return super.loadingTotalClientesPorGenero;
  }

  @override
  set loadingTotalClientesPorGenero(bool value) {
    _$loadingTotalClientesPorGeneroAtom
        .reportWrite(value, super.loadingTotalClientesPorGenero, () {
      super.loadingTotalClientesPorGenero = value;
    });
  }

  late final _$loadingTotalVistoriasFeitasPorMesAtom = Atom(
      name: '_DashboardControllerBase.loadingTotalVistoriasFeitasPorMes',
      context: context);

  @override
  bool get loadingTotalVistoriasFeitasPorMes {
    _$loadingTotalVistoriasFeitasPorMesAtom.reportRead();
    return super.loadingTotalVistoriasFeitasPorMes;
  }

  @override
  set loadingTotalVistoriasFeitasPorMes(bool value) {
    _$loadingTotalVistoriasFeitasPorMesAtom
        .reportWrite(value, super.loadingTotalVistoriasFeitasPorMes, () {
      super.loadingTotalVistoriasFeitasPorMes = value;
    });
  }

  late final _$loadingTotalVeiculosAtom = Atom(
      name: '_DashboardControllerBase.loadingTotalVeiculos', context: context);

  @override
  bool get loadingTotalVeiculos {
    _$loadingTotalVeiculosAtom.reportRead();
    return super.loadingTotalVeiculos;
  }

  @override
  set loadingTotalVeiculos(bool value) {
    _$loadingTotalVeiculosAtom.reportWrite(value, super.loadingTotalVeiculos,
        () {
      super.loadingTotalVeiculos = value;
    });
  }

  late final _$loadDashboardErrorAtom = Atom(
      name: '_DashboardControllerBase.loadDashboardError', context: context);

  @override
  String? get loadDashboardError {
    _$loadDashboardErrorAtom.reportRead();
    return super.loadDashboardError;
  }

  @override
  set loadDashboardError(String? value) {
    _$loadDashboardErrorAtom.reportWrite(value, super.loadDashboardError, () {
      super.loadDashboardError = value;
    });
  }

  late final _$loadTotalClientesAsyncAction = AsyncAction(
      '_DashboardControllerBase.loadTotalClientes',
      context: context);

  @override
  Future<void> loadTotalClientes() {
    return _$loadTotalClientesAsyncAction.run(() => super.loadTotalClientes());
  }

  late final _$loadTotalClientesPorGeneroAsyncAction = AsyncAction(
      '_DashboardControllerBase.loadTotalClientesPorGenero',
      context: context);

  @override
  Future<void> loadTotalClientesPorGenero() {
    return _$loadTotalClientesPorGeneroAsyncAction
        .run(() => super.loadTotalClientesPorGenero());
  }

  late final _$loadTotalVistoriasFeitasPorMesAsyncAction = AsyncAction(
      '_DashboardControllerBase.loadTotalVistoriasFeitasPorMes',
      context: context);

  @override
  Future<void> loadTotalVistoriasFeitasPorMes(String ano) {
    return _$loadTotalVistoriasFeitasPorMesAsyncAction
        .run(() => super.loadTotalVistoriasFeitasPorMes(ano));
  }

  late final _$loadTotalVeiculosAsyncAction = AsyncAction(
      '_DashboardControllerBase.loadTotalVeiculos',
      context: context);

  @override
  Future<void> loadTotalVeiculos() {
    return _$loadTotalVeiculosAsyncAction.run(() => super.loadTotalVeiculos());
  }

  late final _$_DashboardControllerBaseActionController =
      ActionController(name: '_DashboardControllerBase', context: context);

  @override
  void setTotalClientes(List<TotalClientesModel> value) {
    final _$actionInfo = _$_DashboardControllerBaseActionController.startAction(
        name: '_DashboardControllerBase.setTotalClientes');
    try {
      return super.setTotalClientes(value);
    } finally {
      _$_DashboardControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTotalClientesPorGenero(List<TotalClientesPorGeneroModel> value) {
    final _$actionInfo = _$_DashboardControllerBaseActionController.startAction(
        name: '_DashboardControllerBase.setTotalClientesPorGenero');
    try {
      return super.setTotalClientesPorGenero(value);
    } finally {
      _$_DashboardControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTotalVistoriasFeitasPorMes(
      List<TotalVistoriasRealizadasPorMesModel> value) {
    final _$actionInfo = _$_DashboardControllerBaseActionController.startAction(
        name: '_DashboardControllerBase.setTotalVistoriasFeitasPorMes');
    try {
      return super.setTotalVistoriasFeitasPorMes(value);
    } finally {
      _$_DashboardControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTotalVeiculos(List<TotalVehiclesModel> value) {
    final _$actionInfo = _$_DashboardControllerBaseActionController.startAction(
        name: '_DashboardControllerBase.setTotalVeiculos');
    try {
      return super.setTotalVeiculos(value);
    } finally {
      _$_DashboardControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAnoSelecionado(String ano) {
    final _$actionInfo = _$_DashboardControllerBaseActionController.startAction(
        name: '_DashboardControllerBase.setAnoSelecionado');
    try {
      return super.setAnoSelecionado(ano);
    } finally {
      _$_DashboardControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
totalClientes: ${totalClientes},
totalClientesPorGenero: ${totalClientesPorGenero},
totalVistoriasFeitasPorMes: ${totalVistoriasFeitasPorMes},
totalVeiculos: ${totalVeiculos},
anoSelecionado: ${anoSelecionado},
loadingTotalClientes: ${loadingTotalClientes},
loadingTotalClientesPorGenero: ${loadingTotalClientesPorGenero},
loadingTotalVistoriasFeitasPorMes: ${loadingTotalVistoriasFeitasPorMes},
loadingTotalVeiculos: ${loadingTotalVeiculos},
loadDashboardError: ${loadDashboardError}
    ''';
  }
}
