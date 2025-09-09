// lib/utils/helpers.dart
import 'dart:ui';

import 'package:intl/intl.dart';

class AppHelpers {
  // Currency formatter
  static final currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  // Date formatter
  static final dateFormatter = DateFormat('MMM dd, yyyy');
  static final dateTimeFormatter = DateFormat('MMM dd, yyyy HH:mm');

  // Format currency amount
  static String formatCurrency(double amount) {
    return currencyFormatter.format(amount);
  }

  // Format date
  static String formatDate(DateTime date) {
    return dateFormatter.format(date);
  }

  // Format date and time
  static String formatDateTime(DateTime dateTime) {
    return dateTimeFormatter.format(dateTime);
  }

  // Get month name
  static String getMonthName(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  // Get transaction type color
  static Color getTransactionColor(String type) {
    switch (type.toLowerCase()) {
      case 'income':
        return const Color(0xFF4CAF50);
      case 'expense':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF757575);
    }
  }

  // Validate amount input
  static bool isValidAmount(String amount) {
    if (amount.isEmpty) return false;
    final parsedAmount = double.tryParse(amount);
    return parsedAmount != null && parsedAmount > 0;
  }

  // Get greeting based on time of day
  static String getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}

// Constants for the app
class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color primaryDarkColor = Color(0xFF2E7D32);
  static const Color accentColor = Color(0xFF66BB6A);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);

  // Text Styles
  static final TextStyle headingStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: primaryDarkColor,
  );

  static final TextStyle subHeadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primaryDarkColor,
  );

  static final TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF424242),
  );

  // Spacing
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  // Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
}