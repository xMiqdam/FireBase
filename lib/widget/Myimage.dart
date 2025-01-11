import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  final String imageName;
  final EdgeInsets? margin;
  final double width;
  final double height;
  final double? borderRadius;
  final BoxFit? fit;
  final bool isAsset;

  const MyImage({
    Key? key,
    required this.imageName,
    this.margin,
    required this.width,
    required this.height,
    this.borderRadius,
    this.fit,
    this.isAsset = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 0),
          child: isAsset
              ? Image.asset(
            imageName,
            fit: fit ?? BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image, size: width);
            },
          )
              : Image.network(
            imageName,
            fit: fit ?? BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image, size: width);
            },
          ),
        ),
      ),
    );
  }
}