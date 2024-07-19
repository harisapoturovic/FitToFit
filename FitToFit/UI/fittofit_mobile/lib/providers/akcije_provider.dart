import 'dart:convert';

import 'package:fittofit_mobile/models/akcije.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import 'base_provider.dart';

class AkcijeProvider extends BaseProvider<Akcije> {
  final String _endpoint = "Akcije";
  IOClient? _http;
  AkcijeProvider() : super("Akcije") {
    _http = IOClient(client);
  }

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
        return fromJson(data);
      } else {
        throw Exception('Unknown error');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<Akcije>> getAkcijeForTrening(int treningId) async {
    var url =
        "${BaseProvider.baseUrl}Akcije/getAkcijeForTrening?treningId=$treningId";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    Response response = await _http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Akcije.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load akcijes');
    }
  }
}
