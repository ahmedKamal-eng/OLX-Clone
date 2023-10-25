import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:olx_app/DialogBox/login_dialog.dart';
import 'package:olx_app/HomeScreen/home_screen.dart';
import 'package:olx_app/utils/my_colors.dart';
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';

import '../widgets/global_var.dart';

class UploadAdScreen extends StatefulWidget {
  @override
  State<UploadAdScreen> createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {
  String postId = Uuid().v4();
  bool uploading = false, next = false;
  List<File> _image = [];

  List<String> urlsList = [];
 final  FirebaseAuth _auth = FirebaseAuth.instance;

  String name = '';
  String phoneNo = '';

  double val = 0;



  String itemPrice = '';
  String itemModel = '';
  String itemColor = '';
  String description = '';



  chooseImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image.add(File(pickedFile!.path));
    });
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      var ref = FirebaseStorage.instance
          .ref()
          .child("image/${Path.basename(img.path)}");

      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          urlsList.add(value);
          i++;
        });
      });
    }
  }

  getNameOfUser() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!["userName"];
          phoneNo = snapshot.data()!["userNumber"];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getNameOfUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          next ? "Please write Items info" : "Chose  Item  Images",
          style: const TextStyle(
            fontFamily: 'Signatra',
            fontSize: 30,
          ),
        ),
        actions: [
          next
              ? Container()
              : ElevatedButton(
                  onPressed: () {
                    if (_image.length == 5) {
                      setState(() {
                        uploading = true;
                        next = true;
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "please seclect 5 images",
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          gravity: ToastGravity.CENTER);
                    }
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
        ],
      ),
      body: next
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Enter Item Price",
                          labelText: "Price",
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        itemPrice = value;
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Enter Item Name",
                          labelText: "Name",
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        itemModel = value;
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Enter Item color",
                          labelText: "Color",
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        itemColor = value;
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: "write some item description",
                          labelText: "Description",
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        description = value;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.luckyPoint,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return LoginAlertDialog(
                                    message: "Uploading...");
                              });
                          uploadFile().whenComplete(() {
                            FirebaseFirestore.instance
                                .collection("items")
                                .doc(postId)
                                .set({
                              'userName': name,
                              'id': _auth.currentUser!.uid,
                              'postId': postId,
                              'userNumber': phoneNo,
                              'itemPrice': itemPrice,
                              'itemModel': itemModel,
                              'itemColor': itemColor,
                              'description': description,
                              'userImage1': urlsList[0].toString(),
                              'userImage2': urlsList[1].toString(),
                              'userImage3': urlsList[2].toString(),
                              'userImage4': urlsList[3].toString(),
                              'userImage5': urlsList[4].toString(),
                              'imgPro': userImageUrl,
                              'lat':position!.latitude,
                              'lng':position!.longitude,
                              'address': completeAddress,
                              'time':DateTime.now(),
                              'status': 'approved',
                            });

                            Fluttertoast.showToast(msg: "Date added successfully...",backgroundColor: Colors.greenAccent,textColor: Colors.black);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                              return HomeScreen();
                            }));

                          }).catchError((onError){
                            print(onError.toString());
                          });
                        },
                        child: Text(
                          "upload",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: _image.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3 - 4,
                                  height:
                                      MediaQuery.of(context).size.width / 3 - 7,
                                  color: Colors.black38,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                    ),
                                    onPressed:_image.length == 5?(){
                                      Fluttertoast.showToast(msg: "con not add more than 5 images",backgroundColor: Colors.redAccent,textColor: Colors.black);
                                    }:() {
                                      !uploading ? chooseImage() : null;
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image[index - 1]),
                                        fit: BoxFit.cover)),
                              );
                      }),
                ),
                uploading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Uploading... ",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CircularProgressIndicator(
                              value: val,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  MyColors.luckyPoint),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
    );
  }
}
