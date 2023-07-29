import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Useful/api_serv.dart';
import 'Useful/color.dart';
import 'Useful/func.dart';
import 'Useful/helper.dart';
import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

double screenh = 0;
double screenw = 0;
String email = "";
String password = "";
bool isHide = false;
bool passwordVisible = true;
String uid = "";

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  callLoginApi() {
    final service = ApiServices();

    service
        .apiCallLogin(emailController.text, passController.text)
        .then((value) {
      if (value.token != null) {
        Snacker("Logged in succesfully", _messangerKey);
        HelperFunctions.saveuserLoggedInSharePreference(true);

        Future.delayed(Duration(seconds: 2), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(reclist:[])));
        });
      } else {
        if (emailController.text == "" && passController.text == "") {
          setState(() {
            isHide = false;
          });
          Snacker("Please enter the email and password", _messangerKey);
        } else if (emailController.text == "") {
          setState(() {
            isHide = false;
          });
          Snacker("Please enter the email", _messangerKey);
        } else if (passController.text == "") {
          setState(() {
            isHide = false;
          });
          Snacker("Please enter the password", _messangerKey);
        } else {
          setState(() {
            isHide = false;
          });
          Snacker("User Incorrect, Check Again", _messangerKey);
        }

        //push
      }
    });
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Exit App',
              style: TextStyle(color: lightBlue),
            ),
            content: Text(
              'Do you want to exit an App?',
              style: TextStyle(color: lightBlue),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: lightBlue, // Background color
                ),
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: lightBlue, // Background color
                ),
                onPressed: () => SystemNavigator.pop(),
                //return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  void initState() {
    isHide = false;
  }

  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    screenh = MediaQuery.of(context).size.height;
    screenw = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: showExitPopup,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: _messangerKey,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: [
            SingleChildScrollView(
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 70),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 7,
                      ),
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 33,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                      Form(
                        key: RIKeys.riKey2,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.alternate_email_outlined,
                                    color: greyMed,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: screenw / 1.3,
                                    child: TextFormField(
                                      controller: emailController,
                                      maxLength: 36,
                                      keyboardType: TextInputType.emailAddress,
                                      cursorColor: Colors.black,
                                      style: TextStyle(
                                        fontFamily: 'mons',
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Email ID",
                                        counterText: "",
                                        labelStyle: TextStyle(
                                            color: greyMed,
                                            fontWeight: FontWeight.w500),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      onChanged: (text) {
                                        // email = text;
                                      },
                                      validator: (value) {
                                        bool emailValid = RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value!);
                                        if (!emailValid) {
                                          return ("Please enter a valid email");
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(
                                    Icons.lock_person_rounded,
                                    color: greyMed,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: screenw / 1.3,
                                    child: TextFormField(
                                      maxLength: 18,
                                      cursorColor: Colors.black,
                                      controller: passController,
                                      obscureText: !passwordVisible,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      style: TextStyle(
                                        fontFamily: 'mons',
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            passwordVisible
                                                ? Icons.remove_red_eye
                                                : Icons.remove_red_eye_outlined,
                                            color: greyMed,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                        ),
                                        labelText: "Password",
                                        counterText: "",
                                        labelStyle: TextStyle(
                                            color: greyMed,
                                            fontWeight: FontWeight.w500),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                      ),
                                      onChanged: (text) {
                                        // password = text;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ("Please enter a password");
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                            color: Color(0xff0165FF),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: screenw,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    callLoginApi();
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color(0xff0165FF)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ))),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: greyLight,
                                      thickness: 1,
                                    ),
                                  ),
                                  Text(
                                    " OR ",
                                    style: TextStyle(color: greyMed),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: greyLight,
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Color(0xffF1F6F7),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage("assets/g.png"),
                                      width: 20,
                                    ),
                                    SizedBox(width: 30),
                                    Text('Login with Google',
                                        style: TextStyle(
                                            color: greyMed,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("New to Logistics? ",
                                      style: TextStyle(
                                          color: greyMed,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Color(0xff0165FF),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800),
                                  )
                                ],
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
                // loaderss(isHide, context)
              ]),
            ),
            loaderss(isHide, context)
          ]),
        ),
      ),
    );
  }
}
