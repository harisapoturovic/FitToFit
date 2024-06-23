import 'package:fittofit_mobile/models/novosti.dart';
import 'package:fittofit_mobile/providers/base_provider.dart';

class NovostiProvider extends BaseProvider<Novosti> {
  NovostiProvider() : super("Novosti");

  @override
  Novosti fromJson(data) {
    return Novosti.fromJson(data);
  }
}
