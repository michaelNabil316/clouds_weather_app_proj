import 'package:flutter/material.dart';
import '../constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController ctrl;
  final String? hintTitle;
  final String? Function(String?)? validFun;
  final bool havePerfixIcon;
  final void Function(String)? onChange;
  const CustomTextField({
    Key? key,
    required this.ctrl,
    this.validFun,
    this.hintTitle,
    this.onChange,
    required this.havePerfixIcon,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isSecure = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.havePerfixIcon ? isSecure : false,
      controller: widget.ctrl,
      decoration: kTextFieldDecoration.copyWith(
        hintText: widget.hintTitle,
        prefixIcon: widget.havePerfixIcon
            ? GestureDetector(
                child: Icon(isSecure
                    ? Icons.visibility_off
                    : Icons.remove_red_eye_outlined),
                onTap: () {
                  setState(() {
                    isSecure = !isSecure;
                  });
                },
              )
            : null,
      ),
      validator: widget.validFun,
      onChanged: widget.onChange,
    );
  }
}
