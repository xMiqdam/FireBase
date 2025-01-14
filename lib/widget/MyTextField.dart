import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final IconData icon;
  final Color textFieldColor;
  final Color textColor;

  const MyTextField({
    Key? key,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    required this.icon,
    required this.textFieldColor,
    required this.textColor,
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword && !_isPasswordVisible,
        style: TextStyle(color: widget.textColor),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.textColor.withOpacity(0.6)),
          prefixIcon: Icon(
            widget.icon,
            color: widget.textColor,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: widget.textColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: widget.textFieldColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }
}
