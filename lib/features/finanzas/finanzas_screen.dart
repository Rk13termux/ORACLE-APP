import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vida_organizada/config/themes.dart';
import 'package:vida_organizada/features/finanzas/models/transaction_model.dart';
import 'package:vida_organizada/features/finanzas/providers/finance_provider.dart';
import 'package:vida_organizada/features/finanzas/widgets/transaction_form.dart';
import 'package:vida_organizada/features/finanzas/widgets/transaction_list_item.dart';
import 'package:vida_organizada/shared/layouts/base_screen_layout.dart';
import 'package:intl/intl.dart';

class FinanzasScreen extends StatefulWidget {
  const FinanzasScreen({Key? key}) : super(key: key);

  @override
  State<FinanzasScreen> createState() => _FinanzasScreenState();
}

class _FinanzasScreenState extends State<FinanzasScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceProvider>(
      builder: (context, financeProvider, _) {
        final formatCurrency = NumberFormat.currency(locale: 'es_MX', symbol: '\$');
        
        return BaseScreenLayout(
          title: 'Finanzas',
          actions: [
            IconButton(
              icon: const Icon(Icons.pie_chart),
              onPressed: () {
                // Navegar a estadísticas
              },
            )
          ],
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppThemes.primaryBlue,
            foregroundColor: Colors.white,
            onPressed: () {
              _showAddTransactionModal(context);
            },
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              // Resumen Financiero
              Container(
                decoration: AppThemes.glassEffect(
                  color: Colors.black,
                  opacity: 0.5,
                  borderRadius: 20,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Balance Total',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatCurrency.format(financeProvider.balance),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: financeProvider.balance >= 0 
                                    ? Colors.green 
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: AppThemes.primaryBlue,
                            size: 32,
                          ),
                          onPressed: () {
                            _showAddTransactionModal(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFinancialItem(
                          'Ingresos', 
                          formatCurrency.format(financeProvider.totalIncome),
                          Colors.green
                        ),
                        _buildFinancialItem(
                          'Gastos', 
                          formatCurrency.format(financeProvider.totalExpense),
                          Colors.red
                        ),
                        _buildFinancialItem(
                          'Ahorro', 
                          '${(financeProvider.balance > 0 ? financeProvider.balance / financeProvider.totalIncome * 100 : 0).toStringAsFixed(0)}%',
                          AppThemes.primaryBlue
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // TabBar para filtrar transacciones
              Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Todas'),
                    Tab(text: 'Ingresos'),
                    Tab(text: 'Gastos'),
                  ],
                  indicatorColor: AppThemes.primaryBlue,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Lista de transacciones
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Todas las transacciones
                    _buildTransactionsList(financeProvider.transactions),
                    
                    // Solo ingresos
                    _buildTransactionsList(financeProvider.incomes),
                    
                    // Solo gastos
                    _buildTransactionsList(financeProvider.expenses),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // El resto de métodos y widgets desde _buildFinancialItem, _buildTransactionsList, etc.
  // (mantenerlos como estaban antes)
  
  Widget _buildFinancialItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
  
  Widget _buildTransactionsList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay transacciones',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TransactionListItem(
            transaction: transaction,
            onDelete: () {
              Provider.of<FinanceProvider>(context, listen: false)
                  .deleteTransaction(transaction.id);
            },
            onEdit: () {
              _showEditTransactionModal(context, transaction);
            },
          ),
        );
      },
    );
  }
  
  void _showAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionForm(
        onSubmit: (transaction) {
          Provider.of<FinanceProvider>(context, listen: false)
              .addTransaction(transaction);
          Navigator.pop(context);
        },
      ),
    );
  }
  
  void _showEditTransactionModal(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionForm(
        transaction: transaction,
        onSubmit: (updatedTransaction) {
          Provider.of<FinanceProvider>(context, listen: false)
              .updateTransaction(updatedTransaction);
          Navigator.pop(context);
        },
      ),
    );
  }
}