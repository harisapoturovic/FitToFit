import 'package:fittofit_mobile/models/treninziClanarine.dart';

import 'base_provider.dart';

class TreninziClanarineProvider extends BaseProvider<TreninziClanarine> {
  TreninziClanarineProvider() : super("TreninziClanarine");

  @override
  TreninziClanarine fromJson(data) {
    return TreninziClanarine.fromJson(data);
  }
}
