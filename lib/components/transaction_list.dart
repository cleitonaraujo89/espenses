import 'package:espenses/components/transaction_item.dart';
import 'package:flutter/material.dart';
import '../models/transactions.dart';


class TransactionList extends StatelessWidget {
  // const TransactionList({super.key});

  final List<Transaction> transactions;
  final void Function(String) onRemove;

  const TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                // se a lista de transações estiver vazia mostra essa coluna com imagem
                children: [
                  SizedBox(height: constraints.minHeight * 0.05),
                  Text(
                    'Nenhuma Transação Cadastrada!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: constraints.minHeight * 0.05),
                  SizedBox(
                    height: constraints.minHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        // caso contrario mostra o ListView
        : ListView.builder(
            itemCount: transactions.length, //contagem de itens
            itemBuilder: (ctx, index) {
              // vai executar essa lógica para cada item
              final tr = transactions[index]; //recebe os dados da transação

              //retorna um card
              return TransactionItem(tr: tr, onRemove: onRemove);
            },
            // children: transactions.map((tr) {
            //   // cada transação na lista é um card

            // }).toList(), // converde o map pra lista
          );
  }
}


