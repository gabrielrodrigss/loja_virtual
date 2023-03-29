import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';

// Customização da aba drawer
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.pageController});

  // Atributo de navegação para o DrawerTile ter acesso
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 203, 236, 241), Colors.white],
                  // Definido onde o gradiente de cor começa e termina
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        );

    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(50)),
        child: Drawer(
          child: Stack(
            children: [
              _buildDrawerBack(),
              ListView(
                padding: const EdgeInsets.only(left: 32.0, top: 16.0),
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                    padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                    height: 170.0,
                    // O Stack, permite o posicionamento deos widgets em qualquer parte do Container(caixa)
                    child: Stack(
                      children: [
                        Positioned(
                            top: 8.0,
                            left: 0.0,
                            child: Row(
                              children: [
                                const Text(
                                  "G.O.R\nStore",
                                  style: TextStyle(
                                    fontSize: 34.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                Container(
                                  height: 40.0,
                                  width: 1.0,
                                  color: Colors.grey[500],
                                ),
                                SizedBox(width: 10.0,),
                                const Text(
                                  "Roupas de qualidade\ncom o melhor preço",
                                  style: TextStyle(
                                      fontSize: 12.0, fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                        ),
                        Positioned(
                          left: 0.0,
                          bottom: 0.0,
                          child: ScopedModelDescendant<UserModel>(
                            builder: (context, child, model) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Olá, ${!model.isLoggedIn()! ? "" : model.userData["name"]}",
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      !model.isLoggedIn()!
                                          ? "Entre ou cadastre-se >"
                                          : "Sair",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () {
                                      if(!model.isLoggedIn()!) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => const LoginScreen())
                                        );
                                      } else {
                                        model.signOut();
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  // Com o acesso permitido ao pageController, é passado a
                  // responsabilidade de alteração de pagina à cada um dos itens
                  DrawerTile(
                    icon: Icons.home,
                    text: "Início",
                    controller: pageController, // Permite o item alterar a pagina
                    page: 0, // Defini a que pagina o item corresponde
                  ),
                  DrawerTile(
                    icon: Icons.list,
                    text: "Produtos",
                    controller: pageController,
                    page: 1,
                  ),
                  DrawerTile(
                    icon: Icons.location_on,
                    text: "Lojas",
                    controller: pageController,
                    page: 2,
                  ),
                  DrawerTile(
                    icon: Icons.playlist_add_check,
                    text: "Meus Pedidos",
                    controller: pageController,
                    page: 3,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
