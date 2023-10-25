import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:olx_app/LoginScreen/login_screen.dart';
import 'package:olx_app/ProfileScreen/view/profile_screen.dart';
import 'package:olx_app/SearchProduct/search_product.dart';
import 'package:olx_app/UploadAdScreen/upload_ad_screen.dart';
import 'package:olx_app/widgets/listview_wedget.dart';

import '../utils/my_colors.dart';
import '../widgets/global_var.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  getMyData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((result) {
      setState(() {
        userImageUrl = result.data()!['userImage'];
        getUserName = result.data()!['userName'];
      });
    });
  }

  getUserAddress() async {
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = newPosition;
    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark placemark = placemarks![0];

    String newCompleteAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare},'
        '${placemark.subThoroughfare} ${placemark.locality},'
        '${placemark.subAdministrativeArea},'
        '${placemark.administrativeArea} ${placemark.postalCode},'
        '${placemark.country}';

    completeAddress = newCompleteAddress;
  }

  @override
  void initState() {
    super.initState();
    getUserAddress();
    uid = FirebaseAuth.instance.currentUser!.uid;
    userEmail = FirebaseAuth.instance.currentUser!.email!;
    getMyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Screen",
          style: TextStyle(fontSize: 30, fontFamily: 'Signatra'),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                icon: Icon(Icons.person)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchProduct()));
                },
                icon: Icon(Icons.search)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: MyColors.luckyPoint.withOpacity(.4),
                        title: Text(
                          "Sign Out",
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          "Are you sure you want to sign out",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                uid = '';
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: Text("oK")),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("cancel")),
                        ],
                      );
                    });
              },
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "add post",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UploadAdScreen()));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_upload,),
                Text('new ad',)
              ],
            ),
          ),
          SizedBox(height: 100,)
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context,index){
                 return ListViewWidget(
                   docId: snapshot.data.docs[index].id,
                   itemColor: snapshot.data.docs[index]['itemColor'],
                   img1: snapshot.data.docs[index]['userImage1'],
                   img2: snapshot.data.docs[index]['userImage2'],
                   img3: snapshot.data.docs[index]['userImage3'],
                   img4: snapshot.data.docs[index]['userImage4'],
                   img5: snapshot.data.docs[index]['userImage5'],
                   userImg: snapshot.data.docs[index]['imgPro'],
                   name: snapshot.data.docs[index]['userName'],
                   date: snapshot.data.docs[index]['time'].toDate(),
                   userId: snapshot.data.docs[index]['id'],
                   itemModel: snapshot.data.docs[index]['itemModel'],
                   postId: snapshot.data.docs[index]['postId'],
                   itemPrice: snapshot.data.docs[index]['itemPrice'],
                   description: snapshot.data.docs[index]['description'],
                   lat: snapshot.data.docs[index]['lat'],
                   lng: snapshot.data.docs[index]['lng'],
                   address: snapshot.data.docs[index]['address'],
                   userNumber: snapshot.data.docs[index]['userNumber'],

                 );
              },
              itemCount: snapshot.data.docs.length,
              );
            } else {
              return Center(
                child: Text("there is no data"),
              );
            }
          }

          return Text('somethig went wrong');
        },
      ),
    );
  }
}
