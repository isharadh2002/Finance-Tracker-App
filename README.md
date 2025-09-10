# Finance Tracker App

An application that allows users to track their personal finances, including income, expenses, budget planning, and financial insights.

## Features

### 🔐 **User Authentication**
- Email/Password registration and login
- Google Sign-In integration
- Firebase Authentication

### 📊 **Dashboard**
- Financial overview with total income, expenses, and balance
- Recent transactions display
- Quick action buttons for easy navigation

### 💰 **Transaction Management**
- Add income and expense transactions
- Categorized transactions with predefined categories
- Transaction history with filtering options
- Real-time data synchronization

### 📈 **Budget Planning**
- Set monthly budget goals by category
- Visual progress indicators showing budget vs actual spending
- Color-coded alerts (green/orange/red based on usage percentage)
- Month navigation to view different periods
- Add, edit, and delete budget functionality
- Real-time budget tracking with immediate updates

### 📊 **Reports & Insights**
- Monthly financial summary cards
- **Expense Breakdown Pie Chart**: Visual breakdown by category
- **6-Month Trend Line Chart**: Income vs Expense trends over time
- **Category Analysis**: Detailed spending breakdown with progress bars
- Month navigation for historical analysis
- Real-time chart updates based on transaction changes

## Technical Implementation

### **Architecture**
- **MVC Pattern**: Clean separation with Models, Services, and Providers
- **Provider State Management**: Reactive state management across the app
- **Firebase Integration**: Real-time database with Firestore
- **Material Design 3**: Modern UI components and design system

### **Key Packages**
- `firebase_core` & `firebase_auth`: Authentication
- `cloud_firestore`: Real-time database
- `provider`: State management
- `fl_chart`: Charts and data visualization
- `google_sign_in`: Google authentication
- `intl`: Date formatting

### **Real-time Features**
- **Live Data Sync**: All changes reflect immediately across screens
- **Stream Subscriptions**: Automatic UI updates when data changes
- **Optimistic Updates**: Immediate UI feedback with error handling

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
    - Enable Authentication (Email/Password and Google)
    - Enable Firestore Database
    - Download configuration files:
        - `google-services.json` for Android
        - `GoogleService-Info.plist` for iOS
    - Place them in the appropriate directories

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── models/
│   ├── transaction.dart       # Transaction data model
│   └── budget.dart           # Budget data model
├── providers/
│   ├── auth_provider.dart    # Authentication state management
│   ├── transaction_provider.dart # Transaction state management
│   └── budget_provider.dart  # Budget state management
├── services/
│   ├── transaction_service.dart # Firestore operations for transactions
│   └── budget_service.dart   # Firestore operations for budgets
├── screens/
│   ├── auth/                 # Login and registration screens
│   ├── dashboard/            # Main dashboard screen
│   ├── transactions/         # Transaction management screens
│   ├── budget/              # Budget planning screens
│   └── reports/             # Reports and analytics screens
├── utils/
│   └── helpers.dart         # Utility functions
└── main.dart               # App entry point
```

## Usage

### **Adding Transactions**
1. From dashboard, tap "Add Income" or "Add Expense"
2. Fill in amount, category, date, and description
3. Save to see immediate updates across all screens

### **Budget Planning**
1. Navigate to "Budget Planning" from dashboard
2. Tap "+" to add a new budget
3. Select category, set amount, and choose month
4. View progress with visual indicators
5. Edit or delete budgets as needed

### **Viewing Reports**
1. Go to "Reports" from dashboard
2. Use month navigation to view different periods
3. Analyze spending patterns with:
    - Pie charts for category breakdown
    - Line charts for monthly trends
    - Category analysis with spending details

## Key Features Highlights

### **Real-time Synchronization**
- All data changes reflect immediately across screens
- No need to refresh or restart the app
- Seamless user experience with live updates

### **Visual Analytics**
- Interactive pie charts for expense breakdown
- Monthly trend analysis with line charts
- Progress bars for budget tracking
- Color-coded indicators for quick insights

### **User-friendly Design**
- Consistent Material Design 3 components
- Intuitive navigation and user flows
- Responsive design for different screen sizes
- Accessibility considerations

## Future Enhancements

- Export reports to PDF/Excel
- Recurring transaction templates
- Multiple currency support
- Advanced filtering and search
- Spending goals and achievements
- Dark mode support

## Development Notes

This project was developed as an internship selection task, focusing on:
- Clean, maintainable code architecture
- Real-time data synchronization
- User-friendly interface design
- Comprehensive financial tracking features

The implementation emphasizes simplicity while providing powerful functionality for personal finance management.