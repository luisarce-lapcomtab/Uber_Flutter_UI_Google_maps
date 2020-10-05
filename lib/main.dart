import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Page/home_page.dart';
import 'State/state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Searching(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.white),
        home: MyHomePage(),
      ),
    );
  }
}
