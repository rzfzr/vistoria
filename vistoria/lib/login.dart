import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vistoriaversao2/cadastro_usuario.dart';

import 'home.dart';
import 'model/Usuario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _msgerro = "";

  _validarCampos(){
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email.isNotEmpty && email.contains("@")){
      if(senha.isNotEmpty){

        setState(() {
          _msgerro = "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);

      }else{
        setState(() {
          _msgerro = "Preencha a senha e digite mais de 6 caracteres";
        });
      }

    }else{
      setState(() {
        _msgerro = "Preencha o email utilizando o @";
      });
    }
  }

  _logarUsuario(Usuario usuario){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: usuario.email, password: usuario.senha)
    
    .then((firebaseUser){
      Navigator.pushReplacementNamed(context, "/home");

    }).catchError((error){
      setState(() {
        _msgerro =
        "Erro ao autenticar usuário, Verifique e-mail e senha e tente novamente";
      });
    });
  }


  Future _verificarUsuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;


    FirebaseUser usuarioLogado = await auth.currentUser();

    if(usuarioLogado != null){
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xff43439A)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset("imagens/CWR.png", width: 200, height: 150,),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "E-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32)
                      )
                    ),
                  ),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32)
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.indigo,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: (){
                      _validarCampos();
                    },
                  ),

                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? Cadastre-se!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => CadastroUsuario()
                          )
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _msgerro,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20
                      ),

                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
