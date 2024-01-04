import 'package:parlera/flavors.dart';

import 'package:parlera/main.dart' as runner;

void main() async {
  F.appFlavor = Flavor.free;
  runner.main();
}
