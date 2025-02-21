import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class AdaptativeDatePicker extends StatelessWidget {

  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const AdaptativeDatePicker({required this.selectedDate,required this.onDateChanged});
 
  _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024), // data mais antiga acessível (1/1/2024)
      lastDate: DateTime.now(), // até a data de hj
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      onDateChanged(pickedDate);
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS 
    ? SizedBox(
      height: 180,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime.now(),
        minimumDate: DateTime(2024),
        maximumDate: DateTime.now(),
        onDateTimeChanged: onDateChanged),
    )

    : SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data Selecionada ${DateFormat('d/M/y').format(selectedDate)}',
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Selecionar Data',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    onPressed: () => _showDatePicker(context),
                  )
                ],
              ),
            );
  }
}