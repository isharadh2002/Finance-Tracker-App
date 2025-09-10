# Finance Tracker App

An application that allows users to track their personal finances, including income, expenses, budget planning, and financial insights with real-time data synchronization.

## Features

### 🔐 **User Authentication**
- **Email/Password Authentication**: Secure registration and login with email validation
- **Google Sign-In Integration**: One-click sign-in with Google accounts
- **Firebase Authentication**: Robust user management with session handling
- **Password Management**: Change password functionality for email/password accounts
- **Account Type Recognition**: Identifies Google vs email/password accounts

### 📊 **Dashboard**
- **Financial Overview**: Real-time display of total income, expenses, and available balance
- **Welcome Card**: Personalized greeting with user profile information
- **Quick Action Buttons**: Easy access to add transactions, view history, budget planning, and reports
- **Recent Transactions**: Display of last 5 transactions with edit/delete options
- **Visual Balance Card**: Gradient card showing available balance with deficit indicators

### 💰 **Transaction Management**
- **Dual Transaction Types**: Add both income and expense transactions
- **Comprehensive Categories**:
   - **Income**: Salary, Freelance, Business, Investment, Gift, Other Income
   - **Expenses**: Food & Dining, Transportation, Shopping, Entertainment, Bills & Utilities, Healthcare, Education, Travel, Groceries, Other Expense
- **Rich Transaction Details**: Amount, category, date, and description fields
- **Real-time Updates**: Immediate UI updates across all screens
- **Transaction History**: Complete list with filtering and sorting options
- **Edit & Delete**: Full CRUD operations with confirmation dialogs
- **Transaction Details**: Expandable view with complete transaction information

### 🔍 **Advanced Filtering & Search**
- **Category Filtering**: Filter transactions by specific categories or view all
- **Transaction Type Filtering**: Separate income and expense views
- **Date Range Filtering**: Custom date range selection
- **Active Filter Display**: Visual chips showing applied filters
- **Filter Persistence**: Maintains filter state during navigation
- **Quick Clear Filters**: One-click filter reset

### 📈 **Budget Planning**
- **Monthly Budget Goals**: Set spending limits for each category
- **Visual Progress Indicators**: Color-coded progress bars (green/orange/red)
- **Budget vs Actual Tracking**: Real-time comparison of budgeted vs actual spending
- **Month Navigation**: View budgets for different months
- **Budget Management**: Add, edit, and delete budget entries
- **Overall Budget Summary**: Total budget overview with spending breakdown
- **Budget Alerts**: Visual indicators when approaching or exceeding limits

### 📊 **Reports & Insights**
- **Monthly Financial Summary**: Income, expenses, and balance cards
- **Interactive Expense Breakdown Pie Chart**: Visual category distribution
- **6-Month Trend Analysis**: Line chart showing income vs expense trends over time
- **Category Analysis**: Detailed spending breakdown with progress bars and percentages
- **Month Navigation**: Historical analysis for different time periods
- **Real-time Chart Updates**: Charts automatically update with new transactions
- **Top Spending Categories**: Highlights highest expense categories

### ⚙️ **Settings & Profile Management**
- **User Profile Display**: Shows user information including name, email, and account type
- **Account Information**: Creation date and authentication method details
- **Password Management**: Change password for email/password accounts
- **Secure Sign Out**: Complete session termination with confirmation
- **App Information**: Version details and developer information

### 🔄 **Real-time Data Synchronization**
- **Live Updates**: All changes reflect immediately across screens
- **Stream Subscriptions**: Automatic UI updates when data changes in Firestore
- **Optimistic Updates**: Immediate UI feedback with error handling
- **Cross-screen Consistency**: Data synchronization across all app screens
- **Offline-ready**: Firebase Firestore offline persistence

## Technical Implementation

### **Architecture**
- **MVC Pattern**: Clean separation with Models, Services, and Providers
- **Provider State Management**: Reactive state management across the app
- **Firebase Integration**: Real-time database with Firestore
- **Material Design 3**: Modern UI components and design system

### **Key Packages**
```yaml
dependencies:
  # Core Flutter
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # Firebase Integration
  firebase_core: ^4.1.0
  firebase_auth: ^6.0.2
  cloud_firestore: ^6.0.1

  # Authentication
  google_sign_in: ^6.2.1

  # State Management
  provider: ^6.1.5+1

  # Navigation
  go_router: ^16.2.1

  # Charts & Visualization
  fl_chart: ^1.1.0

  # Utilities
  intl: ^0.20.2
  shared_preferences: ^2.5.3
  email_validator: ^3.0.0
  uuid: ^4.5.1
  equatable: ^2.0.7
```

### **Real-time Features**
- **Live Data Sync**: All changes reflect immediately across screens
- **Stream Subscriptions**: Automatic UI updates when data changes
- **Optimistic Updates**: Immediate UI feedback with error handling
- **Error Recovery**: Graceful handling of network issues

## Getting Started

### Prerequisites
- Flutter SDK (^3.9.2)
- Firebase project setup
- Android/iOS development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd finance_tracker_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [https://console.firebase.google.com](https://console.firebase.google.com)
   - Add a Flutter app to your Firebase project
   - Enable Authentication:
      - Email/Password provider
      - Google Sign-in provider
   - Enable Firestore Database with the following rules:
     ```javascript
     rules_version = '2';
     service cloud.firestore {
       match /databases/{database}/documents {
         // Users can only access their own transactions and budgets
         match /transactions/{transactionId} {
           allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
         }
         match /budgets/{budgetId} {
           allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
         }
       }
     }
     ```

4. **FlutterFire CLI Configuration** (Recommended)
   - Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
   - Run: `flutterfire configure`
   - Select your Firebase project and platforms (Android/iOS)
   - This automatically generates the required configuration files

   **Alternative Manual Configuration:**
   - Download `google-services.json` for Android (place in `android/app/`)
   - Download `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
   - The project includes `firebase_options.dart` with all platform configurations

5. **Run the app**
   ```bash
   flutter run
   ```

## Firebase Project Configuration

Your Flutter project is configured as a unified Firebase project with multi-platform support:

- **Project ID**: `finance-tracker-app-75b32`
- **Platforms Supported**: Android, iOS, Web, Windows, macOS
- **Configuration Files**:
   - `firebase.json` - FlutterFire project configuration
   - `lib/firebase_options.dart` - Generated platform-specific options
   - `android/app/google-services.json` - Android configuration
- **Authentication**: Email/Password and Google Sign-In providers enabled
- **Database**: Cloud Firestore with security rules for user data isolation

## Project Structure

```
lib/
├── models/
│   ├── transaction.dart          # Transaction data model with categories
│   └── budget.dart              # Budget data model with month tracking
├── providers/
│   ├── auth_provider.dart       # Authentication state management
│   ├── transaction_provider.dart # Transaction state with real-time updates
│   └── budget_provider.dart     # Budget state management
├── services/
│   ├── transaction_service.dart # Firestore CRUD operations for transactions
│   └── budget_service.dart      # Firestore CRUD operations for budgets
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart    # Login with email/password and Google
│   │   └── register_screen.dart # User registration
│   ├── dashboard/
│   │   └── dashboard_screen.dart # Main overview with quick actions
│   ├── transactions/
│   │   ├── add_transaction_screen.dart    # Add income/expense with tabs
│   │   ├── edit_transaction_screen.dart   # Edit existing transactions
│   │   └── transaction_history_screen.dart # List with advanced filtering
│   ├── budget/
│   │   ├── budget_screen.dart    # Budget overview with progress tracking
│   │   └── add_budget_screen.dart # Create new budget goals
│   ├── reports/
│   │   └── reports_screen.dart   # Analytics with charts and insights
│   ├── settings/
│   │   ├── settings_screen.dart  # User profile and app settings
│   │   └── change_password_screen.dart # Password management
│   └── auth_wrapper.dart        # Authentication flow controller
├── utils/
│   └── helpers.dart            # Utility functions and constants
└── main.dart                   # App entry point with theme configuration
```

## Usage Guide

### **Adding Transactions**
1. From dashboard, tap "Add Income" or "Add Expense"
2. Select transaction type using the tab bar
3. Enter amount, select category, set date, and add description
4. Save to see immediate updates across all screens

### **Budget Planning**
1. Navigate to "Budget Planning" from dashboard
2. Use month navigation to select target month
3. Tap "+" to add a new budget
4. Select category, set amount, and save
5. View real-time progress with color-coded indicators:
   - **Green**: Under 80% of budget
   - **Orange**: 80-100% of budget
   - **Red**: Over budget
6. Edit or delete budgets as needed

### **Viewing Reports**
1. Go to "Reports" from dashboard
2. Use month navigation to view different periods
3. Analyze spending patterns with:
   - **Pie Charts**: Category-wise expense breakdown
   - **Line Charts**: 6-month income vs expense trends
   - **Category Analysis**: Detailed spending with percentages

### **Managing Transactions**
1. View transaction history with advanced filtering
2. Filter by category, type, or date range
3. Edit transactions by tapping the edit icon
4. Delete transactions with confirmation dialogs
5. Use "Active Filters" to manage applied filters

### **Account Management**
1. Access settings from dashboard
2. View profile information and account details
3. Change password (for email/password accounts)
4. Sign out securely

## Key Features Highlights

### **Real-time Synchronization**
- All data changes reflect immediately across screens
- No need to refresh or restart the app
- Seamless user experience with live updates
- Automatic conflict resolution

### **Visual Analytics**
- Interactive pie charts for expense breakdown
- Monthly trend analysis with line charts
- Progress bars for budget tracking
- Color-coded indicators for quick insights

### **User-friendly Design**
- Consistent Material Design 3 components
- Intuitive navigation and user flows
- Responsive design for different screen sizes
- Accessibility considerations with proper contrast and touch targets

### **Advanced Filtering**
- Multiple filter types (category, type, date range)
- Visual filter indicators
- Persistent filter state
- Quick filter management

## Data Models

### Transaction Model
```dart
class FinanceTransaction {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final TransactionType type; // income/expense
  final DateTime createdAt;
}
```

### Budget Model
```dart
class Budget {
  final String id;
  final String userId;
  final String category;
  final double amount;
  final DateTime month;
  final DateTime createdAt;
}
```

## Security Features

- **User Isolation**: Each user can only access their own data
- **Firebase Security Rules**: Server-side data protection
- **Authentication Required**: All operations require valid authentication
- **Input Validation**: Client-side and server-side validation
- **Secure Password Handling**: Firebase handles password encryption

## Performance Optimizations

- **Real-time Listeners**: Efficient data streaming with Firestore
- **Pagination Ready**: Architecture supports future pagination implementation
- **Memory Management**: Proper disposal of resources and listeners
- **Optimized Queries**: Efficient Firestore queries with proper indexing

## Future Enhancements

- **Export Functionality**: PDF/Excel export for reports
- **Recurring Transactions**: Template-based transaction creation
- **Multiple Currencies**: Support for different currencies
- **Advanced Analytics**: More detailed financial insights
- **Spending Goals**: Achievement-based financial targets
- **Dark Mode**: Alternative UI theme
- **Notifications**: Budget alerts and reminders
- **Data Backup**: Manual backup and restore functionality

## Development Notes

This project demonstrates:
- **Clean Architecture**: MVC pattern with clear separation of concerns
- **Real-time Features**: Live data synchronization across the app
- **Modern Flutter Practices**: Material Design 3, Provider state management
- **Firebase Integration**: Authentication and Firestore database
- **User Experience**: Intuitive design with comprehensive functionality
- **Code Quality**: Well-organized, documented, and maintainable code

## Troubleshooting

### Common Issues

1. **Google Sign-In Issues**
   - Verify FlutterFire configuration: `flutterfire configure`
   - Check SHA-1 fingerprint in Firebase console
   - Ensure Google Sign-In provider is enabled in Firebase Authentication
   - Verify `firebase_options.dart` contains correct project configuration

2. **Build Errors**
   - Run `flutter clean` and `flutter pub get`
   - Check Flutter and Dart SDK versions
   - Ensure all dependencies are compatible

3. **Firebase Connection**
   - Verify internet connection
   - Check Firebase project configuration
   - Ensure Firestore rules allow authenticated access

## Support

For technical issues or questions:
- Check the troubleshooting section above
- Review Firebase documentation for authentication and Firestore
- Ensure all prerequisites are properly installed