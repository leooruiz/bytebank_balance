import 'dart:convert';

import 'package:http/http.dart' as http;

class BalanceService {
  String url = "http://10.0.2.2:3000";

  Future<bool> hasPin({required String userId}) async {
    http.Response response = await http.post(
      Uri.parse("$url/balance/has-pin"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          "userId": userId,
        },
      ),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)["hasPin"];
    }

    return false;
  }

  Future<double?> createPin({
    required String userId,
    required String pin,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$url/create-pin"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "userId": userId,
          "newPin": pin,
        }),
      );

      if (response.statusCode == 200) {
        return (json.decode(response.body)["balance"] as int).toDouble();
      }
      throw Exception();
    } on Exception {
      return null;
    }
  }

  Future<double?> getBalance({
    required String userId,
    required String pin,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$url/user-balance"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "userId": userId,
          "pin": pin,
        }),
      );

      if (response.statusCode == 200) {
        return (json.decode(response.body)["balance"] as int).toDouble();
      }
      throw Exception();
    } on Exception {
      return null;
    }
  }

  Future getEmail() async {
    try {
      http.Response response = await http.post(
          Uri.parse("$url/auth/find-email/?email=dandara@alura.com.br"),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        return (json.decode(response.body));
      }
      throw Exception();
    } on Exception {
      return null;
    }
  }

  Future createTransaction({
    required String senderId,
    required String receiverId,
    required double amount,
    required DateTime date,
    required int type,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$url/transaction/create-transaction"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "senderId": senderId,
            "receiverId": receiverId,
            "amount": amount,
            "date": date,
            "type": type,
          },
        ),
      );
      if (response.statusCode == 200) {
        return (json.decode(response.body));
      }
      throw Exception();
    } on Exception {
      return null;
    }
  }
}
