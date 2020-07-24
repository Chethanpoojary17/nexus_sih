import 'package:flutter/material.dart';
import 'package:nexus_sih/screens/tabScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static Map<int, Color> color =
  {
    50:Color.fromRGBO(172, 29, 22, .1),
    100:Color.fromRGBO(	172, 29, 22, .2),
    200:Color.fromRGBO(	172, 29, 22, .3),
    300:Color.fromRGBO(	172, 29, 22, .4),
    400:Color.fromRGBO(	172, 29, 22, .5),
    500:Color.fromRGBO(	172, 29, 22, .6),
    600:Color.fromRGBO(	172, 29, 22, .7),
    700:Color.fromRGBO(	172, 29, 22, .8),
    800:Color.fromRGBO(	172, 29, 22, .9),
    900:Color.fromRGBO(	172, 29, 22, 1),
  };
  MaterialColor colorCustom = MaterialColor(0xFFac1d16, color);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData(
        primarySwatch: colorCustom,
        accentColor: Color(0xfff7c4c2),
      ),
      home: TabScreen(),
    );
  }
}
