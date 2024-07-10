import 'package:flutter/material.dart';

class Plate extends StatelessWidget {
  final double width;
  final double height;

  const Plate({super.key, this.width = 350, this.height = 350});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.white, Colors.grey.shade200],
          stops: [0.7, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
            offset: Offset(5, 5),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 10,
            spreadRadius: 5,
            offset: Offset(-5, -5),
          ),
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 20,
            spreadRadius: -15,
          ),
        ],
      ),
    );
  }
}