import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      final output = Directory('build/indexes-device-evidence');
      await output.create(recursive: true);
      await File('${output.path}/$name.png').writeAsBytes(bytes);
      // Capture only: visual alignment is reviewed separately, not a Golden pass.
      return true;
    },
  );
}
