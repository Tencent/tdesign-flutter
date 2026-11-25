import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_route.dart';
import 'package:tdesign_flutter_example/documentation_examples.dart' as docs;
import 'package:tdesign_flutter_example/documentation_quick_start.dart'
    as quick;

void main() {
  testWidgets(
    'complete quick start has an enabled button and visible state feedback',
    (tester) async {
      quick.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('点击次数：0'));
      await tester.pump();
      expect(find.text('点击次数：1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('quick start route inherits the host theme and preserves count', (
    tester,
  ) async {
    TExampleRoute.init();
    for (final dark in [false, true]) {
      final tokens = docs.documentationThemeTokens();
      await tester.pumpWidget(
        MaterialApp(
          theme: dark
              ? TThemeBuilder.dark(tokens)
              : TThemeBuilder.light(tokens),
          initialRoute: 'getting-started',
          onGenerateRoute: TExampleRoute.onGenerateRoute,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(quick.CounterPage), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
      final button = tester.element(find.byType(TButton));
      expect(
        Theme.of(button).brightness,
        dark ? Brightness.dark : Brightness.light,
      );
      expect(
        button.tTheme.brandColor,
        (dark ? tokens.dark! : tokens).brandColor,
      );
      if (!dark) {
        await tester.tap(find.text('点击次数：0'));
        await tester.pumpAndSettle();
      }
      expect(find.text('点击次数：1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
    'asset theme reads the registered file and preserves light and dark names',
    (tester) async {
      final requests = <String>[];
      rootBundle.evict('assets/custom_theme.json');
      tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (message) async {
          final asset = utf8.decode(message!.buffer.asUint8List());
          if (asset != 'assets/custom_theme.json') {
            return null;
          }
          requests.add(asset);
          return ByteData.sublistView(
            Uint8List.fromList(utf8.encode(docs.themeJson)),
          );
        },
      );
      addTearDown(() {
        tester.binding.defaultBinaryMessenger.setMockMessageHandler(
          'flutter/assets',
          null,
        );
        rootBundle.evict('assets/custom_theme.json');
      });
      final tokens = await docs.loadTheme();
      expect(requests, ['assets/custom_theme.json']);
      expect(tokens.brandColor, const Color(0xFF16875D));
      expect(tokens.dark!.brandColor, const Color(0xFF56C08D));
      await docs.runThemeApp();
      await tester.pumpAndSettle();
      final button = tester.element(find.widgetWithText(TButton, '主题按钮'));
      expect(button.tTheme.brandColor, const Color(0xFF16875D));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'invalid asset theme does not silently substitute default tokens',
    (tester) async {
      rootBundle.evict('assets/custom_theme.json');
      tester.binding.defaultBinaryMessenger.setMockMessageHandler(
        'flutter/assets',
        (message) async =>
            ByteData.sublistView(Uint8List.fromList(utf8.encode('{}'))),
      );
      addTearDown(() {
        tester.binding.defaultBinaryMessenger.setMockMessageHandler(
          'flutter/assets',
          null,
        );
        rootBundle.evict('assets/custom_theme.json');
      });
      await expectLater(docs.loadTheme(), throwsFormatException);
    },
  );

  testWidgets(
    'complete localization app switches resources without registering again',
    (tester) async {
      docs.configureDocumentationResources();
      addTearDown(
        () => setTResourceBuilder((context) => null, needAlwaysBuild: true),
      );
      await tester.pumpWidget(const docs.LocaleApp());
      await tester.pumpAndSettle();
      expect(find.text('确认'), findsOneWidget);
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm'), findsOneWidget);
      final english = TResourceManager.instance.delegate(
        tester.element(find.text('Confirm')),
      );
      expect(
        [
          english.uploading,
          english.uploadSelect,
          english.uploadPending,
          english.uploadFailed,
          english.uploadRetry,
          english.uploadSuccess,
        ],
        [
          'Uploading',
          'Select files',
          'Pending upload',
          'Upload failed',
          'Retry upload',
          'Upload successful',
        ],
      );
      expect(find.text('确认'), findsNothing);
      await tester.tap(find.text('中文'));
      await tester.pumpAndSettle();
      expect(find.text('确认'), findsOneWidget);
      final chinese = TResourceManager.instance.delegate(
        tester.element(find.text('确认')),
      );
      expect(
        [
          chinese.uploading,
          chinese.uploadSelect,
          chinese.uploadPending,
          chinese.uploadFailed,
          chinese.uploadRetry,
          chinese.uploadSuccess,
        ],
        ['上传中', '选择文件', '待上传', '上传失败', '重新上传', '上传成功'],
      );
      expect(tester.takeException(), isNull);
    },
  );
}
