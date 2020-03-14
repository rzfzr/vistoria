import 'package:flutter/material.dart';
import 'package:vistoriaversao2/cadastro_usuario.dart';
import 'package:vistoriaversao2/home.dart';

import 'login.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){

    switch(settings.name){
      case "/":
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case "/login":
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/cadastro":
        return MaterialPageRoute(
            builder: (_) => CadastroUsuario()
        );
      case "/home":
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      default:
        _erroRota();

    }

  }

  static Route<dynamic>_erroRota(){
      return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(title: Text("Tela não encontrada!"),),
            body: Center(
              child: Text("Tela não encontrada"),
            ),
          );
        }
      );
  }

}