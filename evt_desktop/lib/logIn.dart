
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:evt_desktop/app_data.dart';

class LogIn extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LogIn> {
  
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return CupertinoPageScaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text(
          'EchoVisionTech',
          style: TextStyle(fontSize: 25, color: CupertinoColors.black),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _centerPage(context),
          SizedBox(height: 50),
          Container(
            height: 10,
            child: Text(
              'EchoVisionTech Desktop',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w100,
                color: CupertinoColors.black.withOpacity(0.7)
              )
            )
          )
        ]
      )
    );
  }
} 

Center _centerPage(BuildContext context) {
  AppData appData = Provider.of<AppData>(context, listen: false);

  final TextEditingController controllerURL = TextEditingController();
  final TextEditingController controllerUser = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();


  if (appData.doesFileExist(appData.filePath)) {
    String oldUrl = appData.readSingleLineFile(appData.filePath);

    controllerURL.text = oldUrl;
  }

  return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('LOGIN'),
          SizedBox(height: 15),
          Text('Url'),
          SizedBox(height: 5),
          SizedBox(
            height: appData.textFieldHeight,
            width: appData.textFieldWidth,
            child: CupertinoTextField(
              controller: controllerURL,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5),
              ),
              placeholder: "URL",
            ),
          ),
          SizedBox(height: 15),
          Text("User"),
          SizedBox(height: 5),
          SizedBox(
            height: appData.textFieldHeight,
            width: appData.textFieldWidth,
            child: CupertinoTextField(
              controller: controllerUser,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5),
              ),
              placeholder: "User",
            ),
          ),
          SizedBox(height: 15),
          Text("Password"),
          SizedBox(height: 5),
          SizedBox(
            height: appData.textFieldHeight,
            width: appData.textFieldWidth,
            child: CupertinoTextField(
              controller: controllerPassword,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5),
              ),
              placeholder: "Password",
              obscureText: true,
            ),
          ),
          SizedBox(height: 25),
          CupertinoButton(
            child: Text(
              'Connect',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            onPressed: () { 
              appData.connectToServer(controllerURL.text, controllerUser.text, controllerPassword.text, context);
            }
          ),
        ],
      ),
    );
}
