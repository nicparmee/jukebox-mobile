import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Loading screen
class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
    return Container(
        color: Colors.black38,
        child: Center(
          child: SpinKitChasingDots(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}