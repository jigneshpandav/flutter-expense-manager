import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionListItem extends StatefulWidget {
  const TransactionListItem({
    required Key key,
    required this.transaction,
    required this.deleteTransaction,
    required this.index,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTransaction;
  final int index;

  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  late Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.blue,
      Colors.amber,
      Colors.deepOrange,
      Colors.brown,
    ];
    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: _bgColor,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
                child: Text(
              '\$${widget.transaction.amount.toStringAsFixed(2)}',
            )),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 380
            ? TextButton(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                    ),
                  ],
                ),
                onPressed: () => widget.deleteTransaction(widget.index),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => widget.deleteTransaction(widget.index),
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
