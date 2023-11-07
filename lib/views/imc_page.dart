import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projeto_ebac_imc/controllers/imc_controller.dart';
import 'package:projeto_ebac_imc/models/imc_model.dart';

import '../widgets/alert_title.dart';
import '../widgets/imc_alert_item.dart';
import '../widgets/mensagem_imc.dart';

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});

  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> with SingleTickerProviderStateMixin {
  final Duration _duration = const Duration(milliseconds: 500);

  ImcController imcController = ImcController();

/* AnimationController: controla a animação
pausar, buscar, parar e reverter a animação
definir duração e comprimento da animação
*/
  late AnimationController _animationController;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<Size> _sizeAnimation;

// executar ao iniciar a tela
  @override
  void initState() {
    super.initState();
// inicia o controller da animação
    _animationController = AnimationController(
      duration: _duration,
      vsync: this,
    );

/* adiciona um listener para a animação
quando a animação for completada, chama o showDialog
*/
    _animationController.addListener(() async {
      if (_animationController.isCompleted) {
        await Future.delayed(_duration);
        _animationController.reverse();
        // await Future.delayed(_duration);
        callShowDialog(context);
      }
    });

// animação do Alignment
    _alignmentAnimation = AlignmentTween(
      begin: Alignment.bottomCenter,
      end: Alignment.center,
    ).animate(_animationController);

// animação do Size
    _sizeAnimation = Tween(begin: const Size(0, 0), end: const Size(300, 300))
        .animate(_animationController);
  }

// elimina a memória usada
  @override
  void dispose() {
    imcController.pesoController.dispose();
    imcController.alturaController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  final FocusNode _pesoFocusNode = FocusNode();
  final FocusNode _alturaFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: imcController.pesoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        isDense: true,
                        filled: false,
                        contentPadding: EdgeInsets.all(8),
                        label: Text('Peso (Kg)'),
                        hintText: 'Informe seu peso (Kg)',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      focusNode: _pesoFocusNode,
                      onSubmitted: (value) {
                        _pesoFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_alturaFocusNode);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextField(
                      controller: imcController.alturaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        isDense: true,
                        filled: false,
                        contentPadding: EdgeInsets.all(8),
                        label: Text('Altura (m)'),
                        hintText: 'Informe sua altura (m)',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      focusNode: _alturaFocusNode,
                      onSubmitted: (value) {
                        _alturaFocusNode.unfocus();
                        _animationController.forward();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Row(
                children: [
                  Expanded(
                    /* ValueListenableBuilder: reconstruir a interface com base na alteração */
                    child: ValueListenableBuilder<bool>(
                      valueListenable: imcController.botaoProcessar,
                      builder: (context, value, _) {
                        return ElevatedButton(
                          onPressed: !value
                              ? null
                              : () {
                                  // fechar teclado
                                  FocusScope.of(context).unfocus();
                                  _animationController.forward();
                                },
                          child: const Text('Processar IMC'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Align(
                  alignment: _alignmentAnimation.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      // color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                    width: _sizeAnimation.value.width,
                    height: _sizeAnimation.value.height,
                    child: Lottie.asset('assets/check.json'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> callShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        ImcModel imcModel = imcController.processarIMC();
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32),
            ),
          ),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
          titlePadding: const EdgeInsets.symmetric(horizontal: 0),
          title: const AlertTitle(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
          ),
          content: imcController.resultadoImc == -999
              ? const Center(
                  heightFactor: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 30,
                        color: Colors.green,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Os dados não foram \ninformados corretamente',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImcAlertItem(
                      icon: const Icon(
                        Icons.scale,
                        size: 30,
                        color: Colors.green,
                      ),
                      descricao: 'Peso',
                      valorImc: imcModel.peso,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    ImcAlertItem(
                      icon: const Icon(
                        Icons.height,
                        size: 30,
                        color: Colors.green,
                      ),
                      descricao: 'Altura',
                      valorImc: imcModel.altura,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    ImcAlertItem(
                      icon: const Icon(
                        Icons.show_chart_outlined,
                        size: 30,
                        color: Colors.green,
                      ),
                      descricao: 'IMC',
                      valorImc: imcController.resultadoImc,
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    MensagemIMC(imcModel: imcModel)
                  ],
                ),
          // actions: [
          //   TextButton(
          //     style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.all(
          //         Colors.green.withOpacity(0.1),
          //       ),
          //     ),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //       // remover o foco do campo / esconde teclado
          //       FocusManager.instance.primaryFocus?.unfocus();
          //     },
          //     child: const Icon(Icons.close),
          //   ),
          //   // TextButton(
          //   //   onPressed: () {
          //   //     Navigator.of(context).pop();
          //   //   },
          //   //   child: const Icon(Icons.face),
          //   // ),
          // ],
        );
      },
    );
  }
}
