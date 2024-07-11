import 'package:fittofit_mobile/models/korisniciNovosti.dart';

import 'base_provider.dart';

class KorisniciNovostiProvider extends BaseProvider<KorisniciNovosti> {
  KorisniciNovostiProvider() : super("KorisniciNovosti");

  @override
  KorisniciNovosti fromJson(data) {
    return KorisniciNovosti.fromJson(data);
  }
}
