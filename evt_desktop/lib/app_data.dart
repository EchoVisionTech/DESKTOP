import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppData with ChangeNotifier {



  void connectToServer(String url, String user, String password) {

    Map<String, String> jsonData = {
      'user': user,
      'password': password,
    };

    String jsonString = jsonEncode(jsonData);

    // _loadHttpPostByChunks(url, user, password);
    _loadHttpPostByChunks(url, jsonString);
  }

  Future<void> _loadHttpPostByChunks(String url, String data) async {
    var completer = Completer<void>();
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', 
        },
        body: data
      );

      if (response.statusCode == 200) {
        // La solicitud ha sido exitosa
        print('RESPONSE: ' + response.body);
        completer.complete();
      } else {
        // La solicitud ha fallado
        completer.completeError(
            "Error del servidor (appData/loadHttpPostByChunks): ${response.reasonPhrase}");
      }
    } catch (e) {
      completer.completeError("Excepción (appData/loadHttpPostByChunks): $e");
    }

    return completer.future;
  }
}