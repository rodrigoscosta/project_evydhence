class ApiConstants {
  static String baseUrl = 'http://127.0.0.1:8000';

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
}
