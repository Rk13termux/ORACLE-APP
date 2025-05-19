import 'package:flutter/material.dart';
import 'package:vida_organizada/features/finanzas/models/transaction_model.dart';

class FinanceProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  // Datos de ejemplo para mostrar
  FinanceProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    _transactions = [
      Transaction(
        id: '1',
        title: 'Salario',
        amount: 2000.00,
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.income,
        category: TransactionCategory.salary,
      ),
      Transaction(
        id: '2',
        title: 'Dividendos',
        amount: 450.00,
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.income,
        category: TransactionCategory.investment,
      ),
      Transaction(
        id: '3',
        title: 'Supermercado',
        amount: 120.50,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.expense,
        category: TransactionCategory.food,
        description: 'Compra semanal de alimentos',
      ),
      Transaction(
        id: '4',
        title: 'Gasolina',
        amount: 45.00,
        date: DateTime.now(),
        type: TransactionType.expense,
        category: TransactionCategory.transportation,
      ),
      Transaction(
        id: '5',
        title: 'Netflix',
        amount: 15.00,
        date: DateTime.now().subtract(const Duration(days: 5)),
        type: TransactionType.expense,
        category: TransactionCategory.entertainment,
      ),
      Transaction(
        id: '6',
        title: 'Alquiler',
        amount: 800.00,
        date: DateTime.now().subtract(const Duration(days: 10)),
        type: TransactionType.expense,
        category: TransactionCategory.housing,
      ),
      Transaction(
        id: '7',
        title: 'Electricidad',
        amount: 70.00,
        date: DateTime.now().subtract(const Duration(days: 8)),
        type: TransactionType.expense,
        category: TransactionCategory.utilities,
      ),
      Transaction(
        id: '8',
        title: 'Farmacia',
        amount: 35.00,
        date: DateTime.now().subtract(const Duration(days: 4)),
        type: TransactionType.expense,
        category: TransactionCategory.health,
      ),
      Transaction(
        id: '9',
        title: 'Curso Online',
        amount: 199.00,
        date: DateTime.now().subtract(const Duration(days: 15)),
        type: TransactionType.expense,
        category: TransactionCategory.education,
      ),
      Transaction(
        id: '10',
        title: 'Zapatillas',
        amount: 89.99,
        date: DateTime.now().subtract(const Duration(days: 7)),
        type: TransactionType.expense,
        category: TransactionCategory.shopping,
      ),
    ];
  }

  List<Transaction> get transactions => _transactions;

  List<Transaction> get incomes => _transactions
      .where((transaction) => transaction.type == TransactionType.income)
      .toList();

  List<Transaction> get expenses => _transactions
      .where((transaction) => transaction.type == TransactionType.expense)
      .toList();

  double get totalIncome => incomes.fold(0, (sum, item) => sum + item.amount);

  double get totalExpense => expenses.fold(0, (sum, item) => sum + item.amount);

  double get balance => totalIncome - totalExpense;

  Map<TransactionCategory, double> get expensesByCategory {
    final result = <TransactionCategory, double>{};
    for (final expense in expenses) {
      if (result.containsKey(expense.category)) {
        result[expense.category] = result[expense.category]! + expense.amount;
      } else {
        result[expense.category] = expense.amount;
      }
    }
    return result;
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }

  void updateTransaction(Transaction updatedTransaction) {
    final index = _transactions.indexWhere(
        (transaction) => transaction.id == updatedTransaction.id);
    if (index >= 0) {
      _transactions[index] = updatedTransaction;
      _transactions.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
  }
}