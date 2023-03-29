import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';

import '../tiles/product_tile.dart';

// Tela de Produtos
// Essa tela será chamdada lá na CategoryTile, para abertura das paginas
class CategoryScreen extends StatelessWidget {
  // O construtor recebe o id e o título da categoria
  const CategoryScreen({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot["title"]),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.grid_on),),
              Tab(icon: Icon(Icons.list),)
            ],
          ),
        ),
        // O QuerySnpashot é a fotografia de uma coleção de documentos, podendo
        // acessar qualquer um documento(DocumentoSnapshot) dessa coleção
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection("products")
              .doc(snapshot.id).collection("items").get(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(),);
              } else {
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // Carrega os produto conforme rola para baixo
                    GridView.builder(
                      padding: EdgeInsets.all(4.0),
                      // GridDelegate: quantidade de itens na horizontal
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        // Pega a largura divido pela altura do item(Produto)
                        childAspectRatio: 0.65
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // Passa cada documento recebido do firebase através do
                        // index, transforma em um ProductData.
                        ProductData data = ProductData.fromDocument(snapshot.data!.docs[index],);
                        // O this é usado para fazer refêrencia a um produto da categoria,
                        // pq temos 2 snapshot, o outro é referente a cada produto da categoria,
                        // o this busca a váriavel da classe referente ao produto
                        data.category = this.snapshot.id;
                        return ProductTile(type: "grid", product: data,);
                      },
                    ),
                    ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // Passa cada documento recebido do firebase através do
                        // index, transforma em um ProductData.
                        ProductData data = ProductData.fromDocument(snapshot.data!.docs[index],);
                        data.category = this.snapshot.id;
                        return ProductTile(type: "list", product: data);
                      },
                    ),
                  ],
                );
              }
            }
        ),
      ),
    );
  }
}
