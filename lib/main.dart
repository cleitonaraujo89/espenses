import 'package:espenses/components/chart.dart';
import 'package:flutter/material.dart';
//import '../components/transaction_user.dart';
import 'components/transaction_list.dart';
import 'components/transactions_form.dart';
import './models/transactions.dart';
import 'dart:math';

void main() {
  runApp(ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.purple,
          textTheme: const TextTheme(
            // Tema dos Textos
            titleLarge: TextStyle(
              fontFamily: 'Caveat',
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
            titleMedium: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          appBarTheme: const AppBarTheme(
            // Tema da AppBar
            backgroundColor: Colors.purple,
            // titleTextStyle: TextStyle(
            //   fontFamily: 'Caveat',
            //   fontWeight: FontWeight.w700,
            //   fontSize: 30,
            // )
          )
          // para adicionar fontes basta habilitalas no pubspec.yaml
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  //const MyHomePage({super.key});

  final List<Transaction> _transactions = [
    Transaction(
      id: 't0',
      title: 'Novo teste',
      value: 510.00,
      date: DateTime.now().subtract(Duration(days: 33)),
    ),
    Transaction(
      id: 't1',
      title: 'Novo Tênis de Corrida',
      value: 310.76,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: 't2',
      title: 'Conta de Luz',
      value: 211.20,
      date: DateTime.now().subtract(Duration(days: 4)),
    ),
    Transaction(
      id: 't3',
      title: 'Conta de agua',
      value: 48.80,
      date: DateTime.now().subtract(Duration(days: 4)),
    )
  ];

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        title: title,
        value: value,
        date: DateTime.now());
    // instancia um novo objeto Transaction e pelo setState atualiza a lista adcionando um novo item e renderiza no ato
    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _opemTransactionFormModal(BuildContext context) {
    //abre o modal
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Despesas Pessoais',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _opemTransactionFormModal(context),
            icon: Icon(Icons.add),
            color: Colors.white,
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // habilita o scroll na tela
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(_recentTransactions),

            TransactionList(_transactions)
            //TransactionUser(), // ativação antes do modal
            // Column(
            //   children: [
            //     //  TransactionForm(_addTransaction),
            //     //TransactionList(_transactions)
            //   ],
            // )
          ], // children column body
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _opemTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
