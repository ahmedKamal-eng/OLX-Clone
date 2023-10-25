import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:olx_app/ImageSliderScreen/image_slider_screen.dart';
import 'package:olx_app/utils/my_colors.dart';

import 'global_var.dart';

class ListViewWidget extends StatefulWidget {
  String docId,
      itemColor,
      img1,
      img2,
      img3,
      img4,
      img5,
      userImg,
      name,
      userId,
      itemModel,
      postId;
  String itemPrice, description, address, userNumber;
  DateTime date;
  double lat, lng;

  ListViewWidget(
      {required this.docId,
      required this.itemColor,
      required this.img1,
      required this.img2,
      required this.img3,
      required this.img4,
      required this.img5,
      required this.userImg,
      required this.name,
      required this.userId,
      required this.itemModel,
      required this.postId,
      required this.itemPrice,
      required this.description,
      required this.address,
      required this.userNumber,
      required this.date,
      required this.lat,
      required this.lng});

  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  Future<Future> showDialogForUpdateData(
      selectedDoc,
      oldUserName,
      oldPhoneNumber,
      oldItemPrice,
      oldItemName,
      oldItemColor,
      oldItemDescription,
      BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                'Update Data',
                style: TextStyle(
                    fontSize: 24, fontFamily: "Bebas", letterSpacing: 2.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: oldUserName,
                    decoration: InputDecoration(
                      hintText: "Enter Your Name",
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldUserName = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    initialValue: oldPhoneNumber,
                    decoration: InputDecoration(
                      hintText: "Enter Your Phone",
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldPhoneNumber = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    initialValue: oldItemPrice,
                    decoration: InputDecoration(
                      hintText: "Enter Item Price",
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldItemPrice = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    initialValue: oldItemName,
                    decoration: InputDecoration(
                      hintText: "Enter Item Name",
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldItemName = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    initialValue: oldItemColor,
                    decoration: InputDecoration(
                      hintText: "Enter Your Item color",
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldItemColor = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    initialValue: oldItemDescription,
                    decoration: InputDecoration(
                      hintText: "Enter Your Item description",
                    ),
                    onChanged: (value) {
                      setState(() {
                        oldItemDescription = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    upDateProfileNameOnExistingPosts(oldUserName);
                    _updateUserName(oldUserName, oldPhoneNumber);
                    await FirebaseFirestore.instance
                        .collection('items')
                        .doc(selectedDoc)
                        .update({
                      'userName': oldUserName,
                      'userNumber': oldPhoneNumber,
                      'itemPrice': oldItemPrice,
                      'itemModel': oldItemName,
                      'itemColor': oldItemColor,
                      'description': oldItemDescription,
                    }).whenComplete(() {
                      Fluttertoast.showToast(
                        msg: 'the data has been updated',
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.greenAccent,
                        textColor: Colors.black,
                      );
                    }).catchError((e) {
                      print(e.toString());
                    });
                  },
                  child: const Text(
                    'Update Now',
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  upDateProfileNameOnExistingPosts(oldUserName) async {
    FirebaseFirestore.instance
        .collection('items')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      for (int index = 0; index < snapshot.docs.length; index++) {
        String userProfileNameInPost = snapshot.docs[index]['userName'];
        if (userProfileNameInPost != oldUserName) {
          FirebaseFirestore.instance
              .collection('items')
              .doc(snapshot.docs[index].id)
              .update({'userName': oldUserName});
        }
      }
    });
  }

  Future _updateUserName(oldUserName, oldPhoneNumber) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'userName': oldUserName,
      'userNumber': oldPhoneNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        shape: Border.all(width: 0),
        color: Colors.blueGrey,
        elevation: 16,
        shadowColor: Colors.black54,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageSliderScreen(
                        title: widget.itemModel,
                        urlImage1: widget.img1,
                        urlImage2: widget.img2,
                        urlImage3: widget.img3,
                        urlImage4: widget.img4,
                        urlImage5: widget.img5,
                        itemColor: widget.itemColor,
                        userNumber: widget.userNumber,
                        description: widget.description,
                        address: widget.address,
                        itemPrice: widget.itemPrice,
                        lat: widget.lat,
                        lng: widget.lng,
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Image.network(
                    widget.img1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(widget.userImg),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.itemModel,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          DateFormat('dd MMM, yyyy - hh:mm a')
                              .format(widget.date)
                              .toString(),
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    widget.userId != uid
                        ? Padding(
                            padding: EdgeInsets.only(right: 50),
                            child: Column(
                              children: [],
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialogForUpdateData(
                                    widget.docId,
                                    widget.name,
                                    widget.userNumber,
                                    widget.itemPrice,
                                    widget.itemModel,
                                    widget.itemColor,
                                    widget.description,
                                    context,
                                  );
                                },
                                icon: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 27,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: MyColors.luckyPoint.withOpacity(.5),
                                          content: Text(
                                              'Are you sure you want to delete this item',style: TextStyle(color: Colors.white,fontSize: 20),),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("cancel")),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('items')
                                                      .doc(widget.postId)
                                                      .delete()
                                                      .catchError((e) {
                                                    print(e.toString() +
                                                        '###########################');
                                                  }).whenComplete(() {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          "Post has been deleted",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      fontSize: 18,
                                                    );
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text('delete'))
                                          ],
                                        );
                                      });
                                },
                                icon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.delete_forever,
                                    size: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
