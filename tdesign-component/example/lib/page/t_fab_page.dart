import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TFabPage extends StatefulWidget {
  const TFabPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TFabPageState();
}

class _TFabPageState extends State<TFabPage> {
  late final ScrollController _scrollController;
  Timer? _expandTimer;
  bool _scrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handlePageScroll);
  }

  @override
  void dispose() {
    _expandTimer?.cancel();
    _scrollController
      ..removeListener(_handlePageScroll)
      ..dispose();
    super.dispose();
  }

  void _handlePageScroll() {
    _expandTimer?.cancel();
    if (!_scrolling) {
      setState(() => _scrolling = true);
    }
    _expandTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => _scrolling = false);
      }
    });
  }

  void _onFabPressed() {
    TToast.showText('点击了悬浮按钮', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '当功能使用图标即可表意清楚时，可使用纯图标悬浮按钮，例如：添加、发布。',
      exampleCodeGroup: 'fab',
      scrollController: _scrollController,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '纯图标悬浮按钮', builder: _buildPureIconFab),
            ExampleItem(desc: '图标加文字悬浮按钮', builder: _buildTextFab),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '可移动悬浮按钮', builder: _buildDraggableFab),
            ExampleItem(desc: '带自动收缩功能', builder: _buildCollapsibleFab),
          ],
        ),
      ],
    );
  }

  Widget _buildPageDemo({required Widget fab, double height = 176}) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(top: 16),
      color: context.tTheme.bgColorContainer,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _skeletonLine(widthFactor: 0.56),
                const SizedBox(height: 16),
                _skeletonLine(widthFactor: 0.36),
                const SizedBox(height: 16),
                _skeletonLine(widthFactor: 0.72),
              ],
            ),
          ),
          fab,
        ],
      ),
    );
  }

  Widget _skeletonLine({required double widthFactor}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 16,
        decoration: BoxDecoration(
          color: context.tTheme.bgColorSecondaryContainer,
          borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
        ),
      ),
    );
  }

  @ExampleCode(group: 'fab')
  Widget _buildPureIconFab(BuildContext context) {
    return _buildPageDemo(
      fab: TFab(onPressed: _onFabPressed, semanticLabel: '增加'),
    );
  }

  @ExampleCode(group: 'fab')
  Widget _buildTextFab(BuildContext context) {
    return _buildPageDemo(
      fab: TFab(
        icon: const Icon(TIcons.share),
        text: '分享给朋友',
        onPressed: _onFabPressed,
      ),
    );
  }

  @ExampleCode(group: 'fab')
  Widget _buildDraggableFab(BuildContext context) {
    return _buildPageDemo(
      fab: TFab(
        icon: const Icon(TIcons.gesture_press),
        text: '拖我',
        draggable: TFabDragAxis.all,
        yBounds: const TFabBounds(start: 0, end: 32),
        onPressed: _onFabPressed,
      ),
    );
  }

  @ExampleCode(group: 'fab')
  Widget _buildCollapsibleFab(BuildContext context) {
    return _buildPageDemo(
      height: 220,
      fab: TFab(
        right: _scrolling ? 0 : 16,
        bottom: _scrolling ? 64 : 24,
        onPressed: _onFabPressed,
        child: _scrolling
            ? const _CollapsedFabContent()
            : const _ExpandedFabContent(),
      ),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _CollapsibleAction(icon: TIcons.add_circle, text: '添加'),
          _CollapsibleAction(icon: TIcons.star, text: '收藏'),
          _CollapsibleAction(icon: TIcons.jump, text: '分享'),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: context.tTheme.textColorPrimary),
        TText(
          text,
          font: context.tTheme.fontBodySmall,
          textColor: context.tTheme.textColorPrimary,
        ),
      ],
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
