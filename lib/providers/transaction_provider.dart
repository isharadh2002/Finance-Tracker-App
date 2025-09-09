// lib/providers/transaction_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService = TransactionService();

  List<FinanceTransaction> _transactions = [];
  bool _isLoading = false;
  String _errorMessage = '';
  StreamSubscription<List<FinanceTransaction>>? _transactionSubscription;

  // Filter properties
  String _selectedCategory = 'All';
  TransactionType? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;

  // Financial summary
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  double _balance = 0.0;

  // Getters
  List<FinanceTransaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  TransactionType? get selectedType => _selectedType;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get balance => _balance;

  // Filtered transactions getter
  List<FinanceTransaction> get filteredTransactions {
    List<FinanceTransaction> filtered = List.from(_transactions);

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((t) => t.category == _selectedCategory).toList();
    }

    // Filter by type
    if (_selectedType != null) {
      filtered = filtered.where((t) => t.type == _selectedType).toList();
    }

    // Filter by date range
    if (_startDate != null && _endDate != null) {
      filtered = filtered.where((t) {
        return t.date.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
            t.date.isBefore(_endDate!.add(const Duration(days: 1)));
      }).toList();
    }

    return filtered;
  }

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

  // Load transactions for a user with proper real-time updates
  void loadUserTransactions(String userId) {
    // Cancel any existing subscription
    _transactionSubscription?.cancel();

    // Set initial loading state
    _setLoading(true);
    _setError('');

    // Create new subscription for real-time updates
    _transactionSubscription = _transactionService
        .getUserTransactions(userId)
        .listen(
          (transactions) {
        print('DEBUG: Received ${transactions.length} transactions from Firestore');
        _transactions = transactions;
        _updateFinancialSummary();
        _setLoading(false);
        notifyListeners();
      },
      onError: (error) {
        print('DEBUG: Error loading transactions: $error');
        _setLoading(false);
        _setError('Failed to load transactions: $error');
      },
    );
  }

  // Add a new transaction with immediate UI feedback
  Future<bool> addTransaction({
    required String userId,
    required double amount,
    required String category,
    required String description,
    required DateTime date,
    required TransactionType type,
  }) async {
    try {
      _setLoading(true);
      _setError('');

      final transaction = FinanceTransaction(
        id: '', // Will be set by Firestore
        userId: userId,
        amount: amount,
        category: category,
        description: description,
        date: date,
        type: type,
        createdAt: DateTime.now(),
      );

      print('DEBUG: Adding transaction: ${transaction.category} - \$${transaction.amount}');

      // Add to Firestore - the real-time listener will automatically update the UI
      await _transactionService.addTransaction(transaction);

      print('DEBUG: Transaction added successfully to Firestore');
      _setLoading(false);
      return true;
    } catch (e) {
      print('DEBUG: Error adding transaction: $e');
      _setLoading(false);
      _setError('Failed to add transaction: $e');
      return false;
    }
  }

  // Update financial summary
  void _updateFinancialSummary() {
    _totalIncome = _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    _totalExpense = _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    _balance = _totalIncome - _totalExpense;

    print('DEBUG: Financial summary updated - Income: \$${_totalIncome.toStringAsFixed(2)}, Expense: \$${_totalExpense.toStringAsFixed(2)}, Balance: \$${_balance.toStringAsFixed(2)}');
  }

  // Filter methods
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedType(TransactionType? type) {
    _selectedType = type;
    notifyListeners();
  }

  void setDateRange(DateTime? startDate, DateTime? endDate) {
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = 'All';
    _selectedType = null;
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  // Delete a transaction
  Future<bool> deleteTransaction(String transactionId) async {
    try {
      _setLoading(true);
      _setError('');

      await _transactionService.deleteTransaction(transactionId);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to delete transaction: $e');
      return false;
    }
  }

  // Get all unique categories from transactions
  List<String> get allCategories {
    final Set<String> categories = {'All'};
    for (final transaction in _transactions) {
      categories.add(transaction.category);
    }
    return categories.toList()..sort();
  }

  @override
  void dispose() {
    _transactionSubscription?.cancel();
    super.dispose();
  }
}