import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../datas/cart_product.dart';

class CartModel extends Model {
  // Armazena o usuário atual do carrinho
  UserModel? user;

  // Armazena o produtos quando adiciona ao carrinho na lista do carrinho.
  List<CartProduct> products = [];

  // Armazena o cupom inserido
  String? couponCode;
  int discountPercentage = 0;

  // Armazena o estado de carregamento no em dos casos no carrinho
  bool isLoading = false;

  // Recebe via construtor o usuário lá do main no scopedmodel
  CartModel({required this.user}) {
    // É carregado os itens só se estiver logado, nesse caso essa função é chamada
    if (user!.isLoggedIn()!) {
      _loadCartItem();
    }
  }

  // Essa é mais um forma de de ter acesso ao UserModel de qualque lugar do app, usando
  // o ScopedModel.of(context)<CartModel> que busca um objeto CartModel na arvore
  static CartModel of(BuildContext context) {
    return ScopedModel.of<CartModel>(context);
  }

  // Implementação da funcionalidade de adição de produto no carrinho
  void addCartItem(CartProduct cartProduct) {
    // Adicona o produto ao carrinho
    products.add(cartProduct);

    // Adiciona o produto no carrinho na coleção user através do uid do usuário
    // A função toMap() trasnforma o documento em mapa, para ser adicionado ao firebase
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.firebaseUser!.uid)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      // O produto no carrinho não tem um id pronto, esse id é gerado pelo
      // firebase. Após gerado, esse id é armazenado cid.
      cartProduct.cid = doc.id;
    });

    notifyListeners(); // Notifica a adição
  }

  // Deleta o produto do carrinho
  void removeCartItem(CartProduct cartProduct) {
    // Remove o produto da coleção cart(carrinho)
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .delete();

    // Remove o produto da lista de carrinho.
    products.remove(cartProduct);
    notifyListeners(); // Notifica a remoção.
  }

  // Implementação da funcionalidade de decrementação de quantidade de produto.
  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity =
        cartProduct.quantity! - 1; // decrementando a quantidade

    // Atualizando o dado do produto no firebase.
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners(); // Notificando a atualização para aparecer na tela
  }

  // Implementação da funcionalidade de decrementação de quantidade de produto.
  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity =
        cartProduct.quantity! + 1; // incrementando a quantidade

    // Atualizando o dado do produto no firebase.
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners(); // Notificando o listener para aparecer na tela
  }

  // Setando cupom no produto no carrinho
  void setCupom(String? couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  // Notifica que alguma coisa mudou no preço do produto para atualizar o resumo de pedidos
  void updatePrices() {
    notifyListeners();
  }

  // Retorna o valor total do produto
  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity! * c.productData!.price!;
      }
    }
    return price;
  }

  // Retorna o valor do desconto
  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  // Retorna o valor da entrega
  double getShipPrice() {
    return 9.99;
  }

  Future<String?> finishOrder() async {
    // Medida de segurança - se a lista for vazia retorne
    if (products.isEmpty) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    // Adiciona o pedido na coleção orders, e obtem a referência desse pedido,
    // para ter acesso ao id desse pedido lá da coleção usuários.
    DocumentReference refOrder =
        await FirebaseFirestore.instance.collection("orders").add({
      "clientId": user!.firebaseUser!.uid,
      // Converte a lista cartProduct em lista de map para ser armazenada no firebase
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1
    });

    // Set o id do produto no documentos na coleção usuário.
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.firebaseUser!.uid)
        .collection("orders")
        .doc(refOrder.id)
        .set({"orderId": refOrder.id});

    // Pega todos os documetos na coleção carrinho em usuários.
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.firebaseUser!.uid)
        .collection("cart")
        .get();

    // Pega a referência de cada produto no carrinho e deleta.
    for(DocumentSnapshot doc in query.docs) {
      doc.reference.delete();
    }

    products.clear(); // Limpa a lista local.

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id; // Retorna o id pedido
  }

  // Carrega os itens ao abrir o carrinho no app
  void _loadCartItem() async {
    // Pega todos os documentos do carrinho la no firebase
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.firebaseUser!.uid)
        .collection("cart")
        .get();

    // Transforma cada doc retornado do firebase em CartProduct e retorna uma
    // lista cartProduct na lista de produtos(Products)
    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}
