

import 'package:olx_app/ProfileScreen/models/user_model.dart';

import '../../models/product_model.dart';

abstract class ProfileState{}

class ProfileInitialState extends ProfileState{}

// get profile data states
class ProfileDataLoading extends ProfileState{}

class ProfileDataFailure extends ProfileState{
  final String errorMessage;
  ProfileDataFailure(this.errorMessage);

}

class ProfileDataSuccess extends ProfileState{
  final UserModel userModel;
  ProfileDataSuccess(this.userModel);
}

// get user posts states
class UserPostsLoading extends ProfileState{}

class UserPostsFailure extends ProfileState{
  final String errorMessage;
  UserPostsFailure(this.errorMessage);

}

class UserPostsSuccess extends ProfileState{
  final List<Product> products;
  UserPostsSuccess(this.products);
}


// update user name states
class UpdateUserNameLoading extends ProfileState{}
class UpdateUserNameSuccess extends ProfileState{}
class UpdateUserNameFailure extends ProfileState{}