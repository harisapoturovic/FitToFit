import 'package:fittofit_admin/models/korisnici.dart';

import 'base_provider.dart';

class KorisniciProvider extends BaseProvider<Korisnici>
{
  KorisniciProvider() : super("Korisnici");
  
  @override
  Korisnici fromJson(data) {
  return Korisnici.fromJson(data);
  }
}