import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdesign_flutter_example/main.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';
import 'package:tdesign_flutter_example/util/web_theme_listener.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'setting:theme_mode': ThemeMode.dark.index,
    });
  });

  test('loads saved mode when no newer setting exists', () async {
    final provider = ThemeModeProvider();
    addTearDown(provider.dispose);
    await provider.initThemeMode();
    expect(provider.themeMode, ThemeMode.dark);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark, ThemeMode.system]) {
    test('pending preferences cannot override a newer $mode setting', () async {
      final provider = ThemeModeProvider();
      addTearDown(provider.dispose);
      var notifications = 0;
      provider.addListener(() => notifications++);
      final initialization = provider.initThemeMode();
      provider.themeMode = mode;
      final notificationsAfterUpdate = notifications;
      await initialization;
      expect(provider.themeMode, mode);
      expect(notifications, notificationsAfterUpdate);
    });
  }

  test('pending initialization does not notify after disposal', () async {
    final provider = ThemeModeProvider();
    var notifications = 0;
    provider.addListener(() => notifications++);
    final initialization = provider.initThemeMode();
    provider.dispose();
    await initialization;
    expect(notifications, 0);
  });

  test('native listener is inert and cleanup can be repeated', () {
    var updates = 0;
    final stop = listenToWebThemeUpdates(onUpdate: (_, __) => updates++);
    stop();
    stop();
    expect(updates, 0);
  });

  testWidgets('remount owns a fresh provider and preserves saved mode', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final first = Provider.of<ThemeModeProvider>(
      tester.element(find.byType(MaterialApp)),
      listen: false,
    );
    first.themeMode = ThemeMode.light;
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    final second = Provider.of<ThemeModeProvider>(
      tester.element(find.byType(MaterialApp)),
      listen: false,
    );
    expect(second, isNot(same(first)));
    expect(second.themeMode, ThemeMode.light);
  });
}
