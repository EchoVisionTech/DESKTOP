import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppData with ChangeNotifier {

  String filePath = "files/lastUrl.txt";

  double textFieldWidth = 305;
  double textFieldHeight = 40;


  void connectToServer(String url, String user, String password) {

    Map<String, String> jsonData = {
      'user': user,
      'password': password,
    };

    String jsonString = jsonEncode(jsonData);

    // _loadHttpPostByChunks(url, user, password);
    _loadHttpPostByChunks(url, jsonString);

    File(filePath).writeAsStringSync(url);
  }

  Future<void> _loadHttpPostByChunks(String url, String data) async {
    var completer = Completer<void>();

    Map<String, dynamic> jsonResponse;
    Map<String, dynamic> jsonData;
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
        jsonResponse = jsonDecode(response.body);
  
        if (jsonResponse["status"] == "OK") {
          String apiKey = jsonResponse["data"]["api_key"];
          print('API Key: $apiKey');
        
        }

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

  bool doesFileExist(String filePath) {
    return File(filePath).existsSync();
  }

  String readSingleLineFile(String filePath) {
    return File(filePath).readAsStringSync();
  }

}