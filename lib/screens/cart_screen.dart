import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/order_screen.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/discount_card.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';
import '../tiles/cart_tile.dart';

class CartScreem extends StatelessWidget {
  const CartScreem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Carrinho"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                // Recebe a quantidade de produtos
                int p = model.products.length;
                return Text(
                  // Se p não recebe nada, retorne 0. E se p == 1 retorne "ITEM"
                  "${p ?? 0} ${p == 1 ? 'ITEM' : 'ITENS'}",
                  style: const TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        // O carrinho terá 4 casos de exebição na tela:
        builder: (context, child, model) {
          // 1° caso: Se tiver logado ir carregando, exibirá o carregamento
          if (model.isLoading && UserModel.of(context).isLoggedIn()!) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!UserModel.of(context).isLoggedIn()!) {
            // 2° caso: Se não tiver logado, terá o butão para logar.
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Faça o login para adicionar produtos!",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            );
          } else if (model.products.isEmpty) {
            // 3° caso: Se a lista for vazia
            return const Center(
              child: Text(
                "Nenhum produto no carrinho!",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            // 4° Caso: Mostrar os produtos na tela
            return ListView(
              children: [
                Column(
                  // Coloca os filhos via código alinhados em uma coluna
                  // Mapeia a lista de produtos no carrinho e transforma em CartTile()
                  children: model.products.map((product) {
                    return CartTile(
                      cartProduct: product,
                    );
                  }).toList(),
                ),
                const DiscountCard(),
                const ShipCard(),
                CartPrice(buy: () async {
                  String? orderId = await model.finishOrder();
                  if (orderId != null) {
                    // Subistitui a tela de carrinho pela tela de pedido
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => OrderScreen(orderId: orderId),
                      ),
                    );
                  }
                })
              ],
            );
          }
        },
      ),
    );
  }
}
