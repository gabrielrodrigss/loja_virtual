import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

// Implementação da recuperação de dados do protudos como um todo do firebase.
// É muito importante esse modelo de recuperação, para o produto sempre estar
// atualizado no carrinho.
class CartTile extends StatelessWidget {
  const CartTile({super.key, required this.cartProduct});

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {
    // Retorna o conteúdo do cartão(Card)
    Widget _buildContent() {
      // Quando carregar o preço dos produtos, vai pedir para atualizar os
      // valores no resumo do pedido
      CartModel.of(context).updatePrices();

      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              // Acessando os dados do produto(images) no productData no cartProduct
              cartProduct.productData!.images![0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cartProduct.productData!.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                  Text(
                    "Tamanho: ${cartProduct.size}",
                    style: const TextStyle(fontWeight: FontWeight.w300,),
                  ),
                  Text(
                    "R\$ ${cartProduct.productData!.price!.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: cartProduct.quantity! > 1 ? () {
                          CartModel.of(context).decProduct(cartProduct);
                        } : null,
                        color: Theme.of(context).primaryColor,
                        icon: const Icon(Icons.remove),
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        onPressed: () {
                          CartModel.of(context).incProduct(cartProduct);
                        },
                        color: Theme.of(context).primaryColor,
                        icon: const Icon(Icons.add),
                      ),
                      TextButton(
                        onPressed: () {
                          CartModel.of(context).removeCartItem(cartProduct);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[500]
                        ),
                        child: const Text("Remover"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      // Se os dados do produto for igual a nulo, esses dados deverá ser
      // recuperado do firebase dos docs produtos, na coleção products/items
      child: cartProduct.productData == null
        ? FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("products")
                .doc(cartProduct.category)
                .collection("items")
                .doc(cartProduct.pid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Converte o produto recebido do firebase em product data e o
                // armazena no productData enquanto o app estiver aberto
                cartProduct.productData =
                    ProductData.fromDocument(snapshot.data!);
                return _buildContent(); // mostra os dados
              } else {
                // Caso o productData não tenha sido carregado
                return Container(
                  height: 70.0,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
            },
          )
        : _buildContent() // Caso já tenha o productData, só mostra os dados
      );
  }
}
