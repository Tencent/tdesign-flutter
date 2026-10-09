import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/api_widget.dart';
import 'package:tdesign_flutter_example/base/example_route.dart';
import 'package:tdesign_flutter_example/config.dart';

String normalize(String name) =>
    name.replaceAll(RegExp('[-_]'), '').toLowerCase();

Future<void> loadPage(
  WidgetTester tester,
  Widget page, {
  String? apiSlug,
}) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(page);
    // Complete real asset I/O and isolate decoding outside the fake test clock.
    await AssetManifest.loadFromAssetBundle(rootBundle);
    if (apiSlug != null) {
      await rootBundle.loadString('assets/api/${apiSlug}_api.md');
    }
  });
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  final manifest =
      jsonDecode(File('../tool/components.json').readAsStringSync())
          as Map<String, dynamic>;
  final components = manifest['components'] as List;
  final pages = exampleMap.values.expand((pages) => pages).toList();
  TExampleRoute.init();

  for (final component in components) {
    final slug = component['slug'] as String;
    final model = pages.singleWhere(
      (page) => normalize(page.name) == normalize(slug),
    );
    for (final routeName in {model.name, slug}) {
      testWidgets(
        '$slug API opens through $routeName and renders every declaration',
        (tester) async {
          await loadPage(
            tester,
            MaterialApp(
              theme: TThemeBuilder.light(TThemeData.defaultData()),
              initialRoute: 'api?$routeName',
              onGenerateRoute: TExampleRoute.onGenerateRoute,
            ),
            apiSlug: slug,
          );
          expect(find.byType(ApiPage), findsOneWidget);
          expect(find.text('${model.text} API'), findsOneWidget);
          for (final name in [
            ...component['api']['names'],
            ...?component['api']['functions'],
          ]) {
            expect(
              find.text(name as String, findRichText: true),
              findsWidgets,
              reason: '$slug / $routeName: $name',
            );
          }
          expect(
            find.textContaining('暂无对应api', findRichText: true),
            findsNothing,
          );
          expect(tester.takeException(), isNull, reason: '$slug / $routeName');
        },
      );
    }
  }

  testWidgets(
    'switching to a missing document does not retain the previous API',
    (tester) async {
      Widget page(String name) => MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: Scaffold(
          body: SingleChildScrollView(child: ApiWidget(apiName: name)),
        ),
      );
      await loadPage(tester, page('button'), apiSlug: 'button');
      expect(find.text('TButton', findRichText: true), findsWidgets);
      await loadPage(tester, page('missing-component'));
      expect(find.textContaining('暂无对应api', findRichText: true), findsWidgets);
      expect(find.text('TButton', findRichText: true), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
