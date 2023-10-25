import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olx_app/ProfileScreen/controllers/profileController/profile_cubit.dart';
import 'package:olx_app/ProfileScreen/controllers/profileController/profile_states.dart';

import '../../../widgets/listview_wedget.dart';

class ProductsWidgets extends StatelessWidget {
  const ProductsWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProfileCubit cubit = ProfileCubit.get(context);
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('status', isEqualTo: "approved")
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
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
                }

                // return ListViewWidget(
                //   docId: cubit.items[index].id,
                //   itemColor: cubit.items[index].itemColor,
                //   img1: cubit.items[index].userImages[0],
                //   img2: cubit.items[index].userImages[1],
                //   img3: cubit.items[index].userImages[2],
                //   img4: cubit.items[index].userImages[3],
                //   img5: cubit.items[index].userImages[4],
                //   userImg: cubit.items[index].imgPro,
                //   name: cubit.items[index].userName,
                //   date: cubit.items[index].time,
                //   userId: cubit.items[index].id,
                //   itemModel: cubit.items[index].itemModel,
                //   postId: cubit.items[index].postId,
                //   itemPrice: cubit.items[index].itemPrice,
                //   description: cubit.items[index].description,
                //   lat: cubit.items[index].lat,
                //   lng: cubit.items[index].lng,
                //   address: cubit.items[index].address,
                //   userNumber: cubit.items[index].userNumber,
                // );

                );
          } else {
            return Text("there is no data");
          }
        },
      );
    });
  }
}
