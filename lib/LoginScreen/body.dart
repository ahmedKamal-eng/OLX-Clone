import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_app/DialogBox/error_dialog_box.dart';
import 'package:olx_app/ForgetPassword/forget_password.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';
import 'package:olx_app/LoginScreen/background.dart';
import 'package:olx_app/SignUpScreen/sign_up_screen.dart';
import 'package:olx_app/widgets/already_have_an_account_check.dart';
import 'package:olx_app/widgets/rounded_button.dart';
import 'package:olx_app/widgets/rounded_input_field.dart';

import '../DialogBox/login_dialog.dart';
import '../widgets/global_var.dart';
import '../widgets/rounded_password_field.dart';

class LoginBody extends StatefulWidget {
  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {

    showDialog(context: context, builder: (_){
      return LoginAlertDialog(message: "Please Wait...",);
    });

    User? currentUser;


   await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text).then((auth){
          currentUser=auth.user;
          uid=currentUser!.uid;
   }).catchError((error){
     Navigator.pop(context);
     showDialog(context: context, builder: (context){
       return ErrorAlertDialog(message: error.message.toString());
     });
   });
   if(currentUser != null)
     {
       Navigator.pop(context);
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

     }
   else
     {
       print("error");
     }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * .02,
            ),
            Image.asset(
              "Assets/icons/login.png",
              height: size.height * .28,
            ),
            SizedBox(
              height: size.height * .02,
            ),
            RoundedInputField(
              hintText: "Email",
              onChanged: (val) {
                _emailController.text = val;
              },
              icon: Icons.person,
            ),
            RoundedPasswordField(
              onChanged: (val) {
                _passwordController.text = val;
              },
            ),
            SizedBox(
              height: size.height * .02,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(
                  "Forget Password?",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgetPasswordScreen(),
                    ),
                  );
                },
              ),
            ),
            RoundedButton(text: "Login", press: () {

              _passwordController.text.isNotEmpty&& _emailController.text.isNotEmpty ?_login():
                  showDialog(context: context, builder: (context){
                    return ErrorAlertDialog(message: "Please write email& password for login");
                  });

              _login();
            }),
            SizedBox(
              height: size.height * .02,
            ),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
              login: true,
            ),
          ],
        ),
      ),
    );
  }
}
