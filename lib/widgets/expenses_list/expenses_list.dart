import 'package:expense_tracker/widgets/expenses_list/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expenses, required this.onRemove});
  final List<Expense> expenses;
  final void Function(Expense expense) onRemove;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          // margin:const EdgeInsets.symmetric(horizontal: 16,vertical: 9),
          margin: Theme.of(context).cardTheme.margin,
          color: Theme.of(context).colorScheme.error.withOpacity(0.6),
        ),
        onDismissed: (direction) {
          onRemove(expenses[index]);
        },
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}