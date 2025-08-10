class ApiConfig {
  // Cambia esta URL cuando despliegues tu backend
  static const String baseUrl = 'https://proyecto-tareas-tjdj.onrender.com'; 
  // Cambia esta URL cuando despliegues tu backend
  //static const String baseUrl = '192.168.1.10:3000';  ipconfig con tu dirección IP local
  
  
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String tasksEndpoint = '/tasks';
  
  // Método helper para crear URIs
  static Uri createUri(String endpoint) {
    if (baseUrl.contains('://')) {
      // Si ya tiene protocolo (https://), usar Uri.parse
      return Uri.parse('$baseUrl$endpoint');
    } else {
      // Si no tiene protocolo, usar Uri.http para desarrollo local
      return Uri.http(baseUrl, endpoint);
    }
  }
  
  // Headers comunes
  static Map<String, String> getHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
}