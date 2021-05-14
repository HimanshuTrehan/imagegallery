import 'package:flutter/material.dart';

import 'Location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalKey<NavigatorState>(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Location(),
    );
  }
}
