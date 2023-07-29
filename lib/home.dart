import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackerkernel_task/Useful/color.dart';
import 'package:hackerkernel_task/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Useful/func.dart';
import 'Useful/helper.dart';
import 'Useful/product.dart';
import 'add.dart';

class MainScreen extends StatefulWidget {
  List<Map<String, dynamic>> reclist;
  MainScreen({required this.reclist});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Map<String, dynamic>> list = [];
  List<Product> uplist = <Product>[];

  TextEditingController srch = TextEditingController();

  late SharedPreferences sharedPreferences;

  List<Map<String, dynamic>> _found = [];
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    list = widget.reclist;
    setState(() {
      loadSharedPreferences();
    });

    super.initState();
  }

  Uint8List? bytes;

  void getImage(String image) async {
    bytes = base64Decode(image);
  }

  void filter(String entered) {
    List<Map<String, dynamic>> results = [];
    if (entered.isEmpty) {
      results = list;
    } else {
      results = list
          .where((item) =>
              item["name"].toLowerCase().contains(entered.toLowerCase()))
          .toList();
    }

    print(results);

    setState(() {
      _found = results;
      if (_found.isEmpty) {
        print("emp");
        Snacker("No product Found", _messengerKey);
      }
    });
  }

  loadSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  Future<List<Map<String, dynamic>>> loadData() async {
    List<String> Listp = sharedPreferences.getStringList('list')!;
    print(Listp);

    if (Listp != null) {
      setState(() {
        list = Listp.map((item) {
          Map<String, dynamic> m = jsonDecode(item);
          return m;
        }).toList();
      });
    }

    _found = list;

    return list;
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
  Widget build(BuildContext context) {
    int t = 0;
    return WillPopScope(
      onWillPop: showExitPopup,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: _messengerKey,
        home: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(0xff0165FF),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Add()));
              },
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(17.0, 40, 17, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xffF2F2F4),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: greyMed,
                        ),
                      ),
                      Spacer(),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        width: t == 0 ? 250 : 56,
                        height: 56,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xffF2F2F4), width: 1.5),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(left: 16),
                              child: t == 0
                                  ? TextField(
                                      style: TextStyle(color: Colors.black87),
                                      onChanged: (value) => filter(value),
                                      controller: srch,
                                      decoration: InputDecoration(
                                          hintText: 'Search',
                                          hintStyle: TextStyle(color: greyMed),
                                          border: InputBorder.none),
                                    )
                                  : null,
                            )),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              child: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.search,
                                      size: 20,
                                      color: greyMed,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      print(t);
                                      if (t == 0)
                                        t = 1;
                                      else if (t == 1) t = 0;
                                      print(t);
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text("Hi-Fi Shop & Service",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 25,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 15),
                  Text("Audio shop on Rustaveli Ave 57.",
                      style: TextStyle(
                          color: greyMed,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 5),
                  Text("This shop offers both products and services",
                      style: TextStyle(
                          color: greyMed,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text("Products ",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontWeight: FontWeight.w800)),
                      Text("${_found.length}",
                          style: TextStyle(
                              color: greyMed,
                              fontSize: 17,
                              fontWeight: FontWeight.w800)),
                      Spacer(),
                      Text("Show all",
                          style: TextStyle(
                              color: Color(0xff0165FF),
                              fontSize: 13,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (list != [])
                    Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _found.length,
                            itemBuilder: (BuildContext context, int index) {
                              getImage(_found[index]["image"]);
                              return Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          Container(
                                            child: Image.memory(bytes!),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Color(0xffF2F2F4),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                removeItem(
                                                    _found[index]["name"],
                                                    index);
                                              },
                                              child: Image(
                                                height: 17,
                                                image: AssetImage(
                                                  "assets/delete.png",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _found[index]["name"],
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "\$${_found[index]["price"]}",
                                      style: TextStyle(
                                          color: greyMed,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                              );
                            })),
                  GestureDetector(
                    onTap: () {
                      HelperFunctions.saveuserLoggedInSharePreference(false);

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("LogOut",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500))),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void removeItem(String product, int index) {
    _found.removeAt(index);
    list.removeWhere((element) => element['name'] == product);
    print(_found);
    saveData();
  }

  void saveData() {
    List<String> usrList = list.map((item) => jsonEncode(item)).toList();

    sharedPreferences.setStringList("list", usrList);
    print(usrList);
    loadData();
  }
}
