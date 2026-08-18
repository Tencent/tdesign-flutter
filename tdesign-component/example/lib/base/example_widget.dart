import 'dart:math';
import 'dart:ui' show FlutterView;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../provider/theme_mode_provider.dart';
import 'example_base.dart';
import 'example_route.dart';
import 'notification_center.dart';
import 'syntax_highlighter.dart';

var navBarkey = GlobalKey();

/// 示例页面控件，建议每个页面返回一个ExampleWidget即可，不用独自封装
class ExamplePage extends StatefulWidget {
  const ExamplePage({
    Key? key,
    this.navBarKey,
    required this.title,
    this.desc = '',
    this.children = const [],
    this.padding,
    this.backgroundColor,
    required this.exampleCodeGroup,
    this.test = const [],
    this.showSingleChild = false,
    this.singleChild,
    this.scrollController,
    this.floatingActionButton,
    this.showTestModule = true,
  }) : assert(
         children.length > 0 || (showSingleChild && singleChild != null),
         'children or singleChild must have at least one',
       ),
       super(key: key);

  /// 标题
  final String title;

  /// 如果封装的children无法满足需求，可以自定义子控件
  final bool showSingleChild;

  /// 自定义的自控件，只有showSingleChild为true才会展示。CodeWrapper的builder构建真正的试图
  final CodeWrapper? singleChild;

  /// 示例组件模块列表
  final List<ExampleModule> children;

  /// 描述，showSingleChild为false会展示
  final String desc;

  /// 填充
  final EdgeInsetsGeometry? padding;

  /// 背景颜色
  final Color? backgroundColor;

  /// 示例代码路径
  final String exampleCodeGroup;

  /// 测试组件列表
  final List<ExampleItem> test;

  /// 滚动控制组件
  final ScrollController? scrollController;

  /// 悬浮按钮
  final Widget? floatingActionButton;

  /// 是否展示仅用于内部验证的单元测试模块。
  final bool showTestModule;

  /// 悬浮按钮
  final GlobalKey? navBarKey;

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> with WidgetsBindingObserver {
  late List<ExampleModule> list;
  bool apiVisible = false;
  ExamplePageModel? model;
  bool showAction = false;
  late ScrollController _scrollController;
  late bool _ownsScrollController;
  FlutterView? _view;
  double _keyboardInset = 0;
  double? _scrollOffsetBeforeKeyboard;
  bool _userScrolledWithKeyboard = false;
  double? _keyboardDismissStartInset;
  double? _scrollOffsetAtKeyboardDismissStart;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setScrollController(widget.scrollController);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var modelTheme = context
          .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
      model = modelTheme?.model;
      model?.codePath = widget.exampleCodeGroup;
      model?.apiVisible = apiVisible;
      setState(() {
        showAction = model?.showAction ?? false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextView = View.of(context);
    if (!identical(_view, nextView)) {
      _view = nextView;
      _keyboardInset = _readKeyboardInset();
    }
  }

  @override
  void didUpdateWidget(covariant ExamplePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      if (_ownsScrollController) {
        _scrollController.dispose();
      }
      _setScrollController(widget.scrollController);
      _scrollOffsetBeforeKeyboard = null;
      _userScrolledWithKeyboard = false;
      _cancelKeyboardRestore();
    }
  }

  @override
  void didChangeMetrics() {
    final nextInset = _readKeyboardInset();
    final wasVisible = _keyboardInset > 0;
    final isVisible = nextInset > 0;
    if (!wasVisible && isVisible && _scrollController.hasClients) {
      _cancelKeyboardRestore();
      _scrollOffsetBeforeKeyboard = _scrollController.offset;
      _userScrolledWithKeyboard = false;
    } else if (wasVisible &&
        isVisible &&
        nextInset < _keyboardInset &&
        !_userScrolledWithKeyboard) {
      final restoreOffset = _scrollOffsetBeforeKeyboard;
      if (restoreOffset != null && _scrollController.hasClients) {
        _keyboardDismissStartInset ??= _keyboardInset;
        _scrollOffsetAtKeyboardDismissStart ??= _scrollController.offset;
        final startInset = _keyboardDismissStartInset!;
        final startOffset = _scrollOffsetAtKeyboardDismissStart!;
        final remaining = (nextInset / startInset).clamp(0.0, 1.0);
        _restoreKeyboardOffset(
          restoreOffset + (startOffset - restoreOffset) * remaining,
        );
      }
    } else if (wasVisible && isVisible && nextInset > _keyboardInset) {
      _cancelKeyboardRestore();
    } else if (wasVisible && !isVisible) {
      final restoreOffset = _scrollOffsetBeforeKeyboard;
      _scrollOffsetBeforeKeyboard = null;
      if (!_userScrolledWithKeyboard && restoreOffset != null) {
        _restoreKeyboardOffset(restoreOffset);
      }
      _keyboardDismissStartInset = null;
      _scrollOffsetAtKeyboardDismissStart = null;
    }
    _keyboardInset = nextInset;
  }

  void _restoreKeyboardOffset(double target) {
    if (_userScrolledWithKeyboard || !_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    final clampedTarget = target.clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((position.pixels - clampedTarget).abs() >= 0.5) {
      _scrollController.jumpTo(clampedTarget);
    }
  }

  void _cancelKeyboardRestore() {
    _keyboardDismissStartInset = null;
    _scrollOffsetAtKeyboardDismissStart = null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_ownsScrollController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _setScrollController(ScrollController? controller) {
    _ownsScrollController = controller == null;
    _scrollController = controller ?? ScrollController();
  }

  double _readKeyboardInset() {
    final view = _view;
    if (view == null) {
      return 0;
    }
    return view.viewInsets.bottom / view.devicePixelRatio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      floatingActionButton: widget.floatingActionButton,
      body: ScrollbarTheme(
        data: ScrollbarThemeData(
          trackVisibility: WidgetStateProperty.all(true),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(bottom: false, child: _buildNavBar()),
            Expanded(
              child: SafeArea(
                top: false,
                child: widget.showSingleChild && widget.singleChild != null
                    ? _singleChild()
                    : _buildExampleList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleList() {
    final modules = [
      ...widget.children,
      if (widget.showTestModule)
        ExampleModule(
          title: '单元测试',
          children: [_buildTestExampleItem(), ...widget.test],
        ),
    ];
    return NotificationListener<ScrollStartNotification>(
      onNotification: (notification) {
        if (_keyboardInset > 0 && notification.dragDetails != null) {
          _userScrolledWithKeyboard = true;
          _cancelKeyboardRestore();
        }
        return false;
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(child: _buildHeader()),
          for (
            var moduleIndex = 0;
            moduleIndex < modules.length;
            moduleIndex++
          ) ...[
            SliverToBoxAdapter(
              child: _buildModuleTitle(moduleIndex + 1, modules[moduleIndex]),
            ),
            SliverList.builder(
              itemCount: modules[moduleIndex].children.length,
              itemBuilder: (_, itemIndex) =>
                  _buildExampleItem(modules[moduleIndex], itemIndex),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _singleChild() => widget.singleChild!;

  ExampleItem _buildTestExampleItem() => ExampleItem(
    desc: '''未在示例稿中体现，但有必要验证的组件样式，请添加到'test'参数中。以下情景必须有测试：
  1.参数为数字。需测试数字为负数、0、较大数值的场景。
  2.参数为枚举，需测试所有枚举组合（示例已有的可不写）''',
    builder: (_) => const TDivider(),
  );

  Widget _buildNavBar() {
    var leftBarItems = <TNavBarItem>[];
    var rightBarItems = <TNavBarItem>[];

    // web端示例页不展示标题栏
    if (PlatformUtil.isWeb && !Navigator.canPop(context)) {
      return Container();
    }
    if (showAction) {
      // Web 端和移动端都显示 API 按钮
      rightBarItems.add(
        TNavBarItem(
          icon: TIcons.info_circle,
          onTap: () {
            Navigator.pushNamed(context, TExampleRoute.getApiPath(model));
          },
        ),
      );
      if (!PlatformUtil.isWeb) {
        rightBarItems.add(
          TNavBarItem(
            icon: TIcons.code,
            onTap: () {
              setState(() {
                apiVisible = !apiVisible;
                if (model != null) {
                  model!.apiVisible = apiVisible;
                }
              });
              TNotification.postNotification('onApiVisibleChange', {
                'apiVisible': apiVisible,
              });
            },
          ),
        );
      }
    }
    if (!PlatformUtil.isWeb) {
      var themeModeProvider = Provider.of<ThemeModeProvider>(context);
      // 获取系统主题
      // Brightness systemBrightness = MediaQuery.platformBrightnessOf(context);

      leftBarItems.add(
        TNavBarItem(
          icon: themeModeProvider.themeMode == ThemeMode.light
              ? TIcons.mode_light
              : TIcons.mode_dark,
          onTap: () {
            themeModeProvider.themeMode =
                themeModeProvider.themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;
          },
        ),
      );
    }

    return TNavBar(
      key: widget.navBarKey,
      title: widget.title,
      leading: leftBarItems,
      actions: rightBarItems,
      // ExamplePage 外层 SafeArea 已负责顶部避让。
      useSafeArea: false,
    );
  }

  Widget _buildHeader() {
    if (widget.showSingleChild) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TText(
            widget.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: context.tTheme.textColorPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: TText(
              widget.desc,
              font: context.tTheme.fontBodyMedium,
              textColor: context.tTheme.textColorSecondary,
            ),
          ),
          // Expanded(child: ),
        ],
      ),
    );
  }

  Widget _buildModuleTitle(int index, ExampleModule data) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
      child: TText(
        '${index < 10 ? "0$index" : index} ${data.title}',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: context.tTheme.textColorPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExampleItem(ExampleModule data, int index) {
    return Container(
      margin: widget.padding,
      child: ExampleItemWidget(data: data.children[index], index: index),
    );
  }
}

/// 示例模块
class ExampleModule {
  const ExampleModule({Key? key, required this.title, required this.children});

  final String title;

  final List<ExampleItem> children;
}

/// 示例样例数据
class ExampleItem {
  const ExampleItem({
    this.key,
    this.desc = '',
    required this.builder,
    this.methodName,
    this.center = true,
    this.ignoreCode = false,
    this.padding,
  });

  /// Demo 内容的稳定定位与视觉快照边界。
  final Key? key;

  final String desc;

  final WidgetBuilder builder;

  final String? methodName;

  final bool center;

  final bool ignoreCode;

  final EdgeInsetsGeometry? padding;
}

/// 组件示例
class ExampleItemWidget extends StatefulWidget {
  const ExampleItemWidget({required this.data, Key? key, required this.index})
    : super(key: key);

  final ExampleItem data;
  final int index;

  @override
  State<ExampleItemWidget> createState() => _ExampleItemWidgetState();
}

class _ExampleItemWidgetState extends State<ExampleItemWidget> {
  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.data.ignoreCode) {
      child = widget.data.builder(context);
      if (widget.data.center) {
        child = Center(child: child);
      }
    } else {
      child = CodeWrapper(
        builder: widget.data.builder,
        methodName: widget.data.methodName,
        isCenter: widget.data.center,
      );
    }
    if (widget.data.padding != null) {
      child = Padding(padding: widget.data.padding!, child: child);
    }
    if (widget.data.key != null) {
      child = RepaintBoundary(key: widget.data.key, child: child);
    }
    child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.data.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        widget.data.desc.isEmpty
            ? Container()
            : Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: widget.index == 0 ? 8 : 24,
                  bottom: 16,
                ),
                child: TText(
                  widget.data.desc,
                  font: context.tTheme.fontBodyMedium,
                  textColor: context.tTheme.textColorSecondary,
                ),
              ),
        child,
      ],
    );
    return child;
  }
}

class CodeWrapper extends StatefulWidget {
  const CodeWrapper({
    Key? key,
    required this.builder,
    this.methodName,
    this.isCenter = false,
  }) : super(key: key);

  final WidgetBuilder builder;

  final bool isCenter;

  final String? methodName;

  @override
  State<CodeWrapper> createState() => _CodeWrapperState();
}

class _CodeWrapperState extends State<CodeWrapper> {
  static const _apiVisibilityEvent = 'onApiVisibleChange';

  bool apiVisible = false;

  String exampleCodeGroup = '';

  String? codeString;

  Brightness brightness = Brightness.light;
  String? _observerId;

  @override
  void initState() {
    super.initState();
    _observerId = TNotification.addObserver(_apiVisibilityEvent, (arguments) {
      if (mounted && arguments is Map) {
        setState(() {
          apiVisible = arguments['apiVisible'] ?? false;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        var modelTheme = context
            .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
        exampleCodeGroup = modelTheme?.model.codePath ?? '';
        apiVisible = modelTheme?.model.apiVisible ?? false;
        brightness = Theme.of(context).brightness;
      });
    });
  }

  @override
  void dispose() {
    TNotification.removeObserver(_apiVisibilityEvent, _observerId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.builder(context);
    if (widget.isCenter) {
      child = Center(child: child);
    }
    if (apiVisible) {
      child = Stack(
        children: [
          child,
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showCodePanel,
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
                alignment: Alignment.center,
                child: TText('code', textColor: context.tTheme.whiteColor1),
              ),
            ),
          ),
        ],
      );
    }
    return child;
  }

  String _getCodeAssetsPath() {
    var methodName = widget.methodName ?? '';

    var builderString = widget.builder.toString();
    if (methodName.isEmpty) {
      if (builderString.contains('\'')) {
        var strings = builderString.split('\'');
        if (strings.length > 1) {
          methodName = strings[1];
          if (methodName.isNotEmpty && methodName.contains('@')) {
            methodName = methodName.split('@')[0];
          }
        }
      }
    }
    if (methodName.isNotEmpty && exampleCodeGroup.isNotEmpty) {
      debugPrint('example code methodName: $methodName');
      return 'assets/code/${exampleCodeGroup}.$methodName.txt';
    }
    return '';
  }

  void _showCodePanel() async {
    codeString ??= await loadCodeString();
    await showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      context: context,
      builder: (_) {
        if (codeString!.isEmpty) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.tTheme.bgColorSecondaryContainer,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(context.tTheme.radiusDefault),
              ),
            ),
            child: TText(PlatformUtil.isWeb ? 'web不支持演示代码，请在移动端查看' : '暂无演示代码'),
          );
        }

        var lines = codeString!.split('\n');
        debugPrint('lines: ${lines.length}');
        double height = min(
          max(300, lines.length * 17 + 32),
          MediaQuery.of(context).size.height - 150,
        );
        var mdText =
            '''
```dart
${codeString}
```
                  ''';

        var syntaxHighlighterStyle = brightness == Brightness.light
            ? SyntaxHighlighterStyle.lightThemeStyle()
            : SyntaxHighlighterStyle.darkThemeStyle();

        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: context.tTheme.bgColorSecondaryContainer,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.tTheme.radiusDefault),
            ),
          ),
          height: height,
          child: Markdown(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            selectable: false,
            shrinkWrap: true,
            syntaxHighlighter: DartSyntaxHighlighter(syntaxHighlighterStyle),
            data: mdText,
            extensionSet: md.ExtensionSet(
              md.ExtensionSet.gitHubWeb.blockSyntaxes,
              [md.EmojiSyntax(), ...md.ExtensionSet.gitHubWeb.inlineSyntaxes],
            ),
          ),
        );
      },
    );
  }

  Future<String> loadCodeString() async {
    var codeString;
    var assetsPath = _getCodeAssetsPath();
    if (assetsPath.isNotEmpty) {
      try {
        codeString = await rootBundle.loadString(assetsPath);
      } catch (e) {
        debugPrint('$e');
      }
    }
    return codeString;
  }
}

/// State获取标题的扩展
extension TStateExs on State {
  String tTitle() {
    var modelTheme = context
        .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
    return modelTheme?.model.text ?? '';
  }
}

/// StatelessWidget获取标题的扩展
extension TWidgetExs on StatelessWidget {
  String tTitle(BuildContext context) {
    var modelTheme = context
        .dependOnInheritedWidgetOfExactType<ExamplePageInheritedTheme>();
    return modelTheme?.model.text ?? '';
  }
}
