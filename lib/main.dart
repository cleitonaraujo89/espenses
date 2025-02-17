// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:espenses/components/chart.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; //usado para travar a orientação da tela
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
    //acessibilidade para fontes (aumentam de acordo com a configuração do usuario)
    final scaledFontSize = MediaQuery.textScalerOf(context);

    //forma de travar a orientação da tela (somente retrato)
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.purple,
          textTheme: TextTheme(
            // Tema dos Textos
            titleLarge: TextStyle(
              fontFamily: 'Caveat',
              fontWeight: FontWeight.w700,
              fontSize: scaledFontSize.scale(30),
            ),
            titleMedium: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: scaledFontSize.scale(20),
            ),
            titleSmall: TextStyle(fontSize: scaledFontSize.scale(16)),
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

  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );
    // instancia um novo objeto Transaction e pelo setState atualiza a lista adcionando um novo item e renderiza no ato
    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
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
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // coloquei a appbar em uma variavel para tar acesso ao tamanho dela
    final appBar = AppBar(
      title: const Text(
        'Despesas Pessoais',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        //se tiver paisagem mostra um novo icone na barra
        if (isLandScape)
          IconButton(
            icon: Icon(_showChart ? Icons.list : Icons.show_chart),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _showChart = !_showChart;
              });
            },
          ),
        IconButton(
          onPressed: () => _opemTransactionFormModal(context),
          icon: Icon(Icons.add),
          color: Colors.white,
        )
      ],
      centerTitle: true,
    );

    //aqui atribuo o valor da altura menos a appbar e um padding top para ter exatamente o tamanho da area disponivel
    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar, // aplicação do appBar
      // habilita o scroll na tela
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandScape) // não utiliza {} se fosse mais de um widget era 'if(cond) ...[]' exemplo abaixo no else
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text('Exibir Gráfico'),
            //       Switch(
            //         value: _showChart,
            //         onChanged: (value) {
            //           setState(() {
            //             _showChart = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            if (isLandScape)
              _showChart
                  ? SizedBox(
                      // 30% da altura no modo retrato 70% paisagem
                      height: availableHeight * (isLandScape ? 0.7 : 0.3),
                      child: Chart(_recentTransactions),
                    )
                  : SizedBox(
                      height: availableHeight * 0.7, // 70% da altura
                      child: TransactionList(_transactions, _removeTransaction),
                    )
            else ...[
              SizedBox(
                height: availableHeight * 0.3, // 30* da altura
                child: Chart(_recentTransactions),
              ),
              SizedBox(
                height: availableHeight * 0.7, // 70% da altura
                child: TransactionList(_transactions, _removeTransaction),
              )
            ]
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
