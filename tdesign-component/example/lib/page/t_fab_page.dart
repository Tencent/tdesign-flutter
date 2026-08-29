import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

enum _FabDemoType { base, advance, draggable, collapsible }

class TFabPage extends StatefulWidget {
  const TFabPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TFabPageState();
}

class _TFabPageState extends State<TFabPage> {
  late final ScrollController _scrollController;
  Timer? _expandTimer;
  _FabDemoType _demoType = _FabDemoType.base;
  bool _scrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _expandTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  bool _handlePageScroll(ScrollNotification notification) {
    if (_demoType != _FabDemoType.collapsible) {
      return false;
    }

    if (notification is ScrollStartNotification) {
      _expandTimer?.cancel();
      if (!_scrolling) {
        setState(() => _scrolling = true);
      }
    } else if (notification is ScrollEndNotification) {
      _expandTimer?.cancel();
      _expandTimer = Timer(const Duration(milliseconds: 100), () {
        if (mounted && _scrolling) {
          setState(() => _scrolling = false);
        }
      });
    }
    return false;
  }

  void _selectDemo(_FabDemoType type) {
    _expandTimer?.cancel();
    setState(() {
      _demoType = type;
      _scrolling = false;
    });
  }

  void _onFabPressed() {
    TToast.showText('点击了悬浮按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handlePageScroll,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ExamplePage(
            title: tTitle(),
            desc: '当功能使用图标即可表意清楚时，可使用纯图标悬浮按钮，例如：添加、发布。',
            exampleCodeGroup: 'fab',
            scrollController: _scrollController,
            showTestModule: false,
            children: [
              ExampleModule(
                title: '组件类型',
                children: [
                  ExampleItem(
                    desc: '纯图标悬浮按钮',
                    builder: (context) => _buildSelectorButton(
                      context,
                      type: _FabDemoType.base,
                      text: '纯图标悬浮按钮',
                    ),
                    ignoreCode: true,
                  ),
                  ExampleItem(
                    desc: '图标加文字悬浮按钮',
                    builder: (context) => _buildSelectorButton(
                      context,
                      type: _FabDemoType.advance,
                      text: '图标加文字悬浮按钮',
                    ),
                    ignoreCode: true,
                  ),
                ],
              ),
              ExampleModule(
                title: '组件样式',
                children: [
                  ExampleItem(
                    desc: '可移动悬浮按钮',
                    builder: (context) => _buildSelectorButton(
                      context,
                      type: _FabDemoType.draggable,
                      text: '可移动悬浮按钮',
                    ),
                    ignoreCode: true,
                  ),
                  ExampleItem(
                    desc: '带自动收缩功能',
                    builder: (context) => _buildSelectorButton(
                      context,
                      type: _FabDemoType.collapsible,
                      text: '带自动收缩功能',
                    ),
                    ignoreCode: true,
                  ),
                  ExampleItem(
                    builder: _buildSkeletonContent,
                    center: false,
                    ignoreCode: true,
                  ),
                ],
              ),
            ],
          ),
          _buildSelectedFab(context),
        ],
      ),
    );
  }

  Widget _buildSelectorButton(
    BuildContext context, {
    required _FabDemoType type,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: TButton(
          size: TButtonSize.large,
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: () => _selectDemo(type),
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildSkeletonContent(BuildContext context) {
    Widget buildGroup() {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skeletonLine(widthFactor: 1),
            const SizedBox(height: 16),
            _skeletonLine(widthFactor: 0.61),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
      child: Column(
        children: [
          Row(
            children: [buildGroup(), const SizedBox(width: 16), buildGroup()],
          ),
          const SizedBox(height: 32),
          Row(
            children: [buildGroup(), const SizedBox(width: 16), buildGroup()],
          ),
        ],
      ),
    );
  }

  Widget _skeletonLine({required double widthFactor}) => FractionallySizedBox(
    widthFactor: widthFactor,
    child: Container(
      height: 16,
      decoration: BoxDecoration(
        color: context.tTheme.bgColorSecondaryContainer,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    ),
  );

  Widget _buildSelectedFab(BuildContext context) => switch (_demoType) {
    _FabDemoType.base => _buildPureIconFab(context),
    _FabDemoType.advance => _buildTextFab(context),
    _FabDemoType.draggable => _buildDraggableFab(context),
    _FabDemoType.collapsible => _buildCollapsibleFab(context),
  };

  @ExampleCode(group: 'fab')
  Widget _buildPureIconFab(BuildContext context) {
    return TFab(onPressed: _onFabPressed, semanticLabel: '增加');
  }

  @ExampleCode(group: 'fab')
  Widget _buildTextFab(BuildContext context) {
    return TFab(
      icon: const Icon(TIcons.share),
      text: '分享给朋友',
      onPressed: _onFabPressed,
    );
  }

  @ExampleCode(group: 'fab')
  Widget _buildDraggableFab(BuildContext context) {
    return TFab(
      icon: const Icon(TIcons.gesture_press),
      text: '拖我',
      draggable: TFabDragAxis.all,
      yBounds: const TFabBounds(start: 0, end: 32),
      onPressed: _onFabPressed,
    );
  }

  @ExampleCode(group: 'fab')
  Widget _buildCollapsibleFab(BuildContext context) {
    return TFab(
      right: _scrolling ? 0 : 16,
      bottom: _scrolling ? 64 : 24,
      onPressed: _onFabPressed,
      child: _scrolling
          ? const _CollapsedFabContent()
          : const _ExpandedFabContent(),
    );
  }
}

class _ExpandedFabContent extends StatelessWidget {
  const _ExpandedFabContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 156,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: ShapeDecoration(
        color: context.tTheme.bgColorContainer,
        shape: StadiumBorder(
          side: BorderSide(color: context.tTheme.componentBorderColor),
        ),
        shadows: context.tTheme.shadowsMiddle ?? const [],
      ),
      child: const Column(
        children: [
          Expanded(
            child: _CollapsibleAction(icon: TIcons.add_circle, text: '添加'),
          ),
          SizedBox(height: 4),
          Expanded(
            child: _CollapsibleAction(icon: TIcons.star, text: '收藏'),
          ),
          SizedBox(height: 4),
          Expanded(
            child: _CollapsibleAction(icon: TIcons.jump, text: '分享'),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleAction extends StatelessWidget {
  const _CollapsibleAction({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(icon, size: 20, color: context.tTheme.textColorPrimary),
          TText(
            text,
            font: context.tTheme.fontBodySmall,
            textColor: context.tTheme.textColorPrimary,
          ),
        ],
      ),
    );
  }
}

class _CollapsedFabContent extends StatelessWidget {
  const _CollapsedFabContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: ShapeDecoration(
        color: context.tTheme.bgColorContainer,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(16),
          ),
          side: BorderSide(color: context.tTheme.componentBorderColor),
        ),
        shadows: context.tTheme.shadowsMiddle ?? const [],
      ),
      alignment: Alignment.center,
      child: Icon(
        TIcons.chevron_left,
        size: 20,
        color: context.tTheme.textColorPrimary,
      ),
    );
  }
}
