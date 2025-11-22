import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/transaction_type_toggle.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/transaction_card.dart';
import '../../widgets/custom_snackbar.dart';
import '../../services/compte_service.dart';
import '../../services/transaction_service.dart';
import '../../services/PaiementMarchandService.dart';
import '../../services/auth_service.dart';
import '../../utils/error_messages.dart';
import '../../dto/response/transaction_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TransactionType _selectedType = TransactionType.transfer;
  final _numberController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isDarkMode = true;
  bool _isScannerEnabled = true;
  String _selectedLanguage = 'Français';
  
  // Services
  final _compteService = CompteService();
  final _transactionService = TransactionService();
  final _paiementService = PaiementMarchandService();
  final _authService = AuthService();
  
  // Data
  double _balance = 0;
  String _userName = '';
  String _userPhone = '';
  List<TransactionResponse> _transactions = [];
  bool _isLoading = true;
  bool _isProcessing = false;
  
  // Erreurs de validation
  String? _numberError;
  String? _amountError;
  // String? _pinError; // Pour utilisation future si PIN requis

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Charger le profil utilisateur
      final profile = await _authService.getProfile();
      
      // Charger le solde
      final solde = await _compteService.consulterMonSolde();
      
      // Charger l'historique des transactions
      final historique = await _transactionService.getHistorique();
      
      // Extraire les informations utilisateur
      final nom = profile['nom'] ?? '';
      final prenom = profile['prenom'] ?? '';
      final telephone = profile['telephone'] ?? '';
      
      setState(() {
        _userName = '$prenom $nom';
        _userPhone = telephone;
        _balance = solde;
        _transactions = historique;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        CustomSnackbar.showError(
          context,
          e.toString().replaceAll('Exception: ', ''),
        );
      }
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type.toUpperCase()) {
      case 'TRANSFERT':
        return Icons.send_outlined;
      case 'DEPOT':
        return Icons.account_balance_wallet_outlined;
      case 'RETRAIT':
        return Icons.money_outlined;
      case 'PAIEMENT':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.receipt_outlined;
    }
  }

  String _getTransactionTitle(String type) {
    switch (type.toUpperCase()) {
      case 'TRANSFERT':
        return 'Transfert d\'argent';
      case 'DEPOT':
        return 'Dépôt d\'argent';
      case 'RETRAIT':
        return 'Retrait d\'argent';
      case 'PAIEMENT':
        return 'Paiement marchand';
      default:
        return 'Transaction';
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      _numberError = null;
      _amountError = null;
      // _pinError = null; // Pour utilisation future
    });
  }

  Future<void> _handleTransaction() async {
    // Reset erreurs
    _clearErrors();

    // Validation
    bool hasError = false;
    
    if (_numberController.text.isEmpty) {
      setState(() => _numberError = _selectedType == TransactionType.pay 
        ? ErrorMessages.codeMarchandRequis
        : ErrorMessages.destinataireRequis);
      hasError = true;
    }
    
    if (_amountController.text.isEmpty) {
      setState(() => _amountError = ErrorMessages.montantRequis);
      hasError = true;
    } else {
      final montant = double.tryParse(_amountController.text);
      if (montant == null || montant <= 0) {
        setState(() => _amountError = 'Montant invalide (doit être > 0)');
        hasError = true;
      } else if (montant > _balance) {
        setState(() => _amountError = 'Solde insuffisant');
        hasError = true;
      }
    }
    
    if (hasError) return;

    setState(() => _isProcessing = true);

    try {
      final montant = double.parse(_amountController.text);

      if (_selectedType == TransactionType.transfer) {
        await _transactionService.transfert(
          telephoneDestinataire: _numberController.text.trim(),
          montant: montant,
        );
      } else {
        // Utiliser PaiementMarchandService pour le paiement
        await _paiementService.paiement(
          codeMarchand: _numberController.text.trim(),
          montant: montant,
        );
      }

      setState(() => _isProcessing = false);

      if (mounted) {
        CustomSnackbar.showSuccess(
          context,
          _selectedType == TransactionType.pay
              ? ErrorMessages.paiementReussi
              : ErrorMessages.transfertReussi,
        );
      }

      _numberController.clear();
      _amountController.clear();
      _clearErrors();
      
      // Recharger les données
      _loadUserData();
    } catch (e) {
      setState(() => _isProcessing = false);
      
      String errorMessage = ErrorMessages.parseBackendError(e);
      
      // Afficher l'erreur sous le champ approprié
      if (errorMessage.contains('téléphone') || 
          errorMessage.contains('destinataire') || 
          errorMessage.contains('marchand') ||
          errorMessage.contains('code') ||
          errorMessage.contains('introuvable')) {
        setState(() => _numberError = errorMessage);
      } else if (errorMessage.contains('montant') || 
                 errorMessage.contains('solde') ||
                 errorMessage.contains('plafond') ||
                 errorMessage.contains('insuffisant')) {
        setState(() => _amountError = errorMessage);
      } else {
        // Erreur générale sous le montant
        setState(() => _amountError = errorMessage);
      }
    }
  }

  void _showQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Mon QR Code', style: AppTextStyles.header3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.qr_code, size: 180),
            ),
            const SizedBox(height: 16),
            Text(
              _userPhone,
              style: AppTextStyles.bodyLarge,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fermer',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primaryOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scanQRCode() {
    // TODO: Implement QR scanner
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scanner QR Code')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        userName: _userName,
        userPhone: _userPhone,
        isDarkMode: _isDarkMode,
        isScannerEnabled: _isScannerEnabled,
        selectedLanguage: _selectedLanguage,
        onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
        onScannerToggle: () => setState(() => _isScannerEnabled = !_isScannerEnabled),
        onLanguageChanged: (lang) => setState(() => _selectedLanguage = lang),
        onLogout: () {
          _authService.logout();
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
      body: Builder(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Balance Card
            BalanceCard(
              balance: _balance,
              userName: _userName,
              onQrCodeTap: _showQRCode,
              onMenuTap: () => Scaffold.of(context).openDrawer(),
            ),
            
            // Transaction Form avec image rainbow en arrière-plan
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow:[
                   BoxShadow(

                 color: Colors.white24,
                 blurRadius: 10, 
                 offset: Offset(0, 5), 
                 spreadRadius: 2,      
                )
                ]
              ),
              child: Stack(
                children: [
                  Positioned(
                  top: -10,
                  bottom: -10,
                  right: 0,
                  left: 0,
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        'assets/images/rainbow_bg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Contenu du formulaire EN SECOND (devant l'image)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical:10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Toggle Payer/Transférer
                        TransactionTypeToggle(
                          selectedType: _selectedType,
                          onChanged: (type) => setState(() => _selectedType = type),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Numéro/Code marchand
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: CustomTextField(
                              hintText: _selectedType == TransactionType.pay
                                  ? 'Saisir le numéro/code march...'
                                  : 'Saisir le numéro',
                              controller: _numberController,
                              keyboardType: TextInputType.phone,
                              errorText: _numberError,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.person_add, color: AppColors.primaryOrange, size: 22),
                                onPressed: () {
                                  // TODO: Select from contacts
                                },
                              ),
                              onChanged: (value) {
                                if (_numberError != null) {
                                  setState(() => _numberError = null);
                                }
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Montant
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: CustomTextField(
                              hintText: 'Saisir le montant',
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              errorText: _amountError,
                              onChanged: (value) {
                                if (_amountError != null) {
                                  setState(() => _amountError = null);
                                }
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Bouton Valider
                        CustomButton(
                          text: 'Valider',
                          onPressed: _handleTransaction,
                          isLoading: _isProcessing,
                        ),
                        
                        // Scanner QR
                       
                      ],
                    ),
                  ),
                ],
              ),
            ),

                 Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Text(
                'Pour toute autre opération',
                style: AppTextStyles.bodyMedium,
              ),
            ),
            
            
            // Max it Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  
                  Container(
                    width: 50,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    
                    child: Center(
                      child: Text(
                        'Max it',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Accéder à Max it',
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
            
            // Section "Pour toute autre opération"
       
            // Historique Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Historique', style: AppTextStyles.header3),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: AppColors.primaryOrange),
                    onPressed: _loadUserData,
                  ),
                ],
              ),
            ),
            
            // Scrollable Transactions List
            Expanded(
              child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryOrange),
                  )
                : _transactions.isEmpty
                  ? Center(
                      child: Text(
                        'Aucune transaction',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _transactions[index];
                        final isPositive = transaction.typeTransaction == 'DEPOT' ||
                            (transaction.compteDestinataire != null);
                        
                        return TransactionCard(
                          icon: _getTransactionIcon(transaction.typeTransaction),
                          title: _getTransactionTitle(transaction.typeTransaction),
                          subtitle: transaction.compteExpediteur ?? transaction.telephoneDistributeur ?? '',
                          amount: transaction.montant.toStringAsFixed(0),
                          date: _formatDate(transaction.dateCreation),
                          isPositive: isPositive,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
