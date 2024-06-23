import 'package:fittofit_mobile/models/vjezbeTreninzi.dart';

import 'base_provider.dart';

class VjezbeTreninziProvider extends BaseProvider<VjezbeTreninzi> {
  VjezbeTreninziProvider() : super("VjezbeTreninzi");

  @override
  VjezbeTreninzi fromJson(data) {
    return VjezbeTreninzi.fromJson(data);
  }
}
