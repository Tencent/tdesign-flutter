import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'base/example_widget.dart';
import 'documentation_examples.dart';

enum ThemeScene { json, local, mode }

ThemeMode _previewMode(BuildContext context, ThemeMode? selection) =>
    selection ??
    (Theme.of(context).brightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light);

/// 自定义主题指南的独立运行入口，复用生成文档所用的配置函数。
class ThemeDemo extends StatefulWidget {
  const ThemeDemo({required this.scene, super.key});

  final ThemeScene scene;

  @override
  State<ThemeDemo> createState() => _ThemeDemoState();
}

class _ThemeDemoState extends State<ThemeDemo> {
  late final TThemeData _businessTokens;
  ThemeMode? _selection;
  bool _businessTheme = true;

  @override
  void initState() {
    super.initState();
    _businessTokens = createTheme();
  }

  @override
  Widget build(BuildContext context) {
    final mode = _previewMode(context, _selection);
    return buildThemeApp(
      mode,
      Builder(
        builder: (context) => Scaffold(
          backgroundColor: context.tTheme.bgColorPage,
          body: SafeArea(
            child: SingleChildScrollView(
              child: ThemeContent(
                scene: widget.scene,
                mode: mode,
                businessTheme: _businessTheme,
                onThemeChanged: (value) =>
                    setState(() => _businessTheme = value),
                onModeChanged: (mode) => setState(() => _selection = mode),
              ),
            ),
          ),
        ),
      ),
      tokens: _businessTheme ? _businessTokens : TThemeData.defaultData(),
    );
  }
}

/// 场景内容继承所在应用的主题，不再创建独立的 MaterialApp。
class ThemeContent extends StatelessWidget {
  const ThemeContent({
    required this.scene,
    required this.mode,
    required this.onModeChanged,
    required this.businessTheme,
    required this.onThemeChanged,
    super.key,
  });

  final ThemeScene scene;
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onModeChanged;
  final bool businessTheme;
  final ValueChanged<bool> onThemeChanged;

  String _modeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.light => '浅色',
    ThemeMode.dark => '深色',
    ThemeMode.system => '跟随系统',
  };

  @override
  Widget build(BuildContext context) {
    final tokens = context.tTheme;
    final brand = tokens.brandColor
        .toARGB32()
        .toRadixString(16)
        .substring(2)
        .toUpperCase();
    return ColoredBox(
      key: ValueKey('theme-scene-${scene.name}'),
      color: tokens.bgColorContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (scene == ThemeScene.local) ...[
              const TText('默认标签'),
              const SizedBox(height: 12),
              const TTag('默认圆角', colorPreset: TTagColorPreset.primary),
              const SizedBox(height: 24),
              const TText('局部覆盖：圆角 6'),
              const SizedBox(height: 12),
              wrapLocalTheme(
                context,
                const TTag('局部圆角', colorPreset: TTagColorPreset.primary),
              ),
              const SizedBox(height: 16),
              const TText('局部设置只影响“局部圆角”标签所在的 Theme 子树。'),
            ] else ...[
              if (scene == ThemeScene.json) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final value in [false, true])
                      TButton(
                        size: TButtonSize.small,
                        colorPreset: businessTheme == value
                            ? TButtonColorPreset.primary
                            : TButtonColorPreset.defaultTheme,
                        onPressed: () => onThemeChanged(value),
                        child: Text(value ? '业务主题' : '默认主题'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              if (scene == ThemeScene.mode) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final option in ThemeMode.values)
                      TButton(
                        size: TButtonSize.small,
                        colorPreset: mode == option
                            ? TButtonColorPreset.primary
                            : TButtonColorPreset.defaultTheme,
                        onPressed: () => onModeChanged(option),
                        child: Text(_modeLabel(option)),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                TText('当前模式：${_modeLabel(mode)}'),
                const SizedBox(height: 12),
              ],
              TText(
                '当前外观：${Theme.of(context).brightness == Brightness.dark ? '深色' : '浅色'}',
              ),
              const SizedBox(height: 12),
              TText('主题配置：${tokens.name}'),
              const SizedBox(height: 12),
              TText('brandColor：#$brand'),
              const SizedBox(height: 16),
              const _BusinessThemeCard(),
              if (scene == ThemeScene.json) ...[
                const SizedBox(height: 24),
                const _ThemeTokenComparison(),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// 整个指南只有一个应用主题，模式切换同时更新页面壳及所有示例。
class ThemeGuidePage extends StatefulWidget {
  const ThemeGuidePage({this.themeAdapter, super.key});

  /// 可选的宿主主题适配；截图测试用它固定原生文字的字体与回退栈。
  /// 不修改指南的 Token 配置、明暗关联或交互状态。
  final ThemeData Function(ThemeData)? themeAdapter;

  @override
  State<ThemeGuidePage> createState() => _ThemeGuidePageState();
}

class _ThemeGuidePageState extends State<ThemeGuidePage> {
  late final TThemeData _businessTokens;
  ThemeMode? _selection;
  bool _businessTheme = true;

  @override
  void initState() {
    super.initState();
    _businessTokens = createTheme();
  }

  @override
  Widget build(BuildContext context) {
    final mode = _previewMode(context, _selection);
    return buildThemeApp(
      mode,
      Builder(
        builder: (context) {
          final page = ExamplePage(
            title: '自定义主题',
            desc: '配置全局主题、组件局部样式和明暗模式。',
            exampleCodeGroup: 'theme',
            showTestModule: false,
            backgroundColor: context.tTheme.bgColorPage,
            children: [
              for (final scene in ThemeScene.values)
                ExampleModule(
                  title: switch (scene) {
                    ThemeScene.json => 'JSON 配置',
                    ThemeScene.local => '组件局部样式',
                    ThemeScene.mode => '明暗模式',
                  },
                  children: [
                    ExampleItem(
                      ignoreCode: true,
                      center: false,
                      builder: (_) => ThemeContent(
                        scene: scene,
                        mode: mode,
                        businessTheme: _businessTheme,
                        onThemeChanged: (value) =>
                            setState(() => _businessTheme = value),
                        onModeChanged: (mode) =>
                            setState(() => _selection = mode),
                      ),
                    ),
                  ],
                ),
            ],
          );
          final adapter = widget.themeAdapter;
          return adapter == null
              ? page
              : Theme(data: adapter(Theme.of(context)), child: page);
        },
      ),
      tokens: _businessTheme ? _businessTokens : TThemeData.defaultData(),
    );
  }
}

String _themeColorHex(Color color) {
  final argb = color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
  return '#${(color.toARGB32() >> 24) == 255 ? argb.substring(2) : argb}';
}

class _ThemeTokenComparison extends StatelessWidget {
  const _ThemeTokenComparison();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tTheme;
    final light = tokens.light;
    final dark = light.dark ?? light;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rows = <(String, Color Function(TThemeData), String)>[
      ('brandColor', (theme) => theme.brandColor, '主题配置'),
      ('bgColorPage', (theme) => theme.bgColorPage, '主题配置'),
      ('bgColorContainer', (theme) => theme.bgColorContainer, '主题配置'),
      ('textColorPrimary', (theme) => theme.textColorPrimary, '主题配置'),
    ];
    Widget label(String text, {bool active = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(
        text,
        style: TextStyle(
          color: tokens.textColorPrimary,
          fontSize: 12,
          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
    Widget value(Color color) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: tokens.componentBorder),
            ),
          ),
          Text(
            _themeColorHex(color),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: tokens.textColorPrimary,
            ),
          ),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const TText('当前主题的浅色与深色配置'),
        const SizedBox(height: 8),
        Table(
          key: const ValueKey('theme-token-comparison'),
          columnWidths: const {
            0: FlexColumnWidth(1.4),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder(
            horizontalInside: BorderSide(color: tokens.componentStroke),
          ),
          children: [
            TableRow(
              children: [
                label('配置项 / 来源'),
                label(
                  '浅色${!isDark ? '（当前）' : ''}\n${light.name}',
                  active: !isDark,
                ),
                label(
                  '深色${isDark ? '（当前）' : ''}\n${dark.name}',
                  active: isDark,
                ),
              ],
            ),
            for (final row in rows)
              TableRow(
                children: [
                  label('${row.$1}\n${row.$3}'),
                  value(row.$2(light)),
                  value(row.$2(dark)),
                ],
              ),
          ],
        ),
        const SizedBox(height: 8),
        const TText('不透明色为 #RRGGBB；含透明度的颜色为 #AARRGGBB，前两位表示透明度。'),
      ],
    );
  }
}

/// 页面布局留在预览源码中，组件通过当前上下文读取同一套 Token。
class _BusinessThemeCard extends StatefulWidget {
  const _BusinessThemeCard();

  @override
  State<_BusinessThemeCard> createState() => _BusinessThemeCardState();
}

class _BusinessThemeCardState extends State<_BusinessThemeCard> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tTheme;
    return Container(
      key: const ValueKey('business-theme-card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.bgColorPage,
        border: Border.all(color: tokens.componentBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TText('周末出行计划'),
          const SizedBox(height: 8),
          Text(
            '背景、文字、边框和组件跟随同一套主题。',
            style: TextStyle(color: tokens.textColorSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: TTag('品牌色标签', colorPreset: TTagColorPreset.primary),
          ),
          const SizedBox(height: 12),
          const TInput(initialValue: '周末出行', hintText: '输入计划名称'),
          const SizedBox(height: 16),
          TButton(
            colorPreset: TButtonColorPreset.primary,
            onPressed: () => setState(() => _saved = !_saved),
            child: Text(_saved ? '已保存' : '品牌色按钮'),
          ),
        ],
      ),
    );
  }
}
