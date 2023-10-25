import 'package:flutter/material.dart';
import 'package:olx_app/LoginScreen/login_screen.dart';
import 'package:olx_app/SignUpScreen/sign_up_screen.dart';
import 'package:olx_app/WelcomeScreen/background.dart';
import 'package:olx_app/utils/my_colors.dart';
import 'package:olx_app/widgets/rounded_button.dart';

class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return WelcomeBackground(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("OLX App",style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.bold,
              color: MyColors.luckyPoint.withOpacity(.8),
              fontFamily: 'Signatra'
            ),),
            SizedBox(height: size.height * .01,),
            Image.asset("Assets/icons/chat.png",
              height: size.height * .4,
            ),
            RoundedButton(text: "LOGIN", press: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen(),),);
            },color: MyColors.luckyPoint.withOpacity(.6),),
            SizedBox(height: size.height* .01,),
            RoundedButton(text: "SIGN UP", press: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen(),),);

            }),
          ],
        ),
      ),
    );
  }
}
