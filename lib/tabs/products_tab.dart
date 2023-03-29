import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      // Obtendo todas as categorias da coleção products no firebase
      future: FirebaseFirestore.instance.collection("products").get(),
      builder: (context, snapshot) {
        // Se não contem dados, exibirá o carregamento
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
          // Casso Haja retorno dos dados, exibirá essa lista de categorias
        } else {
          // Quando não se sabe o tipo da váriavel, é só usar o var
          var dividTiles = ListTile.divideTiles( // divide todas as tiles
            // Pega cada documento no firebase e transforma em CategoryTile e
            // depois tranforma em uma lista CategoryTile.
            tiles: snapshot.data!.docs.map((doc) {
              return CategoryTile(snapshot: doc);
            }).toList(),
            color: Colors.grey[500]).toList(); // cor do divisor

          // Pega o objeto lista CategoryTile e coloca no listView
          return ListView(
              children: dividTiles,
          );
        }
      },
    );
  }
}
