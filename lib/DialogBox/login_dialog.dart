
import 'package:flutter/material.dart';
import '../widgets/login_widget.dart';


class LoginAlertDialog extends StatelessWidget {
  final String message;
  LoginAlertDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(height: 10,),
           Text(message)
        ],
      ),

    );
  }
}
