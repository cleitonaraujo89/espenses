// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:espenses/components/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; //usado para travar a orientação da tela
import 'components/transaction_list.dart';
import 'components/transactions_form.dart';
import './models/transactions.dart';
import 'dart:math';
import 'dart:io';

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
            fontSize: 30,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: scaledFontSize.scale(20),
          ),
          titleSmall: TextStyle(
            fontSize: scaledFontSize.scale(14),
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          // Tema da AppBar
          backgroundColor: Colors.purple,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
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

  Widget _getIconButton(IconData icon, void Function() fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(icon: Icon(icon), color: Colors.white, onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    //variaveis para contole do MediaQuery e orientação
    final mediaQuery = MediaQuery.of(context);
    bool isLandScape = mediaQuery.orientation == Orientation.landscape;

    final actions = [
      //se tiver paisagem mostra um novo icone na barra
      if (isLandScape)
        _getIconButton(
          _showChart ? Icons.list : Icons.show_chart,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _opemTransactionFormModal(context),
      )
    ];

    // coloquei a appbar em uma variavel para tar acesso ao tamanho dela
    final PreferredSizeWidget appBarAndrod = AppBar(
      title: const Text(
        'Despesas Pessoais',
        style: TextStyle(color: Colors.white),
      ),
      actions: actions,
      centerTitle: true,
    );

    final ObstructingPreferredSizeWidget appBarIOS = CupertinoNavigationBar(
      middle: Text('Despesas Pessoais'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
    );

    //aqui atribuo o valor da altura menos a appbar e um padding top para ter exatamente o tamanho da area disponivel
    final availableHeight = mediaQuery.size.height -
        appBarAndrod.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (isLandScape) // não utiliza {} se fosse mais de um widget era 'if(cond) ...[]' exemplo abaixo no else
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text('Exibir Gráfico'),
            //     //swirch nativo de cada aparelho
            //     Switch.adaptive(
            //       value: _showChart,
            //       activeColor: Theme.of(context).primaryColor,
            //       onChanged: (value) {
            //         setState(() {
            //           _showChart = value;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            if (isLandScape)
              _showChart
                  ? SizedBox(
                      // 30% da altura no modo retrato 80% paisagem
                      height: availableHeight * (isLandScape ? 0.8 : 0.3),
                      child: Chart(_recentTransactions),
                    )
                  : SizedBox(
                      height: availableHeight *
                          (isLandScape ? 1 : 0.7), // 100% land ou 70% port
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
          ], // children column body
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBarIOS,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBarAndrod, // aplicação do appBar
            // habilita o scroll na tela
            body: bodyPage,
            //chegando a plataforma antes de apresentar conteudo
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _opemTransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
