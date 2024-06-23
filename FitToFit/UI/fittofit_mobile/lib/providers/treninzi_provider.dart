import 'package:fittofit_mobile/models/treninzi.dart';

import 'base_provider.dart';

class TreninziProvider extends BaseProvider<Treninzi> {
  TreninziProvider() : super("Treninzi");

  @override
  Treninzi fromJson(data) {
    return Treninzi.fromJson(data);
  }
}
