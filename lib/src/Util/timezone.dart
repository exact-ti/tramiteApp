
import 'package:timezone/timezone.dart' as tz;

final lima = tz.getLocation('America/Lima');

tz.TZDateTime parse(String fecha) {
  return tz.TZDateTime.from(DateTime.parse(fecha), lima);
}