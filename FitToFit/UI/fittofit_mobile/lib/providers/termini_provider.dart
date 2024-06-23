import 'package:fittofit_mobile/models/termini.dart';

import 'base_provider.dart';

class TerminiProvider extends BaseProvider<Termini> {
  TerminiProvider() : super("Termini");

  @override
  Termini fromJson(data) {
    return Termini.fromJson(data);
  }
}
