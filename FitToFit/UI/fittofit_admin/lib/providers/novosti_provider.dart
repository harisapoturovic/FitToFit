import 'dart:convert';
import 'package:fittofit_admin/models/novosti.dart';
import 'package:fittofit_admin/models/search_result.dart';
import 'package:fittofit_admin/providers/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/util.dart';

class NovostiProvider extends BaseProvider<Novosti>
{
  NovostiProvider() : super("Novosti");
  
  @override
  Novosti fromJson(data) {
  return Novosti.fromJson(data);
  }
}