import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String textButton;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets margin;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry borderRadius;

  const MyButton({
    super.key,
    required this.textButton,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    required this.borderRadius,
    this.padding,
    required this.fontSize,
    required this.fontWeight,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: Text(
          textButton,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}