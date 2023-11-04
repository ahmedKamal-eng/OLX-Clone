
import 'package:flutter/material.dart';
import 'package:olx_app/utils/my_colors.dart';

class SignupBackground extends StatelessWidget {

  final Widget child;
  SignupBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width:double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            height: size.height * .15,
            child: Image.asset("Assets/images/signup_top.png",color: MyColors.luckyPoint.withOpacity(.6),),),
          Positioned(
            bottom: 0,
            left: 0,
            height: size.height * .1,

            child: Image.asset("Assets/images/main_bottom.png",color:  MyColors.luckyPoint.withOpacity(.6),),),
          child
        ],
      ),
    );
  }
}
