import 'package:get_it/get_it.dart';
import 'package:project_evydhence/controllers/client_controller.dart';

class InjectionContainer {
  InjectionContainer._();

  static InjectionContainer get instance => InjectionContainer._();

  /// shorthand to "service locator"
  static final sl = GetIt.instance;

  void _registerControllers() {
    sl.registerLazySingleton<ClientController>(
      () => ClientController(),
    );
  }

  Future<void> init() async {
     _registerControllers();
  }
}