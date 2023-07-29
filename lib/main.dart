import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hackerkernel_task/home.dart';
import 'Useful/func.dart';
import 'Useful/helper.dart';
import 'login.dart';

void main() async {
  runApp(Phoenix(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.cyan),
      home: Splash(),
    ),
  ));
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool userIsLoggedIn = false;

  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  getLoggedInState() async {
    await HelperFunctions.getuserLoggedInSharePreference().then((value) {
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }

  String uid = "";

  @override
  void initState() {
    getLoggedInState();

    print(userIsLoggedIn);

    Future.delayed(Duration(seconds: 1), () {
      userIsLoggedIn != null
          ? userIsLoggedIn
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MainScreen(reclist: [])))
              : Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignIn()))
          : Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messengerKey,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Spacer(),
                Image(
                  image: AssetImage('assets/g.png'),
                  height: 100,
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
