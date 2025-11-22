import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_snackbar.dart';
import '../../dto/response/transaction_response.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionResponse transaction;

  const TransactionDetailScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  IconData _getTransactionIcon() {
    switch (transaction.typeTransaction.toUpperCase()) {
      case 'TRANSFERT':
        return Icons.send_rounded;
      case 'DEPOT':
        return Icons.account_balance_wallet_rounded;
      case 'RETRAIT':
        return Icons.money_rounded;
      case 'PAIEMENT':
        return Icons.shopping_bag_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  Color _getTransactionColor() {
    switch (transaction.typeTransaction.toUpperCase()) {
      case 'DEPOT':
        return AppColors.greenSuccess;
      case 'RETRAIT':
      case 'PAIEMENT':
        return AppColors.redError;
      case 'TRANSFERT':
        return AppColors.primaryOrange;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTransactionColor();

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la transaction', style: AppTextStyles.header3),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              CustomSnackbar.showInfo(
                context,
                'Partage de la transaction',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header avec montant
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _getTransactionIcon(),
                      size: 40,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    transaction.typeTransaction,
                    style: AppTextStyles.header2.copyWith(color: color),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_formatAmount(transaction.montant)} FCFA',
                    style: AppTextStyles.header1.copyWith(
                      fontSize: 36,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: transaction.statut == 'TERMINE'
                          ? AppColors.greenSuccess.withOpacity(0.2)
                          : AppColors.primaryOrange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      transaction.statut,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: transaction.statut == 'TERMINE'
                            ? AppColors.greenSuccess
                            : AppColors.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Détails de la transaction
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Informations de la transaction'),
                  const SizedBox(height: 16),
                  _buildDetailCard([
                    _buildDetailRow(
                      'Référence',
                      transaction.reference,
                      Icons.tag,
                      canCopy: true,
                      context: context,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      'Date',
                      _formatDate(transaction.dateCreation),
                      Icons.calendar_today,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      'Heure',
                      _formatDate(transaction.dateCreation)
                          .split('à ')
                          .last,
                      Icons.access_time,
                    ),
                  ]),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Détails du montant'),
                  const SizedBox(height: 16),
                  _buildDetailCard([
                    _buildDetailRow(
                      'Montant',
                      '${_formatAmount(transaction.montant)} FCFA',
                      Icons.attach_money,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      'Frais',
                      '${_formatAmount(transaction.frais)} FCFA',
                      Icons.receipt,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      'Total',
                      '${_formatAmount(transaction.montant + transaction.frais)} FCFA',
                      Icons.account_balance,
                      isBold: true,
                    ),
                  ]),

                  if (transaction.compteExpediteur != null ||
                      transaction.compteDestinataire != null) ...[
                    const SizedBox(height: 24),
                    _buildSectionTitle('Comptes'),
                    const SizedBox(height: 16),
                    _buildDetailCard([
                      if (transaction.compteExpediteur != null) ...[
                        _buildDetailRow(
                          'Expéditeur',
                          transaction.compteExpediteur!,
                          Icons.person_outline,
                        ),
                        if (transaction.compteDestinataire != null)
                          const Divider(height: 24),
                      ],
                      if (transaction.compteDestinataire != null)
                        _buildDetailRow(
                          'Destinataire',
                          transaction.compteDestinataire!,
                          Icons.person,
                        ),
                    ]),
                  ],

                  const SizedBox(height: 24),
                  _buildSectionTitle('Solde après transaction'),
                  const SizedBox(height: 16),
                  _buildDetailCard([
                    _buildDetailRow(
                      'Nouveau solde',
                      '${_formatAmount(transaction.nouveauSolde)} FCFA',
                      Icons.account_balance_wallet,
                      isBold: true,
                      valueColor: AppColors.greenSuccess,
                    ),
                  ]),

                  const SizedBox(height: 32),

                  // Boutons d'action
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            CustomSnackbar.showInfo(
                              context,
                              'Téléchargement du reçu...',
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Télécharger'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            CustomSnackbar.showInfo(
                              context,
                              'Répéter la transaction',
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Répéter'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.header3,
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    bool isBold = false,
    Color? valueColor,
    bool canCopy = false,
    BuildContext? context,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.primaryOrange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
        if (canCopy && context != null)
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            color: AppColors.primaryOrange,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              CustomSnackbar.showSuccess(
                context,
                'Référence copiée',
              );
            },
          ),
      ],
    );
  }
}
