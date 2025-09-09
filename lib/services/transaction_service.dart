// lib/services/transaction_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'transactions';

  // Add a new transaction
  Future<String> addTransaction(FinanceTransaction transaction) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(transaction.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  // Get all transactions for a user
  Stream<List<FinanceTransaction>> getUserTransactions(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FinanceTransaction.fromFirestore(doc))
        .toList());
  }

  // Get transactions filtered by date range
  Stream<List<FinanceTransaction>> getUserTransactionsByDateRange(
      String userId,
      DateTime startDate,
      DateTime endDate,
      ) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FinanceTransaction.fromFirestore(doc))
        .toList());
  }

  // Get transactions filtered by category
  Stream<List<FinanceTransaction>> getUserTransactionsByCategory(
      String userId,
      String category,
      ) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FinanceTransaction.fromFirestore(doc))
        .toList());
  }

  // Get transactions filtered by type
  Stream<List<FinanceTransaction>> getUserTransactionsByType(
      String userId,
      TransactionType type,
      ) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: type.name)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FinanceTransaction.fromFirestore(doc))
        .toList());
  }

  // Update a transaction
  Future<void> updateTransaction(FinanceTransaction transaction) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(transaction.id)
          .update(transaction.toFirestore());
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  // Delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection(_collection).doc(transactionId).delete();
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  // Get financial summary for a user
  Future<Map<String, double>> getFinancialSummary(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      double totalIncome = 0.0;
      double totalExpense = 0.0;

      for (final doc in snapshot.docs) {
        final transaction = FinanceTransaction.fromFirestore(doc);
        if (transaction.type == TransactionType.income) {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }

      return {
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'balance': totalIncome - totalExpense,
      };
    } catch (e) {
      throw Exception('Failed to get financial summary: $e');
    }
  }
}