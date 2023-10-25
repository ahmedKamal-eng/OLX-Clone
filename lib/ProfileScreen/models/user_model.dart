import 'package:intl/intl.dart';

class UserModel {
  final String id;
  final String status;
  final DateTime time;
  final String userEmail;
  final String userImage;
  final String userName;
  final String userNumber;

  UserModel(this.id, this.status, this.time,this.userEmail, this.userImage,
      this.userName, this.userNumber);

  factory UserModel.fromJson(data) {
    return UserModel(
        data['id'],
        data['status'],
        data['time'].toDate(),
        data['userEmail'],
        data['userImage'],
        data['userName'],
        data['userNumber']);
  }

}
