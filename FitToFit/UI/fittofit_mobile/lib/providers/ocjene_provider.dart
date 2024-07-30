import 'package:fittofit_mobile/models/ocjene.dart';
import 'package:fittofit_mobile/providers/base_provider.dart';

class OcjeneProvider extends BaseProvider<Ocjene> {
  OcjeneProvider() : super("Ocjene");

  @override
  Ocjene fromJson(data) {
    return Ocjene.fromJson(data);
  }
}
