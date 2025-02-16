// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import '../models/transactions.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  // const TransactionList({super.key});

  final List<Transaction> transactions;
  final void Function(String) onRemove;

  TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
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
        // caso contrario mostra o ListView
        : ListView.builder(
            itemCount: transactions.length, //contagem de itens
            itemBuilder: (ctx, index) {
              // vai executar essa lógica para cada item
              final tr = transactions[index]; //recebe os dados da transação
    
              //retorna um card
              return Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: Container(
                    //antes era o CircleAvatar com backgroundColor: e radius: 30
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.primary,
                    ),
    
                    child: Padding(
                      padding: const EdgeInsets.all(11),
                      child: FittedBox(
                        child: Text(
                          'R\$${tr.value.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
    
                  //Titulo da transação
                  title: Text(
                    tr.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
    
                  //Subtitulo com data
                  subtitle: Text(
                    DateFormat('d / MM / y').format(tr.date),
                  ),
    
                  //icone para remoção
                  trailing: IconButton(
                    onPressed: () => onRemove(tr.id),
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              );
            },
            // children: transactions.map((tr) {
            //   // cada transação na lista é um card
    
            // }).toList(), // converde o map pra lista
          );
  }
}
