import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class Spinkit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitFadingCube(
        color: Theme.of(context).primaryColor,
        size: 50,
      ),
    );
  }
}
