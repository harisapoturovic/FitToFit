import 'package:fittofit_admin/models/treneri.dart';

import 'base_provider.dart';

class TreneriProvider extends BaseProvider<Treneri>
{
  TreneriProvider() : super("Treneri");
  
  @override
  Treneri fromJson(data) {
  return Treneri.fromJson(data);
  }
}