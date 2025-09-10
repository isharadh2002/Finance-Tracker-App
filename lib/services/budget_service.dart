// lib/services/budget_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget.dart';

class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'budgets';

  // Add a new budget
  Future<String> addBudget(Budget budget) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(budget.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add budget: $e');
    }
  }

  // Get all budgets for a user
  Stream<List<Budget>> getUserBudgets(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('month', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Budget.fromFirestore(doc))
        .toList());
  }

  // Get budgets for a specific month
  Stream<List<Budget>> getUserBudgetsForMonth(String userId, DateTime month) {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('month', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('month', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Budget.fromFirestore(doc))
        .toList());
  }

  // Update a budget
  Future<void> updateBudget(Budget budget) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(budget.id)
          .update(budget.toFirestore());
    } catch (e) {
      throw Exception('Failed to update budget: $e');
    }
  }

  // Delete a budget
  Future<void> deleteBudget(String budgetId) async {
    try {
      await _firestore.collection(_collection).doc(budgetId).delete();
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }

  // Check if budget exists for category and month
  Future<Budget?> getBudgetForCategoryAndMonth(
      String userId, String category, DateTime month) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: category)
          .where('month', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('month', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Budget.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get budget: $e');
    }
  }
}