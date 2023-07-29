import 'package:flutter/material.dart';

Color darkBlue = Color(0xff292B5E);
Color bl = Color(0xff252525);
Color lightBlue = Color(0xffE1E3FF);
Color midBlue = Color(0xffA4A9EC);
Color bgBlue = Color(0xffE7E7FF);
Color redColor = Color(0xFFE31E24);
Color greyDark = Color(0xFF484752);
Color greyMed = Color(0xFF8F8688);
Color greyLight = Color(0xFFEDEAEA);
Color transparent_overlay = Color(0xFFFFFF);

Widget loaderss(bool a, BuildContext context) {
  return Visibility(
      visible: a,
      child: Stack(
        children: [
          Visibility(
            visible: a,
            child: new Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: new Card(
                color: transparent_overlay,
                elevation: 4.0,
              ),
            ),
          ),
          Visibility(visible: a, child: loader())
        ],
      ));
}

class RIKeys {
  static final riKey1 = const Key('__RIKEY1__');
  static final riKey2 = const Key('__RIKEY2__');
  static final riKey3 = const Key('__RIKEY3__');
}

class loader extends StatelessWidget {
  const loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      child: new Container(
        height: 90.0,
        width: 90.0,
        child: new Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: greyMed,
          elevation: 7.0,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: redColor,
              strokeWidth: 5,
            ),
          ),
        ),
      ),
    );
  }
}
