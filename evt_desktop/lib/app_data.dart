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

  // List<dynamic> userList = [{"nickname":"joel", "pla":"premium"},{"nickname":"geanfranco", "pla":"premium"},{"nickname":"admin", "pla":"free"}];
  List<dynamic> userList = [];
  bool changingPlan = false;


  Future<void> connectToServer(String url, String user, String password, BuildContext context) async {

    if (!(url.isEmpty || user.isEmpty || password.isEmpty)) {
      Map<String, String> jsonData = {
        'user': user,
        'password': password,
      };

      String jsonString = jsonEncode(jsonData);

      await _loadHttpPostByChunks(url, jsonString, context);

      File(lastUrlPath).writeAsStringSync(url);

      // print(userList);
      await _getList();
      print("getList done");
      print(userList);

      notifyListeners();

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

  Future<void> _getList() async {
    var completer = Completer<void>();

    Map<String, dynamic> jsonResponse;
    Map<String, dynamic> jsonData;
    
    List<dynamic> list = [];
    String url = "https://ams22.ieti.site:443/api/users/admin_get_list";
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', 
          'Authorization': 'Bearer $apiKey'
        }
      );

      if (response.statusCode == 200) {
        // La solicitud ha sido exitosa
        /// print('RESPONSE: ${response.body}');
        jsonResponse = jsonDecode(response.body);
        if (jsonResponse["status"] == "OK") {
          list = jsonResponse["data"];
          userList = list.where((element) => element != null).toList();
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
    String phoneNumber = userList[index]['telefon'];
    String nickname = userList[index]['nickname'];
    String email = userList[index]['email'];
    String newPlan = "";
    if (userList[index]["pla"] == "premium") {
      newPlan = "free";
    } else {
      newPlan = "premium";
    }

    userList[index]["pla"] = newPlan;

    await sendServerChangePlan(phoneNumber, nickname, email, newPlan);

    print(userList[index]["pla"]);

    changingPlan = false;
    notifyListeners();
  }

  Future<void> sendServerChangePlan(String phoneNumber, String nickname, String email, String newPlan) async {
  var completer = Completer<void>();

  Map<String, dynamic> jsonResponse;
  
  String url = "https://ams22.ieti.site:443/api/users/admin_change_plan";
  Map<String, dynamic> data = {
    'phone_number': phoneNumber,
    'nickname': nickname,
    'email': email,
    'plan': newPlan
  };

  String jsonData = jsonEncode(data); 
  print(jsonData);
  
  try {
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', 
        'Authorization': 'Bearer $apiKey'
      }, 
      body: jsonData, // Send JSON string as the request body
    );

    if (response.statusCode == 200) {
      // Request was successful
      print('RESPONSE: ${response.body}');
      jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse["status"] == "OK") {
        print("Plan changed");
      }

      completer.complete();
    } else {
      // Request failed
      completer.completeError(
        "Server error: ${response.reasonPhrase}"
      );
    }
  } catch (e) {
    completer.completeError("Exception occurred: $e");
  }
  
  return completer.future;
}

  void forceNotifyListeners() {
    notifyListeners();
  }

}
