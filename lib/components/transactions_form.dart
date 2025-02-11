import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double) onSubmit;

  TransactionForm(this.onSubmit); 

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  //const TransactionsForm({super.key});

  //atribui o que foi digitado 
  final titleController = TextEditingController();
  final valueController = TextEditingController();

  _subimitForm() {
    // pega o texto q foi digitado e atribui, no value transforma pra double
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;

    //checagem
    if (title.isEmpty || value <= 0) {
      return;
    }

    widget.onSubmit(title, value); // acessa o construtor da classe passando os parametros
  }

 //recebe uma função no cosntrutor
  @override
  Widget build(BuildContext context) {
    return Card(
      //constroi um card com 2 textfield e 1 button
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          TextField(
            controller:
              titleController, // o controller fica "escutando" o que é digitado e atualizando a variavel (modo sem atribuição)
              //o onSubmitted ativa quando a pessoa aperta entre no telhado
            onSubmitted: (_) =>
                _subimitForm(), // precisa de uma função para executar por isso a arrow function com o "_" como parametro pois se chamar a funfção direto _subimitForm() n funciona
            decoration: InputDecoration( //Placeholder
              labelText: 'Título',
            ),
          ),
          TextField(
            //onChanged: (newValue) => value = newValue, // geito com atribuição
            controller: valueController,
            //teclado numérico
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onSubmitted: (_) => _subimitForm(), //se apertar entrer...
            decoration: InputDecoration(
              labelText: 'Valor (R\$)',
            ),
          ),
          TextButton(
            onPressed: _subimitForm,
            child: Text(
              'Nova Transação',
              style: TextStyle(color: Colors.purple, fontSize: 16),
            ),
          )
        ]),
      ),
    );
  }
}
