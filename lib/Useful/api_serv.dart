import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiServices {
  Future<LoginApiResponse> apiCallLogin(var email, var pass) async {
    print(email);
    print(pass);
    var url = Uri.parse('https://reqres.in/api/login');
    http.Response response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{"email": email, "password": pass}));

    print(response.statusCode);

    if (response.statusCode == 200) {
      print("login successfully");
    }

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final data = jsonDecode(response.body);
    return LoginApiResponse(
        token: data["token"], msg: data["message"], uid: data["userId"]);
  }
}

class LoginApiResponse {
  final String? token;
  final String? msg;
  final String? uid;

  LoginApiResponse({this.token, this.msg, this.uid});
}
