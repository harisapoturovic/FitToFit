import 'package:fittofit_admin/models/vjezbe.dart';

import 'base_provider.dart';

class VjezbeProvider extends BaseProvider<Vjezbe> {
  VjezbeProvider() : super("Vjezbe");

  @override
  Vjezbe fromJson(data) {
    return Vjezbe.fromJson(data);
  }
}
