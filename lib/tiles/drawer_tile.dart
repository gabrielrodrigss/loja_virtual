import 'package:flutter/material.dart';

// Parte da construção dos itens no drawer
class DrawerTile extends StatelessWidget {
  // Recebe os parâmetros passados na chamada da classe lá no CustomDrawer
  const DrawerTile(
      {super.key,
      required this.icon,
      required this.text,
      required this.controller,
      required this.page});

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // da um close na aba do drawer ao pular para a pagina clicada
          Navigator.of(context).pop();
          // pula para a pagina clicada
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32.0,
                // Deixa azul o item quando a pagina atual corresponder a ele
                color: controller.page!.round() == page // round() arrendonda o page em double
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              const SizedBox(
                width: 32.0,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  // Deixa azul o item quando a pagina atual corresponder a ele
                  color: controller.page!.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
