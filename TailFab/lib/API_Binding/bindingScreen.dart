import 'dart:developer';
import 'package:firebaseauth/API_Binding/bindingmodel.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class productScreen extends StatefulWidget {
  const productScreen({super.key});

  @override
  State<productScreen> createState() => _productScreenState();
}

class _productScreenState extends State<productScreen> {
  @override
  Devicedatamodel devicedatamodelObj = Devicedatamodel();
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  devicedatamodelObj.getproductData();
                },
                child: Text("Get")),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  devicedatamodelObj.postproductData();
                },
                child: Text("Post")),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  devicedatamodelObj.updateproductData();
                },
                child: Text("Update")),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  devicedatamodelObj.deleteproductData();
                },
                child: Text("Delete")),
          ],
        ),
      ),
    );
  }
}