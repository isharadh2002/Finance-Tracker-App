// lib/models/transaction.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class FinanceTransaction extends Equatable {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final TransactionType type;
  final DateTime createdAt;

  const FinanceTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.type,
    required this.createdAt,
  });

  factory FinanceTransaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FinanceTransaction(
      id: doc.id,
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: TransactionType.values.firstWhere(
            (e) => e.toString() == 'TransactionType.${data['type']}',
        orElse: () => TransactionType.expense,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'amount': amount,
      'category': category,
      'description': description,
      'date': Timestamp.fromDate(date),
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  FinanceTransaction copyWith({
    String? id,
    String? userId,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    TransactionType? type,
    DateTime? createdAt,
  }) {
    return FinanceTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    amount,
    category,
    description,
    date,
    type,
    createdAt,
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Business',
    'Investment',
    'Gift',
    'Other Income',
  ];

  static const List<String> expenseCategories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Groceries',
    'Other Expense',
  ];
}