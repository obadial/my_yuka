  
import 'package:flutter/material.dart';
import 'package:yuka_flutter/login_page.dart';
import 'package:yuka_flutter/scan.dart';
import 'package:yuka_flutter/MyCustomForm.dart';

void main() {
 runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    Future<String> yolo;
    return MaterialApp(
            title: 'Yuka Flutter',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => LoginPage(),
              '/scan': (context) => ScanPage(),
            }
      );
  }
}