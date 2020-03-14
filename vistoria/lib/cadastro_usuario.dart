import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vistoriaversao2/home.dart';
import 'package:vistoriaversao2/login.dart';
import 'package:vistoriaversao2/model/Usuario.dart';


class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _msgerro = "";

  _validarCampos(){
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(nome.isNotEmpty){
      if(email.isNotEmpty && email.contains("@")){
        if(senha.isNotEmpty && senha.length > 6 ){

          setState(() {
            _msgerro = "Cadastrado com Sucesso";
          });

          Usuario usuario = Usuario();

          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;

          _cadastrarUsuario(usuario);

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
    }else{
      setState(() {
        _msgerro = "Preencha o nome";
      });
    }

  }

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha).then((FirebaseUser)  {

        Firestore db = Firestore.instance;
        
        db.collection("usuarios").document(FirebaseUser.user.uid).setData( usuario.toMap() );

        Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);



    }).catchError((error){
      setState(() {
        _msgerro = "Erro ao cadastrar usuário, verifique os campos e tente novamente";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text("Cadastro"),
          ),
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
                      //aqui coloco a imagem do usuario
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller: _controllerNome,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            hintText: "Nome",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32)
                            )
                        ),
                      ),
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
                          "Cadastrar",
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
                      child: Text(
                        _msgerro,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
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
