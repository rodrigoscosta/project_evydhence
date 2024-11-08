class ApiConstants {
  static String baseUrl =
      'https://projectevydhencebackend-production.up.railway.app';

  // static String baseUrl = 'http://127.0.0.1:8000';

  static String getClientsEndpoint = '/persons/';
  static String getClientEndpoint = '/persons/<int:pk>/';
  static String postClientEndpoint = '/persons/create/';
  static String putClientEndpoint = '/persons/<int:pk>/update/';
  static String deleteClientEndpoint = '/persons/<int:pk>/delete/';

  static String getVehiclesEndpoint = '/vehicles/';
  static String getVehiclesByClientEndpoint = '/vehicles/<int:pk>/';
  static String postVehicleEndpoint = '/vehicles/create/';
  static String putVehicleEndpoint = '/vehicles/<int:pk>/update/';
  static String deleteVehicleEndpoint = '/vehicles/<int:pk>/delete/';

  static String getSchedulesEndpoint = '/schedules/';
  static String getSchedulesByVehicleEndpoint = '/schedules/<int:pk>/';
  static String postSchedulesEndpoint = '/schedules/create/';
  static String putSchedulesEndpoint = '/schedules/<int:pk>/update/';
  static String deleteSchedulesEndpoint = '/schedules/<int:pk>/delete/';
}
