import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdaptativeButton extends StatelessWidget {

  final String label;
  final void Function() onPressed;

  const AdaptativeButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
    ? CupertinoButton(onPressed: onPressed, child: Text(label)) 
    : ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}