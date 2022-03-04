import 'dart:io';

import 'package:demo/widgets/adaptive_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  const NewTransaction(this.addTransaction, {Key? key}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      return;
    }

    widget.addTransaction(
      _titleController.text,
      double.parse(_amountController.text),
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (BuildContext btx) {
              return Container(
                height: 300.0,
                decoration: BoxDecoration(
                  color: CupertinoDynamicColor.resolve(
                      CupertinoColors.secondarySystemGroupedBackground, btx),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime(2021),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (pickedDate) {
                    if (pickedDate == null) {
                      return;
                    }
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  },
                ),
              );
            })
        : showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now(),
          ).then((pickedDate) {
            if (pickedDate == null) {
              return;
            }
            setState(() {
              _selectedDate = pickedDate;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
                controller: _titleController,
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _submitData,
              ),
              TextField(
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Amount",
                ),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData,
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No date choosen!'
                            : "Picked Date: ${DateFormat.yMMMd().format(_selectedDate!)}",
                      ),
                    ),
                    AdaptiveFlatButton("Choose date", _presentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text("Add Transaction"),
                onPressed: _submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
