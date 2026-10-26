import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'theme')
class ThemeOtherColorExample extends StatefulWidget {
  const ThemeOtherColorExample({super.key});

  @override
  State<ThemeOtherColorExample> createState() => _ThemeOtherColorExampleState();
}

class _ThemeOtherColorExampleState extends State<ThemeOtherColorExample> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final colors = context.tTheme.colorMap;
    final keys = {
      ...TThemeData.defaultData().colorMap.keys,
      ...colors.keys,
    }.where((key) => key.startsWith('grayColor'));
    grayMap.clear();
    for (final key in keys) {
      final color = colors[key];
      if (color != null) {
        grayMap[key] = color;
      }
    }
  }

  Widget _buildOtherColor(BuildContext context) {
    final entries = grayMap.entries.toList();
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length + 1,
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            color: context.tTheme.bgColorContainer,
            child: const TText('bgColorContainer'),
          );
        } else {
          final entry = entries[index - 1];
          return Container(
            color: entry.value,
            child: TText(
              entry.key,
              style: TextStyle(
                color: entry.value.computeLuminance() < 0.5
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          );
        }
      },
    );
  }

  var grayMap = <String, Color>{};

  @override
  Widget build(BuildContext context) {
    return _buildOtherColor(context);
  }
}
