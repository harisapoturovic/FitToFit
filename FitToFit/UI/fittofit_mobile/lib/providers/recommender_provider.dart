import 'dart:convert';
import 'dart:io';

import 'package:fittofit_mobile/models/recommender.dart';
import 'package:fittofit_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class RecommenderProvider extends ChangeNotifier {
  String? _baseUrl;
  final String _endpoint = "Recommender";

  HttpClient client = HttpClient();
  IOClient? http;

  RecommenderProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://192.168.88.227:5058/");

    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
  }

  Future<Recommender> getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return Recommender.fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future trainData() async {
    var url = "$_baseUrl/TrainModelAsync";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await post(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future deleteData() async {
    var url = "$_baseUrl/ClearRecommendations";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    Response response = await delete(uri, headers: headers);
    if (isValidResponse(response)) {
    } else {
      throw Exception("Unknown error");
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else {
      print(response.body);
      throw Exception("Something bad happened, please try again.");
    }
  }

  Map<String, String> createHeaders() {
    String username = Authorization.username ?? "";
    String password = Authorization.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }
}
