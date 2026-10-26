import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'syntax_highlighter.dart';

/// 示例应用代码入口；按生成清单顺序展示，避免依赖闭包名称或隐藏遮罩。
class ExampleCodeViewer {
  static Future<void> showExamples(BuildContext context, String group) async {
    final bundle = DefaultAssetBundle.of(context);
    final entries = <({String title, String path})>[];
    try {
      final manifest =
          jsonDecode(await bundle.loadString('assets/code/manifest.json'))
              as Map<String, dynamic>;
      final groups = manifest['groups'] as Map<String, dynamic>;
      for (final module in (groups[group] as List<dynamic>? ?? [])) {
        for (final item in module['items'] as List<dynamic>) {
          final description = item['description'] as String;
          entries.add((
            title: description.isEmpty
                ? module['title'] as String
                : description,
            path: 'assets/code/${item['assetKey']}.txt',
          ));
        }
      }
    } catch (error) {
      debugPrint('Failed to load example code manifest: $error');
    }
    if (!context.mounted) {
      return;
    }
    if (entries.isEmpty) {
      await showCodeString(context, '');
      return;
    }
    if (entries.length == 1) {
      await showAsset(context, entries.single.path);
      return;
    }
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.7,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TText('选择示例代码', font: context.tTheme.fontTitleMedium),
              ),
              Expanded(
                child: ListView(
                  children: [
                    TCellGroup(
                      cells: [
                        for (final entry in entries)
                          TCell(
                            title: Text(entry.title),
                            onTap: () => Navigator.of(sheetContext).pop(entry.path),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (selected != null && context.mounted) {
      await showAsset(context, selected);
    }
  }

  static Future<void> showAsset(BuildContext context, String path) async {
    var code = '';
    try {
      code = await DefaultAssetBundle.of(context).loadString(path);
    } catch (error) {
      debugPrint('Failed to load example code asset $path: $error');
    }
    if (context.mounted) {
      await showCodeString(context, code);
    }
  }

  static Future<void> showCodeString(BuildContext context, String code) {
    final availableHeight = MediaQuery.sizeOf(context).height * 0.85;
    final height = math.min(
      math.max(300.0, code.split('\n').length * 17.0 + 32),
      availableHeight,
    );
    final style = Theme.of(context).brightness == Brightness.dark
        ? SyntaxHighlighterStyle.darkThemeStyle()
        : SyntaxHighlighterStyle.lightThemeStyle();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.tTheme.bgColorSecondaryContainer,
      builder: (_) => SafeArea(
        child: SizedBox(
          height: height,
          child: code.trim().isEmpty
              ? const Center(child: TText('暂无演示代码'))
              : Markdown(
                  padding: const EdgeInsets.all(16),
                  selectable: true,
                  syntaxHighlighter: DartSyntaxHighlighter(style),
                  data: '```dart\n$code\n```',
                ),
        ),
      ),
    );
  }
}
