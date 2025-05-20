import 'package:flutter/foundation.dart';
import 'package:vida_organizada/features/finanzas/models/transaction_model.dart';

class FinanceProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  
  // Getters para obtener todas las transacciones
  List<Transaction> get transactions => [..._transactions];
  
  // Obtener solo ingresos
  List<Transaction> get incomes => _transactions
      .where((transaction) => transaction.type == TransactionType.income)
      .toList();
  
  // Obtener solo gastos
  List<Transaction> get expenses => _transactions
      .where((transaction) => transaction.type == TransactionType.expense)
      .toList();
  
  // Calcular balance total
  double get balance {
    double total = 0;
    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.income) {
        total += transaction.amount;
      } else {
        total -= transaction.amount;
      }
    }
    return total;
  }
  
  // Calcular ingresos totales
  double get totalIncome {
    double total = 0;
    for (var transaction in incomes) {
      total += transaction.amount;
    }
    return total;
  }
  
  // Calcular gastos totales
  double get totalExpense {
    double total = 0;
    for (var transaction in expenses) {
      total += transaction.amount;
    }
    return total;
  }
  
  // Obtener gastos por categoría
  Map<TransactionCategory, double> get expensesByCategory {
    final Map<TransactionCategory, double> result = {};
    
    for (var transaction in expenses) {
      if (result.containsKey(transaction.category)) {
        result[transaction.category] = result[transaction.category]! + transaction.amount;
      } else {
        result[transaction.category] = transaction.amount;
      }
    }
    
    return result;
  }
  
  // Añadir una transacción
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _transactions.sort((a, b) => b.date.compareTo(a.date)); // Ordenar por fecha descendente
    notifyListeners();
  }
  
  // Actualizar una transacción
  void updateTransaction(Transaction updated) {
    final index = _transactions.indexWhere((t) => t.id == updated.id);
    if (index >= 0) {
      _transactions[index] = updated;
      _transactions.sort((a, b) => b.date.compareTo(a.date)); // Ordenar por fecha descendente
      notifyListeners();
    }
  }
  
  // Eliminar una transacción
  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}