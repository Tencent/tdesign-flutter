import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'popup_test_resource.dart';

/// 测试用典型非对称安全区内边距（左 11 / 上 22 / 右 33 / 下 44）。
const EdgeInsets kPopupTestMediaPadding = EdgeInsets.fromLTRB(11, 22, 33, 44);

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
  EdgeInsets mediaPadding = EdgeInsets.zero,
}) async {
  await tester.pumpWidget(
    wrapPopupTestWithMediaPadding(
      Builder(
        builder: (context) => ElevatedButton(
          onPressed: onPressed,
          child: const Text('open'),
        ),
      ),
      mediaPadding: mediaPadding,
      resource: resource ?? PopupTestResourceDelegate.zh(),
    ),
  );
  await tester.tap(find.text('open'));
}

/// 注入 [MediaQuery.padding]，用于安全区相关测试。
Widget wrapPopupTestWithMediaPadding(
  Widget child, {
  EdgeInsets mediaPadding = EdgeInsets.zero,
  PopupTestResourceDelegate? resource,
}) {
  final resolved = resource ?? PopupTestResourceDelegate.zh();
  bindPopupTestResource(resolved);
  return MaterialApp(
    locale: resolved.locale,
    builder: (context, appChild) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(padding: mediaPadding),
        child: appChild ?? const SizedBox.shrink(),
      );
    },
    home: TTheme(
      data: TThemeData.defaultData(),
      child: Scaffold(body: child),
    ),
  );
}

/// 取浮层面板的 [Positioned]（排除 [Positioned.fill] 的全屏占位）。
Positioned findPopupPanelPositioned(WidgetTester tester) {
  return tester.widgetList<Positioned>(find.byType(Positioned)).firstWhere(
        (positioned) =>
            positioned.bottom != null ||
            positioned.top != null ||
            (positioned.width != null &&
                (positioned.left != null || positioned.right != null)),
      );
}
