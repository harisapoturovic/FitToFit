import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Authorization {
  static String? username;
  static String? password;
}

Image imageFromBase64String(String base64Image) {
  return Image.memory(base64Decode(base64Image));
}

String formatDate(DateTime? dateTime) {
  return DateFormat('dd.MM.yyyy').format(dateTime!);
}

String formatDateForJson(DateTime dateTime) {
  return dateTime.toIso8601String();
}
