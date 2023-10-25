import 'package:flutter/material.dart';

class WelcomeBackground extends StatelessWidget {

 final Widget child;
  WelcomeBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "Assets/images/main_top.png",
              color: Colors.deepPurple.shade300,
              width: size.width * .3,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "Assets/images/main_bottom.png",
              color: Colors.deepPurple.shade300,
              width: size.width * .2,
            ),
          ),
          child
        ],
      ),
    );
  }
}
