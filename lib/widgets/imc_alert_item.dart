import 'package:flutter/material.dart';

class ImcAlertItem extends StatelessWidget {
  final String descricao;
  final double valorImc;
  final Widget icon;

  const ImcAlertItem({
    super.key,
    required this.valorImc,
    required this.descricao,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
/* ListTile: criar unica linha em uma lista de rolagem
-title: texto principal na esquerda ou inicío
-trailing: widget à direita ou no final
-tileColor: cor de fundo
-leading: widget à esquerda do título e subtítulo
*/
    return ListTile(
      title: Text(
        descricao,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.green,
        ),
      ),
      trailing: Text(
        valorImc.toString().replaceAll('.', ','), // substituir todos os . por ,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.green,
        ),
      ),
      tileColor: Colors.grey.withOpacity(0.1),
      leading: icon,
    );
  }
}
