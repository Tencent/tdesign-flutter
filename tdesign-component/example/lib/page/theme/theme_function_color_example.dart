import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'theme')
class ThemeFunctionColorExample extends StatelessWidget {
  const ThemeFunctionColorExample({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.tTheme;
    final defaults = TThemeData.defaultData();
    final keys = {
      ...theme.colorMap.keys,
      ...theme.refMap.keys,
      ...defaults.colorMap.keys,
      ...defaults.refMap.keys,
    };
    final colors = <String, Color>{};
    for (final key in keys) {
      final color = theme.colorMap[key];
      if (color != null) {
        colors[key] = color;
      }
    }
    final entries = [
      for (final prefix in ['brand', 'error', 'warning', 'success'])
        ...colors.entries.where((entry) => entry.key.startsWith(prefix)),
    ];
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Container(color: entry.value, child: TText(entry.key));
      },
    );
  }
}
