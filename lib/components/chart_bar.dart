// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  //const ChartBar({super.key});
  //final Map <String, Object> dayAndValue;

  final String label;
  final double value;
  final double percentage;

  ChartBar({
    required this.label,
    required this.value,
    required this.percentage,
  });
  // ChartBar(this.dayAndValue);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20,
          child: FittedBox(
            child: Text(value.toStringAsFixed(2)),
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 60,
          width: 10,
          child: Stack(
            // coloca itens um em cima de outro
            alignment: Alignment
                .bottomCenter, // alinha para que o gráfico seja de baixo para cima
            children: [
              Container(
                // 1º item
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                // 2° item
                heightFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
