import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

// Construção da tela inicial que será chamada na HomeScreen()
class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Função responsável por definir o degradê na tela inicial
    Widget _buildBodyBack() => Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168)
              ],
                  // Definido onde o gradiente de cor começa e termina
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
        );

    // Utilizando o stack, é possível colocar o conteúdo acima do gradiente(Ou tela)
    return Stack(
      children: [
        _buildBodyBack(),
        CustomScrollView(
          slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("home")
                    .orderBy("pos")
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return SliverGrid(
                      gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        repeatPattern: QuiltedGridRepeatPattern.inverted,
                        // Pega cada um dos documentos e seus tamanhos e transformam
                        // em QuiletedGridTile e concvertes eles em uma lista
                        pattern: snapshot.data!.docs.map((doc) {
                          return QuiltedGridTile(doc['x'], doc['y']);
                        }).toList(),
                      ),
                      // delegate entrega os itens que são as imagens
                      delegate: SliverChildBuilderDelegate(
                        childCount: snapshot.data!.docs.length,
                        (context, index) => FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: snapshot.data!.docs[index]['image'],
                          fit: BoxFit.cover,
                        )
                      ),
                    );
                  }
                }),
          ],
        )
      ],
    );
  }
}
