import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  List<String> itensMenu = [
    "Configurações", "Deslogar"
  ];


  _escolhaMenuItem(String itemEscolhido){

    switch(itemEscolhido){
      case "Configurações":
        print("Configurações");
        break;
      case "Deslogar":
       _deslogarUsuario();
        break;
    }
    //print("Item escolhido" + itemEscolhido);
  }

  _deslogarUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, "/login");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Vistoria de Ar Condicionado"),
         actions: <Widget>[
           PopupMenuButton<String>(
             onSelected: _escolhaMenuItem,
             itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
             },
           )
         ],

        ),
      body: Container(),
    );
  }
}
