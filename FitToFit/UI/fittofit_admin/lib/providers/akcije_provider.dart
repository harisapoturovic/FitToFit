import 'package:fittofit_admin/models/akcije.dart';

import 'base_provider.dart';

class AkcijeProvider extends BaseProvider<Akcije> {
  AkcijeProvider() : super("Akcije");

  @override
  Akcije fromJson(data) {
    return Akcije.fromJson(data);
  }
}
