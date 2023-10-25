import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olx_app/ProfileScreen/controllers/profileController/profile_cubit.dart';
import 'package:olx_app/ProfileScreen/view/widgets/profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getUserProfileDate(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Profile Screen",
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Signatra',
            ),
          ),

        ),
        body: ProfileScreenBody(),

      ),
    );
  }
}
