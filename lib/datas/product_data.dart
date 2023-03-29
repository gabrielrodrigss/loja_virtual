// Classe específica para manipular dados do firebase
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {

  // Variáveis que irão armazenar os dados dos documentos(dados do produto)
  // do firebase

  // Armazenará a categoria que o produto correponde. A categoria será setada
  // na CategoryScreen.
  String? category;
  String? id;

  String? title;
  String? description;

  double? price;

  List? images;
  List? sizes;

  // Cria-se o contrutor para receber os  dados do documentos do firebase e
  // converte-los para os dados acima(quer serão os dados do produto)
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot["title"];
    description = snapshot["description"];
    price = snapshot["price"] + 0.0;
    images = snapshot["images"];
    sizes = snapshot["sizes"];
  }

  // Resume as info do produto, para mostra só as info mais importante no carrinho
  Map<String, dynamic> toResumeMap() {
    return {
      "title" : title,
      "description" : description,
      "price" : price,
    };
  }
}