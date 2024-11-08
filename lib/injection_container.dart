import 'package:get_it/get_it.dart';
import 'package:project_evydhence/controllers/client_controller.dart';
import 'package:project_evydhence/controllers/schedule_controller.dart';
import 'package:project_evydhence/controllers/vehicle_controller.dart';
import 'package:project_evydhence/provider/zoom_provider.dart';

class InjectionContainer {
  // Construtor privado
  InjectionContainer._();

  // Instância singleton
  static InjectionContainer get instance => InjectionContainer._();

  // Instância do serviço locator
  static final sl = GetIt.instance;

  // Registra os provedores e controladores
  void setup() {
    // Registra o ZoomProvider
    sl.registerSingleton<ZoomProvider>(ZoomProvider());

    // Registra os controladores
    _registerControllers();
  }

  // Registra os controladores
  void _registerControllers() {
    sl.registerLazySingleton<ClientController>(
      () => ClientController(),
    );
    sl.registerLazySingleton<VehicleController>(
      () => VehicleController(),
    );
    sl.registerLazySingleton<ScheduleController>(
      () => ScheduleController(),
    );
  }

  // Inicializa os serviços e controladores
  Future<void> init() async {
    setup(); // Certifique-se de chamar setup aqui
  }
}
