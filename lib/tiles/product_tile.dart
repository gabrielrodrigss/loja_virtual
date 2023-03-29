import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';

import '../screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.type, required this.product});

  final String type;
  final ProductData product;

  @override
  Widget build(BuildContext context) {
    // A diferença do InkWell para o GestorDetecto é a animação ao tocar no widget
    return InkWell(
      onTap: () {
        // Abri a tela especíca para um produto
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProductScreen(product: product,))
        );
      },
      child: Card(
        child: type == "grid"
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                      product.images![0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            product.title!,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          // toStringAsFixed fixa 2 casas decimais
                          Text(
                            "R\$ ${product.price!.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  // Divide o card meio a meio para imagem e para info do produto
                  Flexible(
                    flex: 1,
                    child: Image.network(
                      product.images![0],
                      fit: BoxFit.cover,
                      height: 250.0,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title!,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          // toStringAsFixed fixa 2 casas decimais
                          Text(
                            "R\$ ${product.price!.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
