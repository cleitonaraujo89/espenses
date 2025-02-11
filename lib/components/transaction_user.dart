import 'dart:math';
import 'package:espenses/models/transactions.dart';
import '../components/transactions_form.dart';
import '../components/transaction_list.dart';
import 'package:flutter/material.dart';

    //este componete não esta sendo usando na aplicação
    // mantido de forma didatica

class TransactionUser extends StatefulWidget {
  //const TransactionUser({super.key});

  @override
  State<TransactionUser> createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
  final _transactions = [
    Transaction(
      id: 't1',
      title: 'Novo Tênis de Corrida',
      value: 310.76,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Conta de Luz',
      value: 211.20,
      date: DateTime.now(),
    )
  ];

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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TransactionForm(_addTransaction),
        TransactionList(_transactions)
      ],
    );
  }
}
