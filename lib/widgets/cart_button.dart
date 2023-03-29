import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  const CartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CartScreem())
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.shopping_cart, color: Colors.white,),
    );
  }
}
