import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    // ScopedModel na main: Perimite o acesso ao modelo usuário(UserModel), em
    // qualquer parte do app de tudo que está abaixo do ScopedModel, e será
    // modificado caso alguma coisa aconteça no UserModel()
    return FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            //tudo o que tiver abaixo do ScopedModel, vai ter acesso ao UserModel()
            //e vai ser modificado caso alguma coisa aconteça no UserModel()
            return ScopedModel<UserModel>(
              model: UserModel(),
              // ScopedModelDescendant rebilda a tela toda vez que o
              // usuário é alterado
              child: ScopedModelDescendant<UserModel>(
                //para que quando mude o usuário, mude o carrinho também
                builder: (context, child, model) {
                  // O ScopedModel<CartModel> é colcado abaixo, pois o usuário,
                  // não precisa saber o que tem no carrinho, e o carrinho
                  // precisa detectar o usuário(UserModel) do carrinho.
                  return ScopedModel<CartModel>(
                    model: CartModel(user: model),
                    child: MaterialApp(
                      title: 'Loja virtual',
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                        primarySwatch: Colors.blue,
                        primaryColor: const Color.fromARGB(255, 4, 125, 141),
                      ),
                      home: HomeScreen(),
                    ),
                  );
                },
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
