import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nexus_sih/login/login_page.dart';
import 'package:nexus_sih/screens/profileScreen.dart';
import 'package:nexus_sih/screens/tabScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  await GetStorage.init();
  runApp(MyApp());
}

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
  final box=GetStorage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sevak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor:Color(0xfffff3f3),
      ),
      home:(box.hasData('currentUid'))?TabScreen():LoginScreen(),
    );
  }
}
