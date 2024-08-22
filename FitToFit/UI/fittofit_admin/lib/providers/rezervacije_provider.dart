import 'dart:convert';

import 'package:fittofit_admin/models/rezervacije.dart';
import 'package:fittofit_admin/providers/base_provider.dart';
import 'package:http/http.dart';
import 'package:http/http.dart'as http; 

class RezervacijeProvider extends BaseProvider<Rezervacije>
{
  final String _endpoint = "Rezervacije";
  RezervacijeProvider() : super("Rezervacije");
  
  @override
  Rezervacije fromJson(data) {
  return Rezervacije.fromJson(data);
  }

  Future<Rezervacije> archive(int id) async {
      var url = "${BaseProvider.baseUrl}$_endpoint/$id/archive";
      var uri = Uri.parse(url);
      var headers = createHeaders();

    try {
      Response response = await http.put(uri, headers: headers);
      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        notifyListeners();
        return fromJson(data);
      } else {
        throw Exception('Unknown error');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<Rezervacije> activate(int id) async {
      var url = "${BaseProvider.baseUrl}$_endpoint/$id/activate";
      var uri = Uri.parse(url);
      var headers = createHeaders();

    try {
      Response response = await http.put(uri, headers: headers);
      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        notifyListeners();
        return fromJson(data);
      } else {
        throw Exception('Unknown error');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<Rezervacije> refuse(int id) async {
      var url = "${BaseProvider.baseUrl}$_endpoint/$id/refuse";
      var uri = Uri.parse(url);
      var headers = createHeaders();

    try {
      Response response = await http.put(uri, headers: headers);
      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        notifyListeners();
        return fromJson(data);
      } else {
        throw Exception('Unknown error');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

   Future<Rezervacije> cancel(int id) async {
      var url = "${BaseProvider.baseUrl}$_endpoint/$id/cancel";
      var uri = Uri.parse(url);
      var headers = createHeaders();

    try {
      Response response = await http.put(uri, headers: headers);
      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        notifyListeners();
        return fromJson(data);
      } else {
        throw Exception('Unknown error');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}