import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class AdaptativeTextfield extends StatelessWidget {
  final TextEditingController controller;
  final void Function() onSubmit;
  final String label;
  final TextInputType keyboard;

  const AdaptativeTextfield({
    required this.controller,
    required this.onSubmit,
    required this.label,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CupertinoTextField(
              controller: controller,
              onSubmitted: (_) => onSubmit(),
              placeholder: label,
              keyboardType: keyboard,
              padding: const EdgeInsets.symmetric( horizontal: 6, vertical: 12),
            ),
        )
        : TextField(
            controller: controller,
            onSubmitted: (_) => onSubmit(),
            decoration: InputDecoration(labelText: label),
            keyboardType: keyboard,
          );
  }
}
