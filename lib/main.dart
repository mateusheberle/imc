import 'package:flutter/material.dart';
import 'package:projeto_ebac_imc/views/imc_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMC EBAC',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ImcPage(),
    );
  }
}
/*
animação implicita
- não se preocupa com a codificação
- widget preparado para receber parâmetros

animação controladas (explicitas)
- aquelas que você customiza

https://lottiefiles.com/
*/