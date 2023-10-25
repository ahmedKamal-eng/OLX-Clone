
import 'package:flutter/material.dart';


class TextFieldContainer extends StatelessWidget {

  final Widget child;
  TextFieldContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: size.width * .8,
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(.4),
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
