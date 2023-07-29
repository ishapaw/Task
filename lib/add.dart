import 'dart:convert';

import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hackerkernel_task/Useful/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Useful/color.dart';
import 'Useful/func.dart';
import 'home.dart';
import 'list.dart';
import 'login.dart';

class Add extends StatefulWidget {
  Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final formKey = GlobalKey<FormState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();

  List<Product> list = <Product>[];

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    loadSharedPreferences();
    super.initState();
  }

  loadSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  Future<List<Product>> loadData() async {
    List<String> Listp = sharedPreferences.getStringList('list')!;
    print("list");
    print(Listp);

    if (Listp != null) {
      setState(() {
        list = Listp.map((item) => Product.fromMap(json.decode(item))).toList();
        dupl = Listp.map((item) {
          Map<String, dynamic> m = jsonDecode(item);
          return m;
        }).toList();
        print("e rhi na");
        print(list);
      });
    }

    return list;
  }

  File? image;
  String filename = "Select file";

  final _picker = ImagePicker();

  XFile? pickedFile;
  List<int> imageBytes = [];
  String? base64Image;

  Future getImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      if (image != null) imageBytes = image!.readAsBytesSync();

      base64Image = base64Encode(imageBytes);

      print("image selected ${image}");

      setState(() {});
    } else {
      print("no image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messengerKey,
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Product",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Name of the product -",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 65,
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    maxLength: 18,
                    cursorColor: Colors.black,
                    controller: name,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(
                      fontFamily: 'mons',
                      fontSize: 13.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      helperText: " ",
                      fillColor: lightBlue,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                    ),
                    onChanged: (text) {
                      // password = text;
                    },
                    validator: (value) {
                      if (value!.isEmpty ||
                          RegExp(r'^[a-z A-Z] + $').hasMatch(value!)) {
                        return ("Please enter the name");
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Price of the product -",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 65,
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    maxLength: 18,
                    cursorColor: Colors.black,
                    controller: price,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(
                      fontFamily: 'mons',
                      fontSize: 13.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      helperText: " ",
                      fillColor: lightBlue,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                    ),
                    onChanged: (text) {
                      // password = text;
                    },
                    validator: (value) {
                      if (value!.isEmpty ||
                          RegExp(r'^[a-z A-Z] + $').hasMatch(value!)) {
                        return ("Please enter the price");
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                borderbtnsss(
                  image != null ? "Image Selected" : "Select Image",
                  () {
                    getImage();
                  },
                  Colors.white,
                  image != null ? greyMed : Color(0xff0165FF),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Spacer(),
                    borderbtnsss(
                      "Add",
                      () {
                        if (formKey.currentState!.validate()) {
                          if (dupl
                              .where((element) => element['name'] == name.text)
                              .isEmpty) {
                            dupl.add({"name": name.text, "price": price.text});
                            print("dupl: ${dupl}");

                            addItem(Product(
                                name: name.text,
                                price: price.text,
                                image: base64Image!));
                          } else {
                            Snacker("Product is already added", _messengerKey);
                          }
                        }
                      },
                      Colors.white,
                      Color(0xff0165FF),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addItem(Product product) {
    list.add(product);
    name.clear();
    price.clear();
    saveData();
  }

  void saveData() {
    List<String> usrList =
        list.map((item) => jsonEncode(item.toMap())).toList();

    sharedPreferences.setStringList("list", usrList);
    print(usrList);
    loadData();

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MainScreen(reclist: dupl)));
  }
}
