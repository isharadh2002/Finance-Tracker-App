// lib/providers/budget_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../models/transaction.dart';
import '../services/budget_service.dart';

class BudgetProvider with ChangeNotifier {
  final BudgetService _budgetService = BudgetService();

  List<Budget> _budgets = [];
  bool _isLoading = false;
  String _errorMessage = '';
  StreamSubscription<List<Budget>>? _budgetSubscription;
  DateTime _selectedMonth = DateTime.now();

  // Getters
  List<Budget> get budgets => _budgets;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  DateTime get selectedMonth => _selectedMonth;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Set selected month
  void setSelectedMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month, 1);
    notifyListeners();
  }

  // Load budgets for a user
  void loadUserBudgets(String userId) {
    _budgetSubscription?.cancel();
    _setLoading(true);
    _setError('');

    _budgetSubscription = _budgetService
        .getUserBudgets(userId)
        .listen(
          (budgets) {
        _budgets = budgets;
        _setLoading(false);
        notifyListeners();
      },
      onError: (error) {
        _setLoading(false);
        _setError('Failed to load budgets: $error');
      },
    );
  }

  // Get budgets for current selected month
  List<Budget> get currentMonthBudgets {
    return _budgets.where((budget) {
      return budget.month.year == _selectedMonth.year &&
          budget.month.month == _selectedMonth.month;
    }).toList();
  }

  // Add a new budget
  Future<bool> addBudget({
    required String userId,
    required String category,
    required double amount,
    required DateTime month,
  }) async {
    try {
      _setLoading(true);
      _setError('');

      // Check if budget already exists for this category and month
      final existingBudget = await _budgetService.getBudgetForCategoryAndMonth(
          userId, category, month);

      if (existingBudget != null) {
        _setLoading(false);
        _setError('Budget already exists for $category in ${_getMonthName(month)}');
        return false;
      }

      final budget = Budget(
        id: '',
        userId: userId,
        category: category,
        amount: amount,
        month: DateTime(month.year, month.month, 1),
        createdAt: DateTime.now(),
      );

      await _budgetService.addBudget(budget);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to add budget: $e');
      return false;
    }
  }

  // Update a budget
  Future<bool> updateBudget(Budget budget, double newAmount) async {
    try {
      _setLoading(true);
      _setError('');

      final updatedBudget = budget.copyWith(amount: newAmount);
      await _budgetService.updateBudget(updatedBudget);

      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to update budget: $e');
      return false;
    }
  }

  // Delete a budget with immediate UI feedback
  Future<bool> deleteBudget(String budgetId) async {
    try {
      _setLoading(true);
      _setError('');

      print('DEBUG: Deleting budget: $budgetId');

      // Delete from Firestore - the real-time listener will automatically update the UI
      await _budgetService.deleteBudget(budgetId);

      print('DEBUG: Budget deleted successfully from Firestore');
      _setLoading(false);
      return true;
    } catch (e) {
      print('DEBUG: Error deleting budget: $e');
      _setLoading(false);
      _setError('Failed to delete budget: $e');
      return false;
    }
  }

  // Calculate budget progress
  Map<String, double> getBudgetProgress(Budget budget, List<FinanceTransaction> transactions) {
    final spent = transactions
        .where((t) =>
    t.type == TransactionType.expense &&
        t.category == budget.category &&
        t.date.year == budget.month.year &&
        t.date.month == budget.month.month)
        .fold(0.0, (sum, t) => sum + t.amount);

    final remaining = budget.amount - spent;
    final progress = budget.amount > 0 ? (spent / budget.amount).clamp(0.0, 1.0) : 0.0;

    return {
      'spent': spent,
      'remaining': remaining,
      'progress': progress,
    };
  }

  // Get total budget for selected month
  double get totalBudgetForMonth {
    return currentMonthBudgets.fold(0.0, (sum, budget) => sum + budget.amount);
  }

  // Get total spent for selected month
  double getTotalSpentForMonth(List<FinanceTransaction> transactions) {
    return transactions
        .where((t) =>
    t.type == TransactionType.expense &&
        t.date.year == _selectedMonth.year &&
        t.date.month == _selectedMonth.month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  String _getMonthName(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  void dispose() {
    _budgetSubscription?.cancel();
    super.dispose();
  }
}