import 'package:flutter/material.dart';
import 'package:olx_app/utils/my_colors.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  AlreadyHaveAnAccountCheck({this.login = true, required this.press});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? " Don't have an account " : "Already have an account ",
          style: TextStyle(
              color: MyColors.luckyPoint.withOpacity(.7),
              fontStyle: FontStyle.italic),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" : "Login",
            style: TextStyle(
                color: MyColors.luckyPoint,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,),
          ),
        )
      ],
    );
  }
}
