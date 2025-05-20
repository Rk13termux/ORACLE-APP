import 'package:flutter/material.dart';

enum TransactionType { income, expense }
enum TransactionCategory {
  food,
  transport, // Asegurándome que esta categoría exista
  entertainment,
  shopping,
  utilities,
  health,
  education,
  salary,
  gift,
  other
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionCategory category;
  final String? description;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.description,
  });

  IconData get categoryIcon {
    switch (category) {
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.transport:
        return Icons.directions_car;
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.shopping:
        return Icons.shopping_bag;
      case TransactionCategory.utilities:
        return Icons.light;
      case TransactionCategory.health:
        return Icons.medical_services;
      case TransactionCategory.education:
        return Icons.school;
      case TransactionCategory.salary:
        return Icons.work;
      case TransactionCategory.gift:
        return Icons.card_giftcard;
      case TransactionCategory.other:
        return Icons.category;
    }
  }

  Color get categoryColor {
    switch (category) {
      case TransactionCategory.food:
        return Colors.orangeAccent;
      case TransactionCategory.transport:
        return Colors.blueAccent;
      case TransactionCategory.entertainment:
        return Colors.purpleAccent;
      case TransactionCategory.shopping:
        return Colors.pinkAccent;
      case TransactionCategory.utilities:
        return Colors.amberAccent;
      case TransactionCategory.health:
        return Colors.redAccent;
      case TransactionCategory.education:
        return Colors.tealAccent;
      case TransactionCategory.salary:
        return Colors.greenAccent;
      case TransactionCategory.gift:
        return Colors.indigoAccent;
      case TransactionCategory.other:
        return Colors.grey;
    }
  }
}