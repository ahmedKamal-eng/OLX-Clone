import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx_app/DialogBox/error_dialog_box.dart';
import 'package:olx_app/ForgetPassword/forget_background.dart';
import 'package:olx_app/LoginScreen/login_screen.dart';
import 'package:olx_app/utils/my_colors.dart';

class ForgetBody extends StatelessWidget {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final TextEditingController _forgetPasswordController =
      TextEditingController();

  void _forgetPasswordSubmitForm(BuildContext context) async{
    if(_forgetPasswordController.text.isEmpty){
        Fluttertoast.showToast(msg: "please Enter your email", backgroundColor: Colors.red,textColor: Colors.white);
    }
    else {
      _auth.sendPasswordResetEmail(email: _forgetPasswordController.text.trim())
          .then((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }).catchError((e) {
        ErrorAlertDialog(message: e.toString(),);
        print(e.toString() + "**************************************");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ForgetBackground(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: size.height * .2,
                ),
                Text(
                  "Forget Password",
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: "Bebas",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Email address",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _forgetPasswordController,
                  onChanged: (val){
                     _forgetPasswordController.text=val;
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.deepPurple.withOpacity(.4),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 5,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 60,
                ),
                MaterialButton(
                  elevation: 20,
                  color: MyColors.luckyPoint,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  onPressed: () {
                    _forgetPasswordSubmitForm(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Reset Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
