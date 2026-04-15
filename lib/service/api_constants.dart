/// Documentación de la API CatFact
/// 
/// Base URL: https://catfact.ninja/
/// 
/// Endpoints disponibles:
/// - [breedsEndpoint]: (/breeds) Devuelve una lista de razas de gatos. 
///   Soporta paginación usando los parámetros query: ?page=1&limit=10.
/// 
/// - [factEndpoint]: (/fact) Devuelve un dato curioso aleatorio sobre gatos en texto.
class ApiConstants {
  static const String baseUrl = 'https://catfact.ninja';
  static const String breedsEndpoint = '$baseUrl/breeds';
  static const String factEndpoint = '$baseUrl/fact';
}
