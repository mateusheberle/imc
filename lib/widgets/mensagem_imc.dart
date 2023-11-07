import 'package:flutter/material.dart';

import '../models/imc_model.dart';

class MensagemIMC extends StatelessWidget {
  final ImcModel imcModel;

  const MensagemIMC({
    super.key,
    required this.imcModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Text(
          imcModel.mensagem,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.green,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
