import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authorization{
  static String? username;
  static String? password;
}

Image imageFromBase64String(String base64Image) {
  return Image.memory(base64Decode(base64Image));
}

Future<void> setUserName(String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}

Future<String?> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}