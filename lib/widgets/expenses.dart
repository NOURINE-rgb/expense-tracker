import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expenses = [
    Expense(
      title: 'Course Flutter',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

















  void _addExpenseOverlay() {
    showModalBottomSheet(
      constraints:const  BoxConstraints(minWidth: double.infinity),
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAdd: addExpense,
      ),
    );
  }

  void addExpense(
      String title1, double amount1, DateTime date1, Category category1) {
    setState(() {
      _expenses.add(Expense(
          title: title1, amount: amount1, date: date1, category: category1));
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _expenses.indexOf(expense);
    setState(() {
      _expenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Expense deleted'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _expenses.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expenses found, Start adding some!'),
    );
    if (_expenses.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _expenses,
        onRemove: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _addExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body:width < 500 
      ? Column(
              children: [
                Chart(expenses: _expenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _expenses)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
