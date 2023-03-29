import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';

import '../screens/login_screen.dart';
import '../tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()!) {
      // Precisa-se do uid para obter o pedidos no perfil do usuário
      String uid = UserModel
          .of(context)
          .firebaseUser!
          .uid;

      // Retorna query(lista) de documentos(Pedidos) do usuários da coleção orders
      return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("users")
            .doc(uid)
            .collection("orders")
            .get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          } else {
            return ListView(
              // Pegando os documentos do firebase e transformando em OrderTile e depois em lista.
              // O doc.id é o id do pedido no doc users, que vai obter as info do produto na coleção orders
              children: snapshot.data!.docs.map((doc) => OrderTile(orderId: doc.id,)).toList(),
            );
          }
        },
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_list,
              size: 80.0,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Faça o login para acompanhar!",
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
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
              ),
              child: const Text(
                "Entrar",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      );
    }
  }
}
