import 'package:flutter/material.dart';
import 'package:olx_app/utils/my_colors.dart';
import 'package:olx_app/widgets/text_feild_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  RoundedPasswordField({
    required this.onChanged,
  });

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: isVisible,
        onChanged: widget.onChanged,
        cursorColor: MyColors.luckyPoint,
        decoration: InputDecoration(
            icon: Icon(
              Icons.password,
              color: MyColors.luckyPoint,
            ),
            hintText: "password",
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
            )),
      ),
    );
  }
}
