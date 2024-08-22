import 'dart:convert';

import 'package:fittofit_admin/models/akcije.dart';
import 'package:http/http.dart'as http; 
import 'package:http/http.dart';

import 'base_provider.dart';

class AkcijeProvider extends BaseProvider<Akcije> {
  final String _endpoint = "Akcije";
  AkcijeProvider() : super("Akcije");

  @override
  Akcije fromJson(data) {
    return Akcije.fromJson(data);
  }

  Future<Akcije> archive(int id) async {
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

  Future<Akcije> activate(int id) async {
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
}
