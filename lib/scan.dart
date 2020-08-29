import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:yuka_flutter/MyCustomForm.dart';
import 'package:http/http.dart' as http;
import 'package:basic_utils/basic_utils.dart';
import 'dart:convert' as convert;

class ScanPage extends StatefulWidget {
  @override
  ScanPageState createState() {
    return new ScanPageState();
  }
}

class ScanPageState extends State<ScanPage> {
  String result = "";
  String requestUrl = "";
  var data;

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      this.requestUrl = "https://world.openfoodfacts.org/api/v0/product/" +
          qrResult +
          ".json";
      
      this.data = await HttpUtils.getForJson(requestUrl);
      setState(() {
        this.data = this.data;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyCustomForm(this.result, this.data))
        );
        // les data sont bien la  cest juste qu il ya une limite dans le terminal https://stackoverflow.com/questions/56995212/flutter-dart-http-get-request-response-is-incomplete
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.result = "Permission Camera refuse";
        });
      } else {
        setState(() {
          this.result = "Erreure Inconnue $ex";
        });
      }
    } on FormatException {
      setState(() {
        this.result =
            "Tu as appuye sur le bouton retour avant de scanner un article";
      });
    } catch (ex) {
      setState(() {
        this.result = "Erreur Inconnue : $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Future<dynamic> result;
    Future<dynamic> openData;
    return Scaffold(
      appBar: AppBar(
        title: Text("Open Market"),
      ),
      body: Center(
        child: Text("Scanner un article pour voir ca composition",
            textAlign: TextAlign.center,
            style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt),
          label: Text("Scan"),
          onPressed: () => {
                _scanQR(),
              }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}