import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:project_evydhence/models/schedule_model.dart';
import 'package:project_evydhence/models/total_clientes_model.dart';
import 'package:project_evydhence/models/total_clientes_por_genero_model.dart';
import 'package:project_evydhence/models/vehicle_model.dart';
import 'package:project_evydhence/services/api_service.dart';

part 'dashboard_controller.g.dart';

class DashboardController = _DashboardControllerBase with _$DashboardController;

abstract class _DashboardControllerBase with Store {
  final ApiService _dashBoardService = ApiService();

  @observable
  List<TotalClientesModel> totalClientes = ObservableList();

  @action
  void setTotalClientes(List<TotalClientesModel> value) =>
      totalClientes = ObservableList.of(value);

  @observable
  List<TotalClientesPorGeneroModel> totalClientesPorGenero = ObservableList();

  @action
  void setTotalClientesPorGenero(List<TotalClientesPorGeneroModel> value) =>
      totalClientesPorGenero = ObservableList.of(value);

  @observable
  ObservableList<TotalVistoriasRealizadasPorMesModel>
      totalVistoriasFeitasPorMes =
      ObservableList<TotalVistoriasRealizadasPorMesModel>();

  @action
  void setTotalVistoriasFeitasPorMes(
          List<TotalVistoriasRealizadasPorMesModel> value) =>
      totalVistoriasFeitasPorMes = ObservableList.of(value);

  @observable
  List<TotalVehiclesModel> totalVeiculos = ObservableList();

  @action
  void setTotalVeiculos(List<TotalVehiclesModel> value) =>
      totalVeiculos = ObservableList.of(value);

  @observable
  ObservableList<VistoriaAgendadaModel> proximasVistorias =
      ObservableList<VistoriaAgendadaModel>();

  @action
  void setProximasVistorias(List<VistoriaAgendadaModel> value) =>
      proximasVistorias = ObservableList.of(value);

  @observable
  String anoSelecionado = DateTime.now().year.toString();

  @action
  void setAnoSelecionado(String ano) {
    anoSelecionado = ano;
  }

  @observable
  bool loadingTotalClientes = false;

  @observable
  bool loadingTotalClientesPorGenero = false;

  @observable
  bool loadingTotalVistoriasFeitasPorMes = false;

  @observable
  bool loadingTotalVeiculos = false;

  @observable
  bool loadingProximasVistorias = false;

  @observable
  String? loadDashboardError;

  @action
  Future<void> loadTotalClientes() async {
    loadingTotalClientes = true;
    try {
      final results = await _dashBoardService.totalClientes();
      setTotalClientes([results]);
    } on DioException catch (_) {
      setTotalClientes([]);
      loadDashboardError = 'Ocorreu um erro ao buscar o total de clientes.';
    } finally {
      loadingTotalClientes = false;
    }
  }

  @action
  Future<void> loadTotalClientesPorGenero() async {
    loadingTotalClientesPorGenero = true;
    try {
      final List<TotalClientesPorGeneroModel> results =
          await _dashBoardService.totalClientesPorGenero();

      setTotalClientesPorGenero(results);
    } on DioException catch (_) {
      setTotalClientesPorGenero([]);
      loadDashboardError = 'Ocorreu um erro ao buscar os clientes por gênero.';
    } finally {
      loadingTotalClientesPorGenero = false;
    }
  }

  @action
  Future<void> loadTotalVistoriasFeitasPorMes(String ano) async {
    loadingTotalVistoriasFeitasPorMes = true;
    try {
      final List<TotalVistoriasRealizadasPorMesModel> results =
          await _dashBoardService.totalVistoriasFeitasPorMes(ano);

      setTotalVistoriasFeitasPorMes(results);
    } catch (_) {
      setTotalVistoriasFeitasPorMes([]);
      loadDashboardError = 'Erro ao buscar vistorias.';
    } finally {
      loadingTotalVistoriasFeitasPorMes = false;
    }
  }

  @action
  Future<void> loadTotalVeiculos() async {
    loadingTotalVeiculos = true;
    try {
      final results = await _dashBoardService.totalVeiculos();
      setTotalVeiculos([results]);
    } on DioException catch (_) {
      setTotalVeiculos([]);
      loadDashboardError = 'Ocorreu um erro ao buscar o total de clientes.';
    } finally {
      loadingTotalVeiculos = false;
    }
  }

  @action
  Future<void> loadProximasVistorias() async {
    loadingProximasVistorias = true;
    try {
      final List<VistoriaAgendadaModel> results =
          await _dashBoardService.proximasVistorias();

      setProximasVistorias(results);
    } catch (_) {
      setProximasVistorias([]);
      loadDashboardError = 'Erro ao buscar vistorias.';
    } finally {
      loadingProximasVistorias = false;
    }
  }
}
