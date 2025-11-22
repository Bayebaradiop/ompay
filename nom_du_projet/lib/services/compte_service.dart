import '../api_service/api_service.dart';
import '../dto/response/compte_response.dart';
import '../utils/constants.dart';
import '../utils/error_messages.dart';

class CompteService {
  final ApiService _apiService = ApiService();

  /// Récupère le compte d'un utilisateur par son ID
  Future<CompteResponse?> getCompteByUtilisateurId(int utilisateurId) async {
    try {
      final results = await _apiService.getWithParams(
        '/comptes',
        {'utilisateurId': utilisateurId.toString()},
      );

      if (results.isEmpty) return null;

      return CompteResponse.fromJson(results.first as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  Future<double> consulterMonSolde() async {
    try {
      
      final response = await _apiService.getWithAuth(
        ApiConstants.soldeEndpoint,
      );

      final solde = (response['data'] as num).toDouble();
      
      return solde;
      
    } catch (e) {
      throw Exception(ErrorMessages.avecDetails(ErrorMessages.soldeIndisponible, e));
    }
  }

  Future<String> getNumeroCompte() async {
    try {
      final response = await _apiService.getWithAuth(
        ApiConstants.profilEndpoint,
      );

      
      // La structure peut être response['data']['compte']['numeroCompte'] ou response['data']['numeroCompte']
      final data = response['data'];
      String? numeroCompte;
      
      if (data is Map) {
        if (data.containsKey('compte') && data['compte'] != null) {
          numeroCompte = data['compte']['numeroCompte'] as String?;
        } else if (data.containsKey('numeroCompte')) {
          numeroCompte = data['numeroCompte'] as String?;
        }
      }
      
      if (numeroCompte == null) {
        throw Exception('Numéro de compte non trouvé dans la réponse');
      }
      
      return numeroCompte;
      
    } catch (e) {
      throw Exception(ErrorMessages.avecDetails(ErrorMessages.numeroCompteIndisponible, e));
    }
  }
}
