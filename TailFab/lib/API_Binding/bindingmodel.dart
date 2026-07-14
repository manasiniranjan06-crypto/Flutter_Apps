import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Devicedatamodel {
  void getproductData() async {
    Uri url = Uri.parse("https://api.restful-api.dev/objects");
    http.Response response = await http.get(url);
    List<dynamic> data = jsonDecode(response.body);
    log("GET DATA");
    log(data[0]['name']);
  }

  void postproductData() async {
    Uri url = Uri.parse("https://api.restful-api.dev/objects");
    Map postData = {
      "name": "Apple MacBook Pro 16",
      "data": {
        "year": 2020,
        "price": 1990.99,
        "CPU model": "Intel Core i8",
        "Hard disk size": "1 TB"
      }
    };
    http.Response response = await http.post(
      url,
      body: jsonEncode(postData),
      headers: {"Content-Type": "application/json"},
    );

    log(response.body);
    log("POST DATA");
  }

  void updateproductData() async {
    Map updateData = {
      "name": "Apple MacBook Pro 16",
      "data": {
        "year": 2020,
        "price": 180.99,
        "CPU model": "Intel Core i8",
        "Hard disk size": "2 TB"
      }
    };
    Uri url = Uri.parse(
        "https://api.restful-api.dev/objects/ff8081819782e69e0199af337c5a389e");
    http.Response response = await http.put(url,
        body: jsonEncode(updateData),
        headers: {"Content-Type": "application/json"});
    log(response.body);
    log("UPDATE DATA");
  }

  void deleteproductData() async {
    Uri url = Uri.parse(
        "https://api.restful-api.dev/objects/ff8081819782e69e0199af337c5a389e");
    http.Response response = await http.delete(url);
    log(response.body);
    log("DELETE DATA");
  }
}