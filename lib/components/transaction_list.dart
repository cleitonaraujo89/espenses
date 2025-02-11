import 'package:flutter/material.dart';
import '../models/transactions.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  // const TransactionList({super.key});

  final List<Transaction> transactions;

  TransactionList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          400, // um conteiner com 400px com scroll individual, sem isso o ListView buga
      child: transactions.isEmpty
          ? Column(
              // se a lista de transações estiver vazia mostra essa coluna com imagem
              children: [
                SizedBox(height: 20),
                Text(
                  'Nenhuma Transação Cadastrada!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              // caso contrario mostra o ListView
              itemCount: transactions.length, //contagem de itens
              itemBuilder: (ctx, index) {
                // vai executar essa lógica para cada item
                final tr = transactions[index];

                //retorna um card
                return Card(
                  child: Row(// e cada card tem comportamento de linha
                      children: [
                    // que possui um conteiner e uma coluna
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'R\$ ${tr.value.toStringAsFixed(2)}', //2 casas decimais
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Column(
                        //alinhamento a esquerda
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //os itens da colula começam a diteira e temos 2 textos
                            tr.title,
                            style: const TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('d / MM /y').format(tr.date),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ]),
                  ]),
                );
              },
              // children: transactions.map((tr) {
              //   // cada transação na lista é um card

              // }).toList(), // converde o map pra lista
            ),
    );
  }
}
