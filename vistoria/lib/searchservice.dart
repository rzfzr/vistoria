import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class SearchService {
  searchByName(String searchField) {
    debugPrint('searchfield: $searchField');


    return Firestore.instance


        .collection('Clientes')
        .where('SearchKey',isEqualTo: searchField.substring(0, 1).toUpperCase())// todo: comparar nao soh a primeira letra, e capitalizacao
        .getDocuments();
  }
}