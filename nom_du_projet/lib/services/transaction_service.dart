import '../dto/request/transfert_request.dart';
import '../dto/response/transaction_response.dart';
import '../api_service/api_service.dart';
import '../utils/constants.dart';
import '../utils/error_messages.dart';
import 'compte_service.dart';

class TransactionService {
  final ApiService _apiService = ApiService();
  final CompteService _compteService = CompteService();

  Future<TransactionResponse> transfert({
    required String telephoneDestinataire,
    required double montant,
  }) async {
    try {
      final request = TransfertRequest(
        telephoneDestinataire: telephoneDestinataire,
        montant: montant,
      );

      final response = await _apiService.post(
        ApiConstants.transfertEndpoint,
        request.toJson(),
        includeAuth: true,
      );

      final transactionData = response['data'] as Map<String, dynamic>;
      return TransactionResponse.fromJson(transactionData);
    } catch (e) {
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }

  Future<List<TransactionResponse>> getHistorique() async {
    try {
      final numeroCompte = await _compteService.getNumeroCompte();
      
      final response = await _apiService.getWithAuth(
        '${ApiConstants.historiqueEndpoint}/$numeroCompte',
      );

      if (response.containsKey('data')) {
        final data = response['data'];
        
        if (data is List) {
          return data
              .map((json) => TransactionResponse.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Le champ data n\'est pas une liste');
        }
      } else {
        throw Exception('Réponse sans champ data');
      }
    } catch (e) {
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }
}
