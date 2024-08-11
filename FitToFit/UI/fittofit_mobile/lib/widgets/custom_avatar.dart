import 'dart:convert';

import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final double radius;
  final String base64Image;

  const CustomAvatar({required this.radius, required this.base64Image});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: Image.memory(
        base64Decode(base64Image),
        fit: BoxFit.cover,
      ).image,
    );
  }
}
