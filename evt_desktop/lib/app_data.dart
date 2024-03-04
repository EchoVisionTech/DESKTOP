// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:evt_desktop/mainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class AppData with ChangeNotifier {
  String apiKey = "";

  String lastUrlPath = "files/lastUrl.txt";

  double textFieldWidth = 305;
  double textFieldHeight = 40;

  List<dynamic> userList = [{"nickname":"joel", "pla":"premium"},{"nickname":"geanfranco", "pla":"premium"},{"nickname":"admin", "pla":"free"}];
  bool changingPlan = false;


  Future<void> connectToServer(String url, String user, String password, BuildContext context) async {

    if (!(url.isEmpty || user.isEmpty || password.isEmpty)) {
      Map<String, String> jsonData = {
        'user': user,
        'password': password,
      };

      String jsonString = jsonEncode(jsonData);

      _loadHttpPostByChunks(url, jsonString, context);

      File(lastUrlPath).writeAsStringSync(url);

      userList = await _getList(url);

    } else {
      showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(
          "Warning Error",
          style: TextStyle(color: CupertinoColors.destructiveRed),
        ),
        content: const Text("You should complete all the fields."),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

    }
  }

  Future<void> _loadHttpPostByChunks(String url, String data, BuildContext context) async {
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
        print('RESPONSE: ${response.body}');
        jsonResponse = jsonDecode(response.body);
  
        if (jsonResponse["status"] == "OK") {
          apiKey = jsonResponse["data"]["api_key"];
          print('User ok');
          changeToMainPage(context);
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

  Future<List<dynamic>> _getList(String url) async {
    var completer = Completer<List<dynamic>>();

    Map<String, dynamic> jsonResponse;
    Map<String, dynamic> jsonData;

    List<dynamic> list = [];
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', 
          "Authorization": 'Bearer $apiKey',
        }
      );

      if (response.statusCode == 200) {
        // La solicitud ha sido exitosa
        print('RESPONSE: ${response.body}');
        jsonResponse = jsonDecode(response.body);
  
        if (jsonResponse["status"] == "OK") {
          list = jsonResponse["data"];
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

  void changeToMainPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  Future<void> changePlan(int index) async {
    changingPlan = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 1));
    if (userList[index]["pla"] == "premium") {
      userList[index]["pla"] = "free";
    } else {
      userList[index]["pla"] = "premium";
    }

    print(userList[index]["pla"]);

    changingPlan = false;
    notifyListeners();
  }

  void forceNotifyListeners() {
    notifyListeners();
  }

}
