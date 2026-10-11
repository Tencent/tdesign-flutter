import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'theme')
class DarkModeExample extends StatefulWidget {
  const DarkModeExample({super.key});

  @override
  State<DarkModeExample> createState() => _DarkModeExampleState();
}

class _DarkModeExampleState extends State<DarkModeExample> {
  final TThemeData _tokens = TThemeData.defaultData();
  ThemeMode _mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: TThemeBuilder.light(_tokens),
    darkTheme: TThemeBuilder.dark(_tokens),
    themeMode: _mode,
    home: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('深色模式')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final mode in ThemeMode.values)
                  TButton(
                    onPressed: () => setState(() => _mode = mode),
                    variant: _mode == mode
                        ? TButtonVariant.fill
                        : TButtonVariant.outline,
                    colorPreset: TButtonColorPreset.primary,
                    child: Text(switch (mode) {
                      ThemeMode.system => '跟随系统',
                      ThemeMode.light => '浅色',
                      ThemeMode.dark => '深色',
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            TText(
              '当前显示：${Theme.of(context).brightness == Brightness.dark ? '深色' : '浅色'}',
            ),
            const SizedBox(height: 16),
            TButton(
              onPressed: () {},
              colorPreset: TButtonColorPreset.primary,
              child: const Text('主要按钮'),
            ),
            const SizedBox(height: 16),
            const TTag('主题标签', colorPreset: TTagColorPreset.primary),
            const SizedBox(height: 16),
            const TText('页面、按钮与文字一起跟随所选模式。'),
          ],
        ),
      ),
    ),
  );
}
