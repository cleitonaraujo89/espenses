import 'package:espenses/models/transactions.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  //const Chart({super.key});

  final List<Transaction> recentTransaction;

  const Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactions {
    //monta uma lista com 7 elementos [0 - 6] e executaa logica para cada um dos itens ou seja no fim
    // teremos uma lista como esse exemplo [{day: T, value: 0.0}, {day: M, value: 154.50}, ...]
    return List.generate(7, (index) {
      //atribui a data de hoje menos a quantidade de dias segundo a posição do index
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      //checagem da data de cada item na lista de transações e fazendo a soma de valores no mesmo dia
      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
        }
      }

      //print(DateFormat.E().format(weekDay)[0]);
      // print(totalSum);

      //retorna o objeto contendo a primeira letra do dia e o valor total da soma
      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList(); // invertendo a ordem de apresentação
  }

  double get _weekTotalValue {
    // itera sobre cada item somando o valor
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    // groupedTransactions;
    // final List test = groupedTransactions;
    // print(test);

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: tr['day'].toString(),
                value: tr['value'] as double,
                percentage: _weekTotalValue == 0
                    ? 0
                    : (tr['value'] as double) / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
