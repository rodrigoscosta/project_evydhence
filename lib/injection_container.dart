import 'package:get_it/get_it.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/controllers/vehicle_controller.dart';

class InjectionContainer {
  // Construtor privado
  InjectionContainer._();

  // Instância singleton
  static InjectionContainer get instance => InjectionContainer._();

  // Instância do serviço locator
  static final sl = GetIt.instance;

  // Registra os controladores
  void _registerControllers() {
    sl.registerLazySingleton<ClientController>(
      () => ClientController(),
    );
    sl.registerLazySingleton<VehicleController>(
      () => VehicleController(),
    );
  }

  // Inicializa os serviços e controladores
  Future<void> init() async {
    _registerControllers();
  }
}