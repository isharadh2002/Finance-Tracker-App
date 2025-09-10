// lib/screens/transactions/edit_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/transaction.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';

class EditTransactionScreen extends StatefulWidget {
  final FinanceTransaction transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  late TabController _tabController;
  late TransactionType _selectedType;
  late String _selectedCategory;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing transaction data
    _amountController.text = widget.transaction.amount.toString();
    _descriptionController.text = widget.transaction.description;
    _selectedType = widget.transaction.type;
    _selectedCategory = widget.transaction.category;
    _selectedDate = widget.transaction.date;

    // Initialize tab controller
    _tabController = TabController(length: 2, vsync: this);

    // Set correct tab index: income = 1, expense = 0
    _tabController.index = _selectedType == TransactionType.income ? 1 : 0;

    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          // Tab 0 = Expense, Tab 1 = Income
          _selectedType = _tabController.index == 0
              ? TransactionType.expense
              : TransactionType.income;
          _updateCategoryForType(_selectedType);
        });
      }
    });
  }

  void _updateCategoryForType(TransactionType type) {
    // Update category list when type changes, but keep current category if valid
    final categories = type == TransactionType.income
        ? FinanceTransaction.incomeCategories
        : FinanceTransaction.expenseCategories;

    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = categories.first;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Transaction'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () => _showDeleteConfirmation(context),
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Transaction',
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          return Column(
            children: [
              // Tab Bar for Transaction Type
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFF4CAF50),
                  labelColor: const Color(0xFF4CAF50),
                  unselectedLabelColor: Colors.grey[600],
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.remove_circle_outline),
                      text: 'Expense',
                    ),
                    Tab(
                      icon: Icon(Icons.add_circle_outline),
                      text: 'Income',
                    ),
                  ],
                ),
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Amount Field
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Amount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _amountController,
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*'),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    prefixText: '\$ ',
                                    prefixStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4CAF50),
                                    ),
                                    hintText: '0.00',
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an amount';
                                    }
                                    final amount = double.tryParse(value);
                                    if (amount == null || amount <= 0) {
                                      return 'Please enter a valid amount';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Category Field
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Category',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedCategory,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  items: (_selectedType == TransactionType.income
                                      ? FinanceTransaction.incomeCategories
                                      : FinanceTransaction.expenseCategories)
                                      .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value ?? '';
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a category';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Date Field
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Color(0xFF4CAF50),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          DateFormat('MMM dd, yyyy').format(_selectedDate),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description Field
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Add a description (optional)',
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Error Message
                        if (transactionProvider.errorMessage.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              border: Border.all(color: Colors.red.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              transactionProvider.errorMessage,
                              style: TextStyle(color: Colors.red.shade700),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        // Update Transaction Button
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: transactionProvider.isLoading
                                ? null
                                : _handleUpdateTransaction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedType == TransactionType.income
                                  ? Colors.green
                                  : Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: transactionProvider.isLoading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : const Text(
                              'Update Transaction',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleUpdateTransaction() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

      if (authProvider.user == null) return;

      final success = await transactionProvider.updateTransaction(
        transactionId: widget.transaction.id,
        userId: authProvider.user!.uid,
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        type: _selectedType,
        createdAt: widget.transaction.createdAt,
      );

      if (success && context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Transaction updated successfully!',
            ),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Transaction',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          content: Text(
            'Are you sure you want to delete this transaction?\n\n'
                '${widget.transaction.category}: \$${widget.transaction.amount.toStringAsFixed(2)}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog first
                await _handleDeleteTransaction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDeleteTransaction() async {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    final success = await transactionProvider.deleteTransaction(widget.transaction.id);

    if (success && context.mounted) {
      Navigator.pop(context); // Go back to previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction deleted successfully!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}