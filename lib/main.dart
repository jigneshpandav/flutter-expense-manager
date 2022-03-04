import 'dart:io';

import 'package:demo/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import 'models/transaction.dart';
import './widgets/chart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Expenses",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: "Open Sans",
                fontSize: 20,
              ),
            ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
      id: "id${_userTransactions.length + 1}",
      title: title,
      amount: amount,
      date: date,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(int index) {
    setState(() {
      _userTransactions.removeAt(index);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      isScrollControlled: true,
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  Widget _buildCupertinoNavigationBar(String title) {
    return CupertinoNavigationBar(
        middle: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
                child: const Icon(CupertinoIcons.add),
                onTap: () => _startAddNewTransaction(context))
          ],
        ));
  }

  Widget _buildAppBar(String title) {
    return AppBar(
      title: const Text(
        "Personal expenses",
        style: TextStyle(fontFamily: 'Open Sans'),
      ),
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: const Icon(Icons.add),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = (Platform.isIOS
        ? _buildCupertinoNavigationBar("Personal expenses")
        : _buildAppBar("Personal expenses")) as PreferredSizeWidget;
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.2,
                child: Chart(_recentTransactions),
              ),
              SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.8,
                child: TransactionList(_userTransactions, _deleteTransaction),
              )
            ],
          ),
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _startAddNewTransaction(context),
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
  }
}
