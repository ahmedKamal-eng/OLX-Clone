import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olx_app/ProfileScreen/controllers/profileController/profile_states.dart';
import 'package:olx_app/ProfileScreen/models/product_model.dart';
import 'package:olx_app/ProfileScreen/models/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  UserModel? user;

  getUserProfileDate() async {
    emit(ProfileDataLoading());
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) {
      user = UserModel.fromJson(snapshot.data());
      emit(ProfileDataSuccess(UserModel.fromJson(snapshot.data())));
    }).catchError((e) {
      emit(ProfileDataFailure(e.toString()));
    });
  }

  // List<Product> items=[];

  //  getUserPosts() async {
  //   emit(UserPostsLoading());
  //   FirebaseFirestore.instance
  //       .collection('items')
  //       .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .where('status', isEqualTo: "approved")
  //       .get()
  //       .then((snapshot) {
  //         for(var item in snapshot.docs){
  //           items.add(Product.fromFirestore(item));
  //         }
  //         emit(UserPostsSuccess(items));
  //   }).catchError((e){
  //     emit(UserPostsFailure(e.toString()));
  //     print(e.toString()+"##############");
  //   });
  // }

  updateUserName(String newName) async {
    emit(UpdateUserNameLoading());

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'userName': newName});

      List<String> userItemsIds = [];
      await FirebaseFirestore.instance
          .collection('items')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get().then((data) =>
      {
        for (var item in data.docs)
          {
            userItemsIds.add(item.data()['postId'])
          }
      }).whenComplete(() async {
        for (String postId in userItemsIds) {
          await FirebaseFirestore.instance.collection('items')
              .doc(postId)
              .update(
              {'userName': newName});
        }
      });
      emit(UpdateUserNameSuccess());
    }catch(e){
      emit(UpdateUserNameFailure());
    }
  }
}
