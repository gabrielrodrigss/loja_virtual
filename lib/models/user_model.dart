import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

// O model é um objeto que irá guardar o estado de algo, no caso, o estado do
// login, ou seja, armazenará o usuário atual e conterá todas as funções de modificação
class UserModel extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Pega o usuário atual. Se tive usuário logado, terá alguns info(id) do user, caso contrário, será null
  User? firebaseUser;

  // Abrigará as info do usuário, que será os dados preenchido no formulário de criar conta
  Map<String, dynamic> userData = Map();

  // Indica quando UserModel() está processando alguma coisa
  bool isLoanding = false;

  // Essa é mais um forma de de ter acesso ao UserModel de qualque lugar do app, usando
  // o ScopedModel.of(context)<UserModel> que busca um objeto UserModel na arvore
  static UserModel of(BuildContext context) {
    return ScopedModel.of<UserModel>(context);
  }



  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();

  } // Para o usuário se inscrever
  // VoidCallback indica uma fução que será passado por parâmentro para essa.
  void signUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    isLoanding = true;
    notifyListeners();

    // Tentando criar o usuário
    _auth
        .createUserWithEmailAndPassword(
      email: userData["email"],
      password: pass,
    )
        .then((user) async {
      firebaseUser = user.user;

      // Salva o nome o endereço no firebase, pois ao criar o usuário salva só
      // email e senha
      await _saveUserData(userData);

      // Se der certo chma a função onSuccess
      onSuccess();
      isLoanding = false;
      notifyListeners();
    }).catchError((e) {
      // Se não der certo chama a onFail
      onFail();
      isLoanding = false;
      notifyListeners();
    });
  }

  // Para o usuário entrar
  void signIn(
      {required String email,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) async {
    isLoanding = true; // Indica que está carregando
    notifyListeners(); // Notifica uma modificação para alterar as views

    //
    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
          // Login feito, e usuário buscado
          firebaseUser = user.user;
          // Chamada da função que busca as info do usuário
          await _loadCurrentUser();

      onSuccess();
      isLoanding = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoanding = false;
      notifyListeners();
    });
  }

  // Implementação da funcionalidade do usuário sair do app
  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners(); // Notifica a mudança de estado, depois o usuário sair
  }

  // Recuperação de senha
  void recorverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  // Verificar se o usuário está logado
  bool? isLoggedIn() {
    return firebaseUser != null;
  }

  // Salva os dados do usuário na coleção usuários
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.uid)
        .set(userData);
  }

  // Quando o usuário é lagado, essa função pegará os dados desse usuário
  Future<Null> _loadCurrentUser() async {
    // Se o usuário for null, essa condição vai tentar buscar o usuário atual
    firebaseUser ??= _auth.currentUser;
    // Se o usuário for diferente de null, será buscado as info desse usuário
    if (firebaseUser != null) {
      // Se name for igual null, buscará o nome e as outra info desse usuário
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser!.uid)
            .get();
        userData = docUser.data() as Map<String, dynamic>;
      }
      notifyListeners();
    }
  }
}
