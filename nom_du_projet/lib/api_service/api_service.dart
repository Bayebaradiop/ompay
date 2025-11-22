import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ApiService {

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // ========== Gestion du token JWT ==========
  String? _token;
  static const String _tokenKey = 'auth_token';

  String? get token => _token;
  
  set token(String? value) {
    _token = value;
    _saveToken(value);
  }

  /// Sauvegarde le token dans SharedPreferences
  Future<void> _saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(_tokenKey, token);
    } else {
      await prefs.remove(_tokenKey);
    }
  }

  /// Charge le token depuis SharedPreferences
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  /// Génère les headers HTTP avec authentification optionnelle
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {'Content-Type': 'application/json'};
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<List<dynamic>> getAll(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        try {
          final errorBody = json.decode(response.body);
          final message = errorBody['message'] ?? errorBody['error'] ?? 'Erreur lors de la récupération des données';
          throw Exception(message);
        } catch (e) {
          if (response.statusCode == 404) {
            throw Exception('Aucune donnée trouvée');
          } else if (response.statusCode == 401) {
            throw Exception('Session expirée. Veuillez vous reconnecter');
          } else if (response.statusCode == 500) {
            throw Exception('Erreur serveur. Veuillez réessayer plus tard');
          } else {
            throw Exception('Erreur lors de la récupération des données');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<Map<String, dynamic>> getById(String endpoint, int id) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        try {
          final errorBody = json.decode(response.body);
          final message = errorBody['message'] ?? errorBody['error'] ?? 'Ressource non trouvée';
          throw Exception(message);
        } catch (e) {
          if (response.statusCode == 404) {
            throw Exception('Ressource non trouvée');
          } else if (response.statusCode == 401) {
            throw Exception('Session expirée. Veuillez vous reconnecter');
          } else if (response.statusCode == 403) {
            throw Exception('Accès refusé');
          } else if (response.statusCode == 500) {
            throw Exception('Erreur serveur. Veuillez réessayer plus tard');
          } else {
            throw Exception('Ressource non disponible');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<List<dynamic>> getWithParams(String endpoint, Map<String, String> params) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint').replace(queryParameters: params);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        try {
          final errorBody = json.decode(response.body);
          final message = errorBody['message'] ?? errorBody['error'] ?? 'Aucun résultat trouvé';
          throw Exception(message);
        } catch (e) {
          if (response.statusCode == 404) {
            throw Exception('Aucun résultat trouvé');
          } else if (response.statusCode == 401) {
            throw Exception('Session expirée. Veuillez vous reconnecter');
          } else if (response.statusCode == 400) {
            throw Exception('Paramètres de recherche invalides');
          } else if (response.statusCode == 500) {
            throw Exception('Erreur serveur. Veuillez réessayer plus tard');
          } else {
            throw Exception('Erreur lors de la recherche');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<Map<String, dynamic>> create(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        try {
          final errorBody = json.decode(response.body);
          final message = errorBody['message'] ?? errorBody['error'] ?? 'Erreur lors de la création';
          throw Exception(message);
        } catch (e) {
          if (response.statusCode == 400) {
            throw Exception('Données invalides. Vérifiez vos informations');
          } else if (response.statusCode == 409) {
            throw Exception('Cette ressource existe déjà');
          } else if (response.statusCode == 401) {
            throw Exception('Session expirée. Veuillez vous reconnecter');
          } else if (response.statusCode == 403) {
            throw Exception('Accès refusé');
          } else if (response.statusCode == 500) {
            throw Exception('Erreur serveur. Veuillez réessayer plus tard');
          } else {
            throw Exception('Impossible de créer la ressource');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> update(String endpoint, int id, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint/$id');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        try {
          final errorBody = json.decode(response.body);
          final message = errorBody['message'] ?? errorBody['error'] ?? 'Erreur lors de la mise à jour';
          throw Exception(message);
        } catch (e) {
          if (response.statusCode == 404) {
            throw Exception('Ressource non trouvée');
          } else if (response.statusCode == 400) {
            throw Exception('Données invalides. Vérifiez vos informations');
          } else if (response.statusCode == 401) {
            throw Exception('Session expirée. Veuillez vous reconnecter');
          } else if (response.statusCode == 403) {
            throw Exception('Accès refusé');
          } else if (response.statusCode == 409) {
            throw Exception('Conflit lors de la mise à jour');
          } else if (response.statusCode == 500) {
            throw Exception('Erreur serveur. Veuillez réessayer plus tard');
          } else {
            throw Exception('Impossible de mettre à jour la ressource');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String endpoint, int id) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint/$id');
      final response = await http.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else {
        try {
          final errorBody = json.decode(response.body);
          final message = errorBody['message'] ?? errorBody['error'] ?? 'Erreur lors de la suppression';
          throw Exception(message);
        } catch (e) {
          if (response.statusCode == 404) {
            throw Exception('Ressource non trouvée');
          } else if (response.statusCode == 401) {
            throw Exception('Session expirée. Veuillez vous reconnecter');
          } else if (response.statusCode == 403) {
            throw Exception('Accès refusé');
          } else if (response.statusCode == 409) {
            throw Exception('Impossible de supprimer. Ressource utilisée');
          } else if (response.statusCode == 500) {
            throw Exception('Erreur serveur. Veuillez réessayer plus tard');
          } else {
            throw Exception('Impossible de supprimer la ressource');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // ========== Méthodes pour l'authentification ==========
  
  /// Méthode POST pour l'authentification (accepte 200 et 201)
  
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool includeAuth = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      
      
      final response = await http.post(
        url,
        headers: _getHeaders(includeAuth: includeAuth),
        body: json.encode(data),
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Extraire le vrai message d'erreur du backend
        try {
          final errorBody = json.decode(response.body);
          final message = errorBody['message'] ?? errorBody['error'] ?? 'Erreur HTTP ${response.statusCode}';
          throw Exception(message);
        } catch (e) {
          // Si le parsing échoue, message clair selon le code HTTP
          if (response.statusCode == 404) {
            throw Exception('Ressource non trouvée');
          } else if (response.statusCode == 401) {
            throw Exception('Téléphone ou mot de passe incorrect');
          } else if (response.statusCode == 400) {
            throw Exception('Données invalides. Vérifiez vos informations');
          } else if (response.statusCode == 403) {
            throw Exception('Accès refusé');
          } else if (response.statusCode == 500) {
            throw Exception('Erreur serveur. Veuillez réessayer plus tard');
          } else {
            throw Exception('Erreur HTTP ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET avec authentification (pour les endpoints protégés)
  Future<Map<String, dynamic>> getWithAuth(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final response = await http.get(
        url,
        headers: _getHeaders(includeAuth: true),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Essayer d'extraire le message d'erreur du body
        try {
          final errorBody = json.decode(response.body);
          final message = errorBody['message'] ?? errorBody['error'] ?? 'Erreur HTTP ${response.statusCode}';
          throw Exception(message);
        } catch (e) {
          // Si le parsing échoue, retourner un message selon le code HTTP
          if (response.statusCode == 404) {
            throw Exception('Ressource non trouvée');
          } else if (response.statusCode == 401) {
            throw Exception('Session expirée. Veuillez vous reconnecter');
          } else if (response.statusCode == 403) {
            throw Exception('Accès refusé');
          } else if (response.statusCode == 500) {
            throw Exception('Erreur serveur. Veuillez réessayer plus tard');
          } else {
            throw Exception('Erreur HTTP ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// GET ALL avec authentification
  Future<List<dynamic>> getAllWithAuth(String endpoint) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final response = await http.get(
        url,
        headers: _getHeaders(includeAuth: true),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        // Extraire le message d'erreur
        try {
          final errorBody = json.decode(response.body);
          final message = errorBody['message'] ?? errorBody['error'] ?? 'Erreur HTTP ${response.statusCode}';
          throw Exception(message);
        } catch (e) {
          if (response.statusCode == 404) {
            throw Exception('Aucune donnée trouvée');
          } else if (response.statusCode == 401) {
            throw Exception('Session expirée. Veuillez vous reconnecter');
          } else if (response.statusCode == 403) {
            throw Exception('Accès refusé');
          } else if (response.statusCode == 500) {
            throw Exception('Erreur serveur. Veuillez réessayer plus tard');
          } else {
            throw Exception('Erreur HTTP ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}