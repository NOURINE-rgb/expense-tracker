import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAdd});
  final void Function(
      String title1, double amount1, DateTime date1, Category category1) onAdd;
  @override
  State<StatefulWidget> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _datePicker;
  Category? _category = Category.leisure;
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 1, now.month, now.day);
    final dataPicker = await showDatePicker(
        context: context, initialDate: now, firstDate: first, lastDate: now);
    setState(() {
      _datePicker = dataPicker;
    });
  }

  void _storeCatgeory(Category value) {
    setState(() {
      _category = value;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (amountIsInvalid ||
        _titleController.text.trim().isEmpty ||
        _datePicker == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'please make sure a valid title, amount, data and category was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okey'),
            ),
          ],
        ),
      );
      return;
    } else {
      setState(() {
        widget.onAdd(
            _titleController.text, enteredAmount, _datePicker!, _category!);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 50, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if(width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Expanded(
                       child: TextField(
                                           controller: _titleController,
                                           maxLength: 50,
                                           decoration: const InputDecoration(
                        label: Text('Title'),
                                           ),
                                         ),
                     ),
                    const SizedBox(
                        width: 24,
                      ),
                   Expanded(  
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(),
                          controller: _amountController,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                  ],)
                  else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if(width > 600)
                  Row(
                    children: [
                     DropdownButton(
                        value: _category,
                        items: Category.values
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          _storeCatgeory(value!);
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _datePicker == null
                                  ? 'No Selected Date'
                                  : formatter.format(_datePicker!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                      else
                    Row(children: [
                      Expanded(
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(),
                          controller: _amountController,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _datePicker == null
                                  ? 'No Selected Date'
                                  : formatter.format(_datePicker!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                  if(width < 600)
                      DropdownButton(
                        value: _category,
                        items: Category.values
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          _storeCatgeory(value!);
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save expense'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
