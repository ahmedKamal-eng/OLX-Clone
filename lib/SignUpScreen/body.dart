import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_app/DialogBox/error_dialog_box.dart';
import 'package:olx_app/ForgetPassword/forget_password.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';
import 'package:olx_app/LoginScreen/login_screen.dart';
import 'package:olx_app/SignUpScreen/signup_background.dart';
import 'package:olx_app/utils/my_colors.dart';
import 'package:olx_app/widgets/already_have_an_account_check.dart';
import 'package:olx_app/widgets/rounded_button.dart';
import 'package:olx_app/widgets/rounded_input_field.dart';
import 'package:olx_app/widgets/rounded_password_field.dart';

import '../widgets/global_var.dart';

class SignupBody extends StatefulWidget {
  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  File? _image;
  bool isLoading = false;
  String userPhotoUrl = '';
  final signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _getFromCamera() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedImage!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedImage!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        _image = File(croppedImage.path);
      });
    }
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please chose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text('get From camera'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text('get From Gallery'),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void submitFormOnSignUp() async {
    final isValid = signUpFormKey.currentState!.validate();
    if (isValid) {
      if (_image == null) {
        showDialog(
            context: context,
            builder: (context) {
              return  ErrorAlertDialog(
                message: "Please pick an Image",
              );
            });

        return;
      }

    }else{
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
          email: _emailEditingController.text.trim().toLowerCase(),
          password: _passwordEditingController.text.trim());
      final User? user = _auth.currentUser;
      uid = user!.uid;

      final ref = FirebaseStorage.instance
          .ref()
          .child("userImage")
          .child(uid + '.jpg');
      await ref.putFile(_image!);
      userPhotoUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        'userName': _nameEditingController.text.trim(),
        "id": uid,
        'userNumber': _phoneEditingController.text.trim(),
        'userEmail': _emailEditingController.text.trim(),
        'userImage': userPhotoUrl,
        'time': DateTime.now(),
        'status': "approved"
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString()+"##############################################");
      showDialog(context: context, builder: (context)=>ErrorAlertDialog(message: e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height,
        screenWidth = MediaQuery.of(context).size.width;

    return SignupBackground(
      child: SignupBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: signUpFormKey,
                child: InkWell(
                  onTap: () {
                    _showImageDialog();
                  },
                  child: CircleAvatar(
                    radius: screenWidth * .2,
                    backgroundColor: Colors.deepPurple.withOpacity(.4),
                    backgroundImage: _image == null ? null : FileImage(_image!),
                    child: _image == null
                        ? Icon(
                            Icons.camera_enhance,
                            size: screenWidth * .18,
                            color: MyColors.luckyPoint,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * .02,
              ),

              RoundedInputField(
                  hintText: "Name",
                  icon: Icons.person,
                  onChanged: (val) {
                    _nameEditingController.text = val;
                  }),
              RoundedInputField(
                  hintText: "Email",
                  icon: Icons.email,
                  onChanged: (val) {
                    _emailEditingController.text = val;
                  }),
              RoundedPasswordField(onChanged: (val) {
                _passwordEditingController.text = val;
              }),
              RoundedInputField(
                  hintText: "phone",
                  icon: Icons.phone,
                  onChanged: (val) {
                    _phoneEditingController.text = val;
                  }),


              const SizedBox(
                height: 5,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgetPasswordScreen()));
                  },
                  child: Text(
                    "Forget Password?",
                    style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              isLoading
                  ? Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                          color: MyColors.luckyPoint.withOpacity(.7),
                        ),
                      ),
                    )
                  : RoundedButton(
                      text: "Sign Up",
                      press: () {
                        submitFormOnSignUp();
                      }),
              SizedBox(
                height: screenHeight * .03,
              ),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                login: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
