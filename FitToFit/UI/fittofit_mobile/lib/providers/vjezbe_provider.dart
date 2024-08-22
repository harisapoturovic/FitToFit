import 'dart:convert';

import 'package:fittofit_mobile/models/search_result.dart';
import 'package:fittofit_mobile/models/vjezbe.dart';

import 'base_provider.dart';

class VjezbeProvider extends BaseProvider<Vjezbe> {
  final String _endpoint = "Vjezbe";
  VjezbeProvider() : super("Vjezbe");

  @override
  Vjezbe fromJson(data) {
    return Vjezbe.fromJson(data);
  }

  Future<SearchResult<Vjezbe>> getRecommendedExercises(int korisnikId) async {
    var url = "${BaseProvider.baseUrl}$_endpoint/Recommend/$korisnikId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      SearchResult<Vjezbe> result = SearchResult<Vjezbe>();
      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }
}
