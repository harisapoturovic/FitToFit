import 'package:fittofit_mobile/models/akcijeTreninzi.dart';

import 'base_provider.dart';

class AkcijeTreninziProvider extends BaseProvider<AkcijeTreninzi> {
  AkcijeTreninziProvider() : super("AkcijeTreninzi");

  @override
  AkcijeTreninzi fromJson(data) {
    return AkcijeTreninzi.fromJson(data);
  }
}
