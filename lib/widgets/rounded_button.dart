import 'package:flutter/material.dart';
import 'package:olx_app/utils/my_colors.dart';

class RoundedButton extends StatelessWidget {
  final String? text;
  final VoidCallback press;
  final Color color, textColor;

  RoundedButton({
    required this.text,
    required this.press,
    this.color = MyColors.luckyPoint,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 1),
      width: size.width * .7,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
          ),
          child: Text(text!,style: TextStyle(color: textColor,fontSize: 22),),
          onPressed: press,
        ),
      ),
    );
  }
}
