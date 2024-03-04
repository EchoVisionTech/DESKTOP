
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:evt_desktop/app_data.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
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
          _userlist(context),
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


Center _userlist(BuildContext context) {
  AppData appData = Provider.of<AppData>(context);

  // List userList = [{"nickname":"joel", "pla":"premium"},{"nickname":"geanfranco", "pla":"premium"},{"nickname":"admin", "pla":"free"}];

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("User list"),
          Container(
            width: 300,
            height: 500,
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: appData.userList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.only(left: 4, right: 4),
                    decoration: BoxDecoration(
                      color: appData.changingPlan ? CupertinoColors.inactiveGray : CupertinoColors.systemGrey6,
                      border: Border.all(color: appData.changingPlan ? CupertinoColors.inactiveGray :CupertinoColors.activeBlue, width: 1.5),
                      
                      borderRadius: BorderRadius.circular(5), 
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${appData.userList[index]["nickname"]}'),
                        Text('${appData.userList[index]["pla"]}'),
                      ]
                    ),
                    
                  ),
                  onTap: () {
                    if (!appData.changingPlan) {
                      appData.changePlan(index);
                    }
                    
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          ),
        ],
      ),
  );
}