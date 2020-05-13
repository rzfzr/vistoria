import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'searchservice.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (val) {
              initiateSearch(val);
            },
            decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back),
                  iconSize: 20.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Pesquisar por Nome',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0))),
          ),
        ),
        SizedBox(height: 10.0),
        GridView.count(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            primary: false,
            shrinkWrap: true,
            children: tempSearchStore.map((element) {
              return buildResultCard(element, context);
            }).toList())
      ],
      ),
    );
  }
}

Widget buildResultCard(data,BuildContext context) {
  return


    Card(
      child: new InkWell(
        onTap: () {
          print("tapped at " + data['Nome']);

          Navigator.pushNamedAndRemoveUntil(context, "/empresaView", (_)=>false);



        },
        child: Container(
          width: 100.0,
          height: 100.0,

            child: Center(
                child: Text(data['Nome'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                )
            )
        ),
      ),
    );

    Card(
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