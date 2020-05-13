import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'searchservice.dart';

class EmpresaView extends StatefulWidget {
  @override
  _EmpresaViewState createState() => _EmpresaViewState();
}

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}

class ExtractArgumentsScreen extends StatelessWidget {
static const routeName = '/extractArguments';

@override
Widget build(BuildContext context) {

  final ScreenArguments args = ModalRoute.of(context).settings.arguments;

  return Scaffold(
    appBar: AppBar(
      title: Text(args.title),
    ),
    body: Center(
      child: Text(args.message),
    ),
  );
}
}



class _EmpresaViewState extends State<EmpresaView> {
  List<String> itensMenu = ["Deslogar"];

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Deslogar":
        _deslogarUsuario();
        break;
    }

  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacementNamed(context, "/login");
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }



    debugPrint('value: $value');
//    var capitalizedValue =
//        value.substring(0, 1).toUpperCase() + value.substring(1);
//    debugPrint('queryresultset: $queryResultSet');

    if (queryResultSet.length == 0 ) {//&& value.length == 1
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['Nome'].startsWith(value)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Vistoria de Ar Condicionado"),

        actions: <Widget>[

          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(

        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[


                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Nova Vistoria",
                      style: TextStyle(color: Colors.white, fontSize: 20),

                    ),
                    color: Colors.indigo,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: (){
                      Navigator.pushNamed(
                        context,
                        ExtractArgumentsScreen.routeName,
                        arguments: ScreenArguments(
                          'Extract Arguments Screen',
                          'This message is extracted in the build method.',
                        ),
                      );

                    },
                  ),

                ), Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Nova Vistoria",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.indigo,
                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                  ),

                ),

              ],
            ),
          ),
        ),
      ),




    );
  }
}

Widget buildResultCard(data) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
          child: Center(
              child: Text(data['Nome'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              )
          )
      )
  );
}