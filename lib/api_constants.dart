class ApiConstants {
  static String baseUrl = 'http://127.0.0.1:8000';

  static String getClientsEndpoint = '/persons/';
  static String getClientEndpoint = '/api/persons/<int:pk>/';
  static String postClientEndpoint = '/api/persons/create/';
  static String putClientEndpoint = '/api/persons/<int:pk>/update/';
  static String deleteClientEndpoint = '/api/persons/<int:pk>/delete/';

  static String getVehiclesEndpoint = '/api/vehicles/';
  static String postVehicleEndpoint = '/api/vehicles/create/';
  static String putVehicleEndpoint = '/api/vehicles/<int:pk>/update/';
  static String deleteVehicleEndpoint = '/api/vehicles/<int:pk>/delete/';
}
