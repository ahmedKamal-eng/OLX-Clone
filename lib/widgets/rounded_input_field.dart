import 'package:flutter/material.dart';
import 'package:olx_app/utils/my_colors.dart';
import 'package:olx_app/widgets/text_feild_container.dart';

class RoundedInputField extends StatelessWidget {

  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  RoundedInputField({
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: MyColors.luckyPoint,
        decoration: InputDecoration(
          icon: Icon(icon,color: MyColors.luckyPoint,),
          hintText: hintText,
          border: InputBorder.none
        ),
      ),
    );
  }
}
