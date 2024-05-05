import 'dart:convert';

import 'package:fittofit_admin/models/odabraniTermini.dart';
import 'package:fittofit_admin/models/profit.dart';
import 'package:fittofit_admin/models/rezervacijaStavke.dart';
import 'package:fittofit_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RezervacijeStavkeProvider extends BaseProvider<RezervacijaStavke> {
  RezervacijeStavkeProvider() : super("RezervacijaStavke");

  @override
  RezervacijaStavke fromJson(data) {
    return RezervacijaStavke.fromJson(data);
  }

  Future<List<OdabraniTermini>> getTop3Terms(String order) async {
    var url =
        "${BaseProvider.baseUrl}RezervacijaStavke/getTop3Terms?order=$order";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    Response response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => OdabraniTermini.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load top 3 terms');
    }
  }

  Future<Profit> getProfitForLast3Years() async {
    var url = "${BaseProvider.baseUrl}RezervacijaStavke/getProfitForLast3Years";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    Response response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      final dynamic data = jsonDecode(response.body);
      return Profit.fromJson(data);
    } else {
      throw Exception('Failed to load top 3 terms');
    }
  }
}
