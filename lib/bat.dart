import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  //const Bat({Key? key}) : super(key: key);
  final double width;
  final double height;
  Bat (this.width, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.blue[900],
      ),
    );
  }
}
