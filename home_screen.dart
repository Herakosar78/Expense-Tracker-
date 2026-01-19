import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];
  double _budget = 5000;

  void _addExpense(String title, double amount, String category) {
    final expense = Expense(
      title: title,
      amount: amount,
      date: DateTime.now(),
      category: category,
    );

    setState(() {
      _expenses.add(expense);
    });
  }

  void _deleteExpense(String id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });
  }

  double get _totalBalance {
    return _budget - _totalExpenses;
  }

  double get _totalExpenses {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  void _showBudgetDialog(BuildContext context) {
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Update Budget'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: budgetController,
              decoration: InputDecoration(
                labelText: "Budget Amount",
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 18),
            Text(
              "Current Budget: \$${_budget.toStringAsFixed(2)}",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (budgetController.text.isNotEmpty) {
                setState(() {
                  _budget = double.parse(budgetController.text);
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Budget updated successfully"),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    String selectedCategory = 'Shopping';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Add New Expense",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title Text",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: "Budget Amount",
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: ['Shopping', 'Food & Drinks', 'Transportation', 'Bills']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    _addExpense(
                      titleController.text,
                      double.parse(amountController.text),
                      selectedCategory,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Add Expense'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double spentPercentage = (_totalExpenses / _budget).clamp(0.0, 1.0);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showBudgetDialog(context),
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${_totalBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Budget: \$${_budget.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${(spentPercentage * 100).toStringAsFixed(1)}% Spent",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: spentPercentage,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            spentPercentage > 0.9
                                ? Colors.redAccent
                                : spentPercentage > 0.7
                                ? Colors.orange
                                : Colors.green,
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.greenAccent),
                          SizedBox(width: 8),
                          Text(
                            'Budget',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '\$${_budget.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.arrow_downward, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text(
                            'Expenses',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '\$${_totalExpenses.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),),
            Expanded(
                child: _expenses.isEmpty? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          color: Colors.grey,
                          size: 65),
                      SizedBox(height: 16,),
                      Text("No Expenses Yet",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey
                        ),),
                    ],
                  ),
                ):
                ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _expenses.length,
                  itemBuilder: (context,index){
                    final expense = _expenses[_expenses.length-1 - index];
                    return Dismissible(
                      key: Key(expense.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        color: Colors.redAccent,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction){
                        _deleteExpense(expense.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Expense Deleted"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.only(bottom: 10),
                        elevation: 0.5,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[50],
                            child: Icon(
                              color:Colors.blueAccent,
                              expense.category == 'Shopping' ? Icons.shopping_bag:
                              expense.category == 'Food & Drink' ? Icons.fastfood:
                              expense.category == 'Transportation' ? Icons.directions_car:
                              expense.category == 'Food & Drink' ? Icons.fastfood: Icons.receipt,
                            ),
                          ),
                          title: Text(
                            expense.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(DateFormat('MM_ dd_yyyy').format(expense.date),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Text(
                              '-\$${expense.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ),
                      ),
                    );
                  },
                )
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: _showAddExpenseDialog,
        elevation: 2,
        child: Icon(Icons.add),
      ),

    );
  }
}