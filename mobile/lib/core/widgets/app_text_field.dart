import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {

  final String? hintText;
  final bool obscureText;
  final bool isPassword;
  final VoidCallback? onPasswordToggle;
  final FormFieldValidator<String?>? validator;
  final TextEditingController? controller;

  const AppTextField({
    super.key, 
    this.hintText,
    this.obscureText = false,
    this.isPassword = false,
    this.onPasswordToggle,
    this.validator,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: .center,
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[200]!, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[300]!, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[300]!, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[300]!, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 14
        ),
        suffixIcon: isPassword ? Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: onPasswordToggle, 
            child: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined)
          ),
        ) : null
      ),
    );
  }
}
