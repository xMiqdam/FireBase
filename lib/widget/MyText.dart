import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const MyText({
    Key? key,
    required this.text,
    this.style,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? TextStyle(fontSize: 16, color: Colors.black), // Gaya default
      textAlign: textAlign ?? TextAlign.start, // Penyesuaian alignment default
    );
  }
}
