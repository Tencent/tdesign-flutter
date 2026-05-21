import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'popup_test_resource.dart';

Widget wrapPopupTest(
  Widget child, {
  PopupTestResourceDelegate? resource,
}) {
  final resolved = resource ?? PopupTestResourceDelegate.zh();
  bindPopupTestResource(resolved);
  return MaterialApp(
    locale: resolved.locale,
    home: TTheme(
      data: TThemeData.defaultData(),
      child: Scaffold(body: child),
    ),
  );
}

Future<void> openPopup(
  WidgetTester tester, {
  required VoidCallback onPressed,
  PopupTestResourceDelegate? resource,
}) async {
  await tester.pumpWidget(
    wrapPopupTest(
      Builder(
        builder: (context) => ElevatedButton(
          onPressed: onPressed,
          child: const Text('open'),
        ),
      ),
      resource: resource ?? PopupTestResourceDelegate.zh(),
    ),
  );
  await tester.tap(find.text('open'));
}
