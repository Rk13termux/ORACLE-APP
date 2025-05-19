import 'package:flutter/material.dart';

enum TransactionType {
  income,
  expense,
}

enum TransactionCategory {
  salary,
  investment,
  gift,
  food,
  transportation,
  entertainment,
  housing,
  utilities,
  health,
  education,
  shopping,
  other,
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

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      type: TransactionType.values.byName(json['type']),
      category: TransactionCategory.values.byName(json['category']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
      'category': category.name,
      'description': description,
    };
  }

  IconData get categoryIcon {
    switch (category) {
      case TransactionCategory.salary:
        return Icons.work;
      case TransactionCategory.investment:
        return Icons.trending_up;
      case TransactionCategory.gift:
        return Icons.card_giftcard;
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.transportation:
        return Icons.directions_car;
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.housing:
        return Icons.home;
      case TransactionCategory.utilities:
        return Icons.power;
      case TransactionCategory.health:
        return Icons.local_hospital;
      case TransactionCategory.education:
        return Icons.school;
      case TransactionCategory.shopping:
        return Icons.shopping_cart;
      case TransactionCategory.other:
        return Icons.more_horiz;
      default:
        return Icons.attach_money;
    }
  }

  Color get categoryColor {
    switch (category) {
      case TransactionCategory.salary:
        return Colors.green;
      case TransactionCategory.investment:
        return Colors.blue;
      case TransactionCategory.gift:
        return Colors.purple;
      case TransactionCategory.food:
        return Colors.orange;
      case TransactionCategory.transportation:
        return Colors.amber;
      case TransactionCategory.entertainment:
        return Colors.pink;
      case TransactionCategory.housing:
        return Colors.brown;
      case TransactionCategory.utilities:
        return Colors.indigo;
      case TransactionCategory.health:
        return Colors.red;
      case TransactionCategory.education:
        return Colors.cyan;
      case TransactionCategory.shopping:
        return Colors.teal;
      case TransactionCategory.other:
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }
}