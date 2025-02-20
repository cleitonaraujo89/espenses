// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'adaptative_button.dart';
import 'adaptative_textfield.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  const TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  //const TransactionsForm({super.key});

  //atribui o que foi digitado
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _subimitForm() {
    // pega o texto q foi digitado e atribui, no value transforma pra double
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    //checagem
    if (title.isEmpty || value <= 0) {
      return;
    }

    // acessa o construtor da classe passando os parametros
    widget.onSubmit(title, value, _selectedDate);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024), // data mais antiga acessível (1/1/2024)
      lastDate: DateTime.now(), // até a data de hj
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  //recebe uma função no cosntrutor
  @override
  Widget build(BuildContext context) {
    //adiciona scrol no card acima do teclado
    return SingleChildScrollView(
      child: Card(
        //constroi um card com 2 textfield e 1 button
        elevation: 5,
        child: Padding(
          //padding botton 10 px acima do teclado quando aberto
          padding: EdgeInsets.only(
            right: 10,
            top: 10,
            left: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(children: [
            AdaptativeTextfield(
              controller: _titleController,
              // o controller fica "escutando" o que é digitado e atualizando a variavel (modo sem atribuição)
              //o onSubmitted ativa quando a pessoa aperta enter no telhado
              onSubmit: _subimitForm,
              // precisa de uma função para executar por isso a arrow function com o "_" como parametro pois se chamar a funfção direto _subimitForm() n funciona
              label: 'Título',
            ),
            AdaptativeTextfield(
              //onChanged: (newValue) => value = newValue, // geito com atribuição
              controller: _valueController,
              onSubmit:_subimitForm, //se apertar entrer...              
              label: 'Valor (R\$)',
              //teclado numérico
              keyboard: TextInputType.numberWithOptions(decimal: true),              
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Data Selecionada ${DateFormat('d/M/y').format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: Text(
                      'Selecionar Data',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AdaptativeButton(
                  onPressed: _subimitForm,
                  label: 'Nova Transação',
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
