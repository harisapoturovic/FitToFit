import 'dart:convert';
import 'package:fittofit_mobile/models/rezervacije.dart';
import 'package:fittofit_mobile/providers/base_provider.dart';

class RezervacijeProvider extends BaseProvider<Rezervacije> {
  final String _endpoint = "Rezervacije";

  RezervacijeProvider() : super("Rezervacije");

  @override
  Rezervacije fromJson(data) {
    return Rezervacije.fromJson(data);
  }

  Future<Rezervacije> cancel(int id) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/$id/cancel";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      final response = await http!.put(uri, headers: headers);

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        notifyListeners();
        return fromJson(data);
      } else {
        throw Exception(
            'Failed to cancel reservation. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }
}
