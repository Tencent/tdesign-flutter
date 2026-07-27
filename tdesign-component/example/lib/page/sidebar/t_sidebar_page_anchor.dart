import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

///
/// TSideBarAnchorPage演示
///
class TSideBarAnchorPage extends StatefulWidget {
  const TSideBarAnchorPage({
    super.key,
    this.title = 'SideBar 锚点用法',
    this.style = TSideBarVariant.normal,
    this.withIcons = false,
  });

  final String title;
  final TSideBarVariant style;
  final bool withIcons;

  @override
  State<StatefulWidget> createState() {
    return TSideBarAnchorPageState();
  }
}

class TSideBarAnchorPageState extends State<TSideBarAnchorPage> {
  static const _anchorEdgeTolerance = 0.5;

  var currentValue = 0;
  final _demoScroller = ScrollController();
  var _isProgrammaticScroll = false;
  var list = <TSideBarItem>[];
  final _headerKeys = List.generate(20, (_) => GlobalKey());
  final _contentViewportKey = GlobalKey();
  final _lastSectionKey = GlobalKey();
  var _trailingExtent = 0.0;

  @override
  void initState() {
    super.initState();

    _demoScroller.addListener(() {
      if (_isProgrammaticScroll) {
        return;
      }
      _syncSelectionFromViewport();
    });

    for (var i = 0; i < 20; i++) {
      list.add(TSideBarItem(
        label: '选项$i',
        value: i,
        icon: widget.withIcons ? TIcons.app : null,
      ));
    }

    list[1] = TSideBarItem(
      label: list[1].label,
      value: list[1].value,
      icon: list[1].icon,
      textStyle: list[1].textStyle,
      badge: const TBadge(variant: TBadgeVariant.dot),
    );
    list[2] = TSideBarItem(
      label: list[2].label,
      value: list[2].value,
      icon: list[2].icon,
      textStyle: list[2].textStyle,
      badge: const TBadge(count: 8),
    );
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

  Future<void> _scrollToHeader(int index) async {
    final context = _headerKeys[index].currentContext;
    if (context == null) {
      return;
    }
    await Scrollable.ensureVisible(
      context,
      alignment: 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> handleSidebarChange(int value) async {
    if (currentValue != value) {
      setState(() => currentValue = value);
    }

    _isProgrammaticScroll = true;
    try {
      await _scrollToHeader(value);
    } finally {
      if (mounted) {
        _isProgrammaticScroll = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _syncSelectionFromViewport();
          }
        });
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
      singleChild: CodeWrapper(
        isCenter: false,
        builder: _buildAnchorSideBar,
      ),
    );
  }

  @ExampleCode(group: 'sideBar')
  Widget _buildAnchorSideBar(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: TButton(
              child: const Text('更新children'),
              onPressed: () {
                setState(() {
                  final children = list
                      .asMap()
                      .entries
                      .map((entry) => TSideBarItem(
                            label: '变更${entry.key}',
                            badge: entry.value.badge,
                            value: entry.value.value,
                            icon: entry.value.icon,
                          ))
                      .toList();
                  list = children;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 106,
                child: TSideBar(
                  style: widget.style,
                  value: currentValue,
                  children: list,
                  onChanged: handleSidebarChange,
                ),
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
                            for (var index = 0;
                                index < _headerKeys.length;
                                index++)
                              getAnchorDemo(index),
                            SizedBox(height: _trailingExtent),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getAnchorDemo(int index) {
    return KeyedSubtree(
      key: index == _headerKeys.length - 1 ? _lastSectionKey : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15, right: 9),
            child: KeyedSubtree(
              key: _headerKeys[index],
              child: TText(
                '标题$index',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: displayImageList(),
          ),
        ],
      ),
    );
  }

  Widget displayImageList() {
    return Column(
      children: [
        displayImageItem(),
        const TDivider(),
        displayImageItem(),
        const TDivider(),
        displayImageItem(),
        const TDivider(),
      ],
    );
  }

  Widget displayImageItem() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // spacing: 16,
        children: [
          TImage(
            src: 'assets/img/empty.png',
            variant: TImageVariant.roundedSquare,
          ),
          SizedBox(width: 16),
          TText('标题', style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}
