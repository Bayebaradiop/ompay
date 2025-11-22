import '../dto/request/paiement_request.dart';
import '../dto/response/transaction_response.dart';
import '../api_service/api_service.dart';
import '../utils/constants.dart';
import '../utils/error_messages.dart';

class PaiementMarchandService {
  final ApiService _apiService = ApiService();

  Future<TransactionResponse> paiement({
    required String codeMarchand,
    required double montant,
  }) async {
    try {
      final request = PaiementRequest(
        codeMarchand: codeMarchand,
        montant: montant,
      );

      final response = await _apiService.post(
        ApiConstants.paiementEndpoint,
        request.toJson(),
        includeAuth: true,
      );

      final transactionData = response['data'] as Map<String, dynamic>;
      return TransactionResponse.fromJson(transactionData);
    } catch (e) {
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }
}