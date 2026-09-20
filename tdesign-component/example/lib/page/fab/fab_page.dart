import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'fab_collapsible_example.dart';
import 'fab_draggable_example.dart';
import 'fab_icon_only_example.dart';
import 'fab_icon_text_example.dart';
import 'fab_skeleton_content.dart';

enum _FabDemoType { base, advance, draggable, collapsible }

@ExampleCodeManifest()
class TFabPage extends StatefulWidget {
  const TFabPage({super.key});

  @override
  State<TFabPage> createState() => _TFabPageState();
}

class _TFabPageState extends State<TFabPage> {
  final _scrollController = ScrollController();
  Timer? _expandTimer;
  _FabDemoType _demoType = _FabDemoType.base;
  bool _scrolling = false;

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

  void _onFabPressed() => TToast.showText('点击了悬浮按钮', context: context);

  Widget _buildSelectedFab() => switch (_demoType) {
    _FabDemoType.base => FabIconOnlyExample.buildFab(_onFabPressed),
    _FabDemoType.advance => FabIconTextExample.buildFab(_onFabPressed),
    _FabDemoType.draggable => FabDraggableExample.buildFab(_onFabPressed),
    _FabDemoType.collapsible => FabCollapsibleExample.buildFab(
      _onFabPressed,
      scrolling: _scrolling,
    ),
  };

  @override
  Widget build(BuildContext context) =>
      NotificationListener<ScrollNotification>(
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
                      methodName: 'FabIconOnlyExample',
                      builder: (_) => FabIconOnlyExample(
                        onSelected: () => _selectDemo(_FabDemoType.base),
                      ),
                    ),
                    ExampleItem(
                      desc: '图标加文字悬浮按钮',
                      methodName: 'FabIconTextExample',
                      builder: (_) => FabIconTextExample(
                        onSelected: () => _selectDemo(_FabDemoType.advance),
                      ),
                    ),
                  ],
                ),
                ExampleModule(
                  title: '组件样式',
                  children: [
                    ExampleItem(
                      desc: '可移动悬浮按钮',
                      methodName: 'FabDraggableExample',
                      builder: (_) => FabDraggableExample(
                        onSelected: () => _selectDemo(_FabDemoType.draggable),
                      ),
                    ),
                    ExampleItem(
                      desc: '带自动收缩功能',
                      methodName: 'FabCollapsibleExample',
                      builder: (_) => FabCollapsibleExample(
                        onSelected: () => _selectDemo(_FabDemoType.collapsible),
                      ),
                    ),
                    ExampleItem(
                      center: false,
                      ignoreCode: true,
                      builder: (_) => const FabSkeletonContent(),
                    ),
                  ],
                ),
              ],
            ),
            _buildSelectedFab(),
          ],
        ),
      );
}
