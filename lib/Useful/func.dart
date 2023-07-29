import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'color.dart';

void Snacker(String title, GlobalKey<ScaffoldMessengerState> aa) {
  final snackBar = SnackBar(
      elevation: 0,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: darkBlue,
      content: Text(title));

  aa.currentState?.showSnackBar(snackBar);
  // messangerKey.currentState?.showSnackBar(snackBar);
}

class borderbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color text;
  Color bg;

  borderbtnsss(this.title, this.callback, this.text, this.bg);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: Text(
          title,
          style: TextStyle(color: text, fontWeight: FontWeight.w600),
        ),
      ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(bg),
          backgroundColor: MaterialStateProperty.all<Color>(bg),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: bg, width: 2.0)))),
      onPressed: callback,
    );
  }
}
