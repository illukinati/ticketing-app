import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  
  // Headers
  static Map<String, String> get headers => {
    'accept': 'application/json',
    'X-API-Key': apiKey,
  };
  
  // Endpoints
  static const String shows = '/shows';
  static const String phases = '/phases';
  static const String categories = '/categories';
}