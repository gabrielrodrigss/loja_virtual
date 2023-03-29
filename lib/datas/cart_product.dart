// Observação: Nessa parte do carrinho, armazenaremos somento o id do produto e
// não os seus dados, pois o preço por exemplo pode sofrer alterações, e caso
// o carrinho armazenasse o preço, quando alterar o preço, no carrinho iria
// continuar o mesmo valor por ter armazendo aquele valor. Armazenando somente
// o id do produto, toda vez que o carrinho abrir, carregará os dados produto
// atuais através do id, pois o produto ser exibido no arrinho pelo seu id.


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

// Estruturando os produtos do carrinho
class CartProduct{
  CartProduct();

  // Armazena o id do produto no carrinho
  String? cid;

  // Armazena o id da categoria para ter acesso aos produtos que estão na categoria
  String? category;
  // Armazena o id do produto na categoria, para ter acesso a esse produto
  String? pid;

  // Armazena a quantidade, pois a quantidade que usuário coloca no produto, não
  // será alterada, a não ser que ele mesmo altere. A mesma coisa com o tamanho(size)
  int? quantity;
  String? size;

  // Armazena temporariamente os dados do produto no carrinho. Pois ao abrir o
  // carrinho, os dados do produto deverá ser atualizados
  ProductData? productData;

  // Cria-se o contrutor para receber os  dados do documentos do firebase que
  // será os produto armazenados no carrinho, e converte-los para os dados
  // acima(quer serão os dados do produto)
  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.id;
    category = document.get("category");
    pid = document.get("pid");
    quantity = document.get("quantity");
    size = document.get("size");
  }

  // Ao adiconar o produto no carrinho. Tem que pegar todos esse documento e
  // transforma em um map. Assim estaremos enviando os dado do produto para o db.
  Map<String, dynamic> toMap() {
    return {
      "category" : category,
      "pid" : pid,
      "quantity" : quantity,
      "size" : size,
      // Resumo das informações do produto no carrinho
      "product" : productData!.toResumeMap(),
    };
  }



}