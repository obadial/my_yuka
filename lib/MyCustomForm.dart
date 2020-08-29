import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:yuka_flutter/scan.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyCustomForm extends StatefulWidget {
  final String barreCode;
  final Map<String, dynamic> data;

  const MyCustomForm(this.barreCode, this.data);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String _category = "";
  String value_product = "";
  String value_price = "";

  String result = "";
  String requestUrl = "";
  var product;
  var message = "";

    Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      this.requestUrl = "https://world.openfoodfacts.org/api/v0/product/" +
          qrResult +
          ".json";

      HttpUtils.getForJson(requestUrl).then((product) => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyCustomForm(this.result, product))
        )
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

Widget checkData(data, name, text) {
  var e = data['product'][name];
  if (e != "") {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      Text(e),
      SizedBox(height: 10.0),
    ]);
  }
  return Container();
}

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['product']['product_name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(widget.data['product']['image_front_small_url'])),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Text(widget.data['product']['product_name'], style: Theme.of(context).textTheme.title),
                    SizedBox(height: 5.0,),
                    Text(widget.data['product']['brands'], style: TextStyle(color: Colors.black54)),
                    Divider(),
                    SizedBox(height: 5.0),
                    this.checkData(widget.data, 'categories', 'Type'),
                    this.checkData(widget.data, 'ingredients_text_fr', 'Ingredients'),
                    this.checkData(widget.data, 'allergens_from_ingredients', 'Allergènes'),
                    this.checkData(widget.data, 'stores', 'Magasins'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child:
              FloatingActionButton.extended(
                icon: Icon(Icons.camera_alt),
                label: Text("Scanner un autre article"),
                onPressed: () => {
                  _scanQR(),
                }),
              
                // FlatButton.icon(
                //   color: Colors.blue,
                //   textColor: Colors.white,
                //   icon: Icon(Icons.camera_alt),
                //   label: Text("Scanner un autre article"),
                //   onPressed: () => {
                //     _scanQR()
                //   },
                // ),
            )
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:basic_utils/basic_utils.dart';

// class MyCustomForm extends StatefulWidget {
//   final String barreCode;
//   final Map<String, dynamic> data;

//   const MyCustomForm(this.barreCode, this.data);

//   @override
//   MyCustomFormState createState() {
//     return MyCustomFormState();
//   }
// }

// class MyCustomFormState extends State<MyCustomForm> {
//   final _formKey = GlobalKey<FormState>();
//   String _category = "";
//   String value_product = "";
//   String value_price = "";
//   var message = "";
//   @override
//   Widget build(BuildContext context) {
//     print("data open:");
//    print(widget.data);
//    print("barrecode:");
//    print(widget.barreCode);
//     return SafeArea(
//       child: Scaffold(
//         body: Form(
//           key: _formKey,
//           child: Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Code Barre : ${widget.barreCode..toString()}",
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                // Text(
//                 //  "Present en Bdd : ${this.message}",
//                 //  style: TextStyle(fontSize: 20),
//                 //),
//                 //SizedBox(
//                  // height: 10,
//                 //),
//                 Text(
//                   "Nom du produit :",
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 TextFormField(
//                   validator: (valueProduct) {
//                     if (valueProduct.isEmpty) {
//                       return 'attention , il manque le nom du produit';
//                     }
//                     this.value_product = valueProduct;
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Prix :",
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 TextFormField(
//                   keyboardType: TextInputType.number,
//                   validator: (valuePrice) {
//                     if (valuePrice.isEmpty) {
//                       return 'attention où est le prix :) ';
//                     }
//                     this.value_price = valuePrice;
//                     return null;
//                   },
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Categorie :",
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 Center(
//                   child: Column(
//                     children: <Widget>[
//                       ListTile(
//                         title: const Text('Vitale'),
//                         leading: Radio(
//                           value: "vitale",
//                           groupValue: _category,
//                           onChanged: (value) {
//                             setState(
//                               () {
//                                 _category = value;
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                       ListTile(
//                         title: const Text('Non vitale'),
//                         leading: Radio(
//                           value: "non vitale",
//                           groupValue: _category,
//                           onChanged: (value) {
//                             setState(
//                               () {
//                                 _category = value;
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Center(
//                   child: RaisedButton(
//                     onPressed: () {
//                       if (_formKey.currentState.validate()) {
//                         return showDialog<void>(
//                           context: context,
//                           barrierDismissible: false, // user must tap button!
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text("Confirmation :"),
//                               content: Text("Nom du produit : " +
//                                   this.value_product +
//                                   "\nPrix : " +
//                                   this.value_price),
//                               actions: <Widget>[
//                                 FlatButton(
//                                   child: Text("Close"),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                                 FlatButton(
//                                   child: Text("Confirmer"),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                     // Scaffold.of(context).showSnackBar(SnackBar(
//                                     //    content: Text('Données mise a jour')));
//                                     //Navigator.of(context).pop();
//                                   },
//                                 )
//                               ],
//                             );
//                           },
//                         );
//                       }
//                     },
//                     child: Text('Envoyer'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
