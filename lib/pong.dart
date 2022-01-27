import 'package:flutter/material.dart';
import './ball.dart';
import './bat.dart';
import 'dart:math';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  //const Pong({Key? key}) : super(key: key);
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin{
  //double width;
  late double width;
  //double height;
  late double height;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  //Animation<double> animation;
  late Animation<double> animation;
  //AnimationController controller;
  late AnimationController controller;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;

  @override
  void initState() {

    super.initState();
    posX = 0;
    posY = 0;
    controller = AnimationController(
        //duration: const Duration(seconds: 3),
        duration: const Duration(seconds: 10000),
        vsync: this,
    );

    animation = Tween<double> (begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      //setState(() {
        //safeSetState((function) {
        safeSetState(() {
          /*posX++;
        posY++;*/
          /*
        (hDir == Direction.right)? posX += 1 : posX -= 1;
        (vDir == Direction.down)? posY += 1 : posY -= 1;*/
          /*(hDir == Direction.right)? posX += increment : posX -= increment;
          (vDir == Direction.down)? posY += increment : posY -= increment;*/
          (hDir == Direction.right)
              ?posX += ((increment * randX).round())
              :posX -= ((increment * randX).round());
          (vDir == Direction.down)
              ? posY += ((increment * randY).round())
              : posY -= ((increment * randY).round());
        });
        checkBorders();
      });

    //Must be under super.initState();
    controller.forward();

  }


  @override
  Widget build(BuildContext context) {
    //return Container();
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          height = constraints.maxHeight;
          width = constraints.maxWidth;
          batWidth = width / 5;
          batHeight = height / 20;


      //return Stack();
      return Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              right: 24,
              child: Text('Score(คะแนน): ' + score.toString()),
          ),

          Positioned(
              child: Ball(),
              //top: 0),
              top: posY,
              left: posX,),
          //Positioned(child: Bat(200, 25),
          //bottom: 0),

          Positioned(
          bottom: 0,

          left: batPosition,
          child: GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails update)
            => moveBat(update),
          child: Bat(batWidth, batHeight)
            ),
          ),
        ],
      );
    });
  }

  void checkBorders() {
    double diameter = 50;
    /*
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
    }
    if (posX >= width - 50 && hDir == Direction.right) {
      hDir = Direction.left;
    }
    /* Direction Down when ball to bottom then ball bounce back up
    if (posY >= height - 50 && vDir == Direction.down) {
      vDir = Direction.up;
    }*/

    if (posY >= height - 50 - batHeight && vDir == Direction.down) {
      //Check if the bat is here, otherwise loose
      if (posX >= (batPosition - 50) && posX <= (batPosition + batWidth + 50))
      {
        vDir = Direction.up;
      } else {
        controller.stop();
        dispose();
      }
    }

    if (posY <= 0 && vDir == Direction.up){
      vDir = Direction.down;
    }
    */
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    /* Direction Down when ball to bottom then ball bounce back up
    if (posY >= height - 50 && vDir == Direction.down) {
      vDir = Direction.up;
    }*/

    //check the bat position as well
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      //Check if the bat is here, otherwise loose
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter))
      {
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState(() {
          score++;
        });

      } else {
        controller.stop();
        //dispose();
        showMessage(context);
      }
    }

    if (posY <= 0 && vDir == Direction.up){
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  void moveBat (DragUpdateDetails update){
      //setState(() {
      //safeSetState((function){
      safeSetState((){
      batPosition += update.delta.dx;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void safeSetState (Function function){
    if (mounted && controller.isAnimating){
      setState(() {
        function();
      });
    }
  }

  double randomNumber() {
    // This is a number between 0.5 and 1.5;
    var ran = new Random();
    //int myNum = ran.nextInt(max)
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Game Over_(เกมส์พ่าย)'),
            content: Text('Would you like to play again?_(ต้องการเล่นใหม่ไหม)'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes_(ใช่)'),
                onPressed: (){
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score = 0;
                    });
                  Navigator.of(context).pop();
                  controller.repeat();
                },
              ),
              FlatButton(
                child: Text('No_(ไม่)'),
                onPressed: (){
                  Navigator.of(context).pop();
                  dispose();
                },
              )
            ],
          );});
  }



}


