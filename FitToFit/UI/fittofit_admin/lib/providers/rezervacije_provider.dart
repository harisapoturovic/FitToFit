import 'package:fittofit_admin/models/rezervacije.dart';
import 'package:fittofit_admin/providers/base_provider.dart';

class RezervacijeProvider extends BaseProvider<Rezervacije>
{
  RezervacijeProvider() : super("Rezervacije");
  
  @override
  Rezervacije fromJson(data) {
  return Rezervacije.fromJson(data);
  }
}