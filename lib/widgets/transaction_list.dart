import 'package:demo/widgets/transaction_list_item.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function _deleteTransaction;

  const TransactionList(this.transactions, this._deleteTransaction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 7),
        child: transactions.isEmpty
            ? Column(
                children: [
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              )
            : ListView(
                children: transactions.asMap().entries.map((e) {
                  return TransactionListItem(
                    key: ValueKey(e.value.id),
                    transaction: e.value,
                    deleteTransaction: _deleteTransaction,
                    index: e.key,
                  );
                }).toList(),
              )
        // : ListView.builder(
        //     itemBuilder: (ctx, index) {
        //       return TransactionListItem(
        //         transaction: transactions[index],
        //         deleteTransaction: _deleteTransaction,
        //         index: index,
        //         key: Key(index.toString()),
        //       );
        //     },
        //     itemCount: transactions.length,
        //   ),
        );
  }
}
