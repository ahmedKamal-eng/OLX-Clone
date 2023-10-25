import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:olx_app/ProfileScreen/controllers/profileController/profile_cubit.dart';
import 'package:olx_app/ProfileScreen/controllers/profileController/profile_states.dart';
import 'package:olx_app/ProfileScreen/models/user_model.dart';
import 'package:olx_app/ProfileScreen/view/widgets/products_widgets.dart';
import 'package:olx_app/utils/my_colors.dart';

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({Key? key}) : super(key: key);

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  UserModel? userModel;
  @override
  void initState() {
    // BlocProvider.of<ProfileCubit>(context).getUserProfileDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? newName;
    ProfileCubit cubit = ProfileCubit.get(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
      if (userModel != null) {
        return Container(
          width: double.infinity,
          color: MyColors.luckyPoint,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(screenWidth * .2),

              ),
            ),
            child: SingleChildScrollView(
               physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight * .05,
                  ),
                  CircleAvatar(
                    radius: screenWidth * .21,
                    backgroundColor: MyColors.luckyPoint,
                    child: CircleAvatar(
                      radius: screenWidth * .20,
                      backgroundImage: NetworkImage(userModel!.userImage),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * .015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userModel!.userName,
                        style: TextStyle(
                          fontSize: 30,
                          color: MyColors.luckyPoint,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * .1,
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(context: context, builder: (context){
                           return   AlertDialog(
                              content: state is UpdateUserNameLoading ? Center(child: CircularProgressIndicator(),): TextFormField(
                                initialValue: userModel!.userName,
                                onChanged:(val){
                                  newName=val;
                                } ,
                              ),

                              actions: [
                                ElevatedButton(onPressed: (){
                                  if(newName != null)
                                    {
                                      cubit.updateUserName(newName!);
                                      cubit.getUserProfileDate();

                                      Navigator.pop(context);
                                    }

                                }, child: Text("Update")),
                              ],
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: MyColors.luckyPoint,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       userModel!.userEmail,
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //         color: MyColors.luckyPoint,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: screenWidth * .05,
                  //     ),
                  //     IconButton(
                  //         onPressed: () {},
                  //         icon: const Icon(
                  //           Icons.edit,
                  //           color: MyColors.luckyPoint,
                  //           size: 30,
                  //         ))
                  //   ],
                  // ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: 3,
                    width: double.infinity,
                    color: Colors.white,
                  ),

                  Text(
                    "Your Posts",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: MyColors.luckyPoint),
                  ),

                  Container(
                      color: Colors.white,
                      child: ProductsWidgets()),
                ],
              ),
            ),
          ),
        );
      } else if (state is ProfileDataLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Center(
          child: Text('something wrong'),
        );
      }
    }, listener: (context, state) {
      if (state is ProfileDataSuccess) {
        userModel = state.userModel;
      }

      if(state is UpdateUserNameSuccess){
        Fluttertoast.showToast(msg: 'UserName Updated Successfully',backgroundColor: Colors.greenAccent,textColor: Colors.black);
      }
      if(state is UpdateUserNameFailure){
        Fluttertoast.showToast(msg: 'Something Wrong',backgroundColor: Colors.redAccent,textColor: Colors.black);
      }


    });
  }
}
