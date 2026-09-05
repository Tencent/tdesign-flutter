import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

/// SideBar 锚点与图标示例。
class TSideBarAnchorPage extends StatefulWidget {
  const TSideBarAnchorPage({
    super.key,
    this.title = 'SideBar 锚点用法',
    this.style = TSideBarVariant.line,
    this.withIcons = false,
  });

  final String title;
  final TSideBarVariant style;
  final bool withIcons;

  @override
  State<TSideBarAnchorPage> createState() => TSideBarAnchorPageState();
}

class TSideBarAnchorPageState extends State<TSideBarAnchorPage> {
  static const _anchorEdgeTolerance = 0.5;
  static const _itemCount = 10;

  var currentValue = 1;
  final _demoScroller = ScrollController();
  var _isProgrammaticScroll = false;
  final _headerKeys = List.generate(_itemCount, (_) => GlobalKey());
  final _contentViewportKey = GlobalKey();
  final _lastSectionKey = GlobalKey();
  var _trailingExtent = 0.0;

  @override
  void initState() {
    super.initState();
    _demoScroller.addListener(() {
      if (!_isProgrammaticScroll) {
        _syncSelectionFromViewport();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        handleSidebarChange(currentValue);
      }
    });
  }

  void _syncSelectionFromViewport() {
    final index = _indexForViewport();
    if (index != currentValue && mounted) {
      setState(() => currentValue = index);
    }
  }

  void _syncTrailingExtent() {
    final viewport =
        _contentViewportKey.currentContext?.findRenderObject() as RenderBox?;
    final header =
        _headerKeys.last.currentContext?.findRenderObject() as RenderBox?;
    final section =
        _lastSectionKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewport == null || header == null || section == null) {
      return;
    }
    final headerTop = header.localToGlobal(Offset.zero).dy;
    final sectionBottom =
        section.localToGlobal(Offset.zero).dy + section.size.height;
    final extent = max(0.0, viewport.size.height - (sectionBottom - headerTop));
    if ((extent - _trailingExtent).abs() > _anchorEdgeTolerance && mounted) {
      setState(() => _trailingExtent = extent);
    }
  }

  int _indexForViewport() {
    final viewport =
        _contentViewportKey.currentContext?.findRenderObject() as RenderBox?;
    if (viewport == null) {
      return currentValue;
    }
    final viewportTop = viewport.localToGlobal(Offset.zero).dy;
    var index = 0;
    for (var i = 1; i < _headerKeys.length; i++) {
      final header =
          _headerKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (header == null ||
          header.localToGlobal(Offset.zero).dy >
              viewportTop + _anchorEdgeTolerance) {
        break;
      }
      index = i;
    }
    return index;
  }

  Future<void> handleSidebarChange(int value) async {
    if (currentValue != value) {
      setState(() => currentValue = value);
    }
    final targetContext = _headerKeys[value].currentContext;
    if (targetContext == null) {
      return;
    }
    _isProgrammaticScroll = true;
    try {
      await Scrollable.ensureVisible(
        targetContext,
        alignment: 0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } finally {
      if (mounted) {
        _isProgrammaticScroll = false;
        _syncSelectionFromViewport();
      }
    }
  }

  @override
  void dispose() {
    _demoScroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: widget.title,
      exampleCodeGroup: 'sideBar',
      showSingleChild: true,
      showTestModule: false,
      singleChild: CodeWrapper(isCenter: false, builder: _buildAnchorSideBar),
    );
  }

  @ExampleCode(group: 'sideBar')
  Widget _buildAnchorSideBar(BuildContext context) {
    final labels = List.filled(10, '选项');
    final titles = List.filled(10, '标题');
    final itemCounts = List.filled(10, 8);
    final items = List.generate(
      labels.length,
      (index) => TSideBarItem(
        label: labels[index],
        value: index,
        icon: widget.withIcons ? TIcons.app : null,
        badge: switch (index) {
          1 => const TBadge(variant: TBadgeVariant.dot),
          2 => const TBadge(label: '8'),
          _ => null,
        },
      ),
    );

    Widget buildSection(int sectionIndex) {
      return KeyedSubtree(
        key: sectionIndex == labels.length - 1 ? _lastSectionKey : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeyedSubtree(
              key: ValueKey('sidebar-section-$sectionIndex'),
              child: Container(
                key: _headerKeys[sectionIndex],
                height: 54,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TText(
                  titles[sectionIndex],
                  font: context.tTheme.fontBodyLarge,
                ),
              ),
            ),
            for (var index = 0; index < itemCounts[sectionIndex]; index++)
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: context.tTheme.grayColor2),
                  ),
                ),
                child: Row(
                  children: [
                    const TImage(
                      src: 'assets/img/empty.png',
                      width: 48,
                      height: 48,
                    ),
                    const SizedBox(width: 16),
                    TText('标题', font: context.tTheme.fontBodyLarge),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    return Row(
      children: [
        TSideBar(
          style: widget.style,
          value: currentValue,
          children: items,
          onChanged: handleSidebarChange,
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _syncTrailingExtent();
                }
              });
              return SingleChildScrollView(
                key: _contentViewportKey,
                controller: _demoScroller,
                child: Container(
                  color: context.tTheme.bgColorContainer,
                  child: Column(
                    children: [
                      for (var index = 0; index < labels.length; index++)
                        buildSection(index),
                      SizedBox(height: _trailingExtent),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
