import 'package:flutter/material.dart';
import 'package:projeto_ebac_imc/models/imc_model.dart';

class ImcController {
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();

  double resultadoImc = 0;
  ValueNotifier<bool> botaoProcessar = ValueNotifier(false);

  ImcController() {
    pesoController.addListener(() {
      _habilitaBotao();
    });
    alturaController.addListener(() {
      _habilitaBotao();
    });
  }

  void _habilitaBotao() {
    botaoProcessar.value = pesoController.value.text.isNotEmpty &&
        alturaController.value.text.isNotEmpty;
  }

  ImcModel processarIMC() {
    resultadoImc = double.tryParse(_calcularIMC().toStringAsFixed(2)) as double;

    if (resultadoImc == -999) {
      return ImcModel(peso: 0, altura: 0, mensagem: '');
    }

    var mensagemIMC = _obterMensagemIMC(resultadoImc);

    ImcModel imcModel = ImcModel(
      peso: double.parse(pesoController.value.text.replaceAll(',', '.')),
      altura: double.parse(alturaController.value.text.replaceAll(',', '.')),
      mensagem: mensagemIMC,
    );

    return imcModel;
  }

  double _calcularIMC() {
    // peso / (altura * altura)

    try {
      double pesoIMC =
          double.parse(pesoController.value.text.replaceAll(',', '.'));
      double alturaIMC =
          double.parse(alturaController.value.text.replaceAll(',', '.'));
      if (alturaIMC > 0.0 &&
          alturaIMC < 3.0 &&
          pesoIMC > 0.0 &&
          pesoIMC < 500.0) {
        double valorIMC = pesoIMC / (alturaIMC * alturaIMC);
        return valorIMC;
      }
      return -999;
    } catch (e) {
      return -999;
    }
  }

  String _obterMensagemIMC(double valorIMC) {
    if (valorIMC < 16) {
      // return 'Baixo peso muito grave = abaixo de 16 kg/m²';
      return 'Baixo peso muito grave';
    }
    if (valorIMC >= 16 && valorIMC <= 16.99) {
      // return 'Baixo peso grave = entre 16 e 16,99 kg/m²';
      return 'Baixo peso grave';
    }
    if (valorIMC >= 17 && valorIMC <= 18.49) {
      // return 'Baixo peso = entre 17 e 18,49 kg/m²';
      return 'Baixo peso';
    }
    if (valorIMC >= 18.50 && valorIMC <= 24.99) {
      // return 'Peso normal = entre 18,50 e 24,99 kg/m²';
      return 'Peso normal';
    }
    if (valorIMC >= 25 && valorIMC <= 29.99) {
      // return 'Sobrepeso = entre 25 e 29,99 kg/m²';
      return 'Sobrepeso';
    }
    if (valorIMC >= 30 && valorIMC <= 34.99) {
      // return 'Obesidade grau I = entre 30 e 34,99 kg/m²';
      return 'Obesidade grau I';
    }
    if (valorIMC >= 35 && valorIMC <= 39.99) {
      // return 'Obesidade grau II = entre 35 e 39,99 kg/m²';
      return 'Obesidade grau II';
    }
    // return 'Obesidade grau III (obesidade mórbida) = maior que 40 kg/m²';
    return 'Obesidade grau III';
  }
}
