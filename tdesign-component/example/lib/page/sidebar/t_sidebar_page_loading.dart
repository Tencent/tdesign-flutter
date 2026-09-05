import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

/// TSideBarLoadingPage 演示。
class TSideBarLoadingPage extends StatefulWidget {
  const TSideBarLoadingPage({super.key});

  @override
  State<TSideBarLoadingPage> createState() => TSideBarLoadingPageState();
}

class TSideBarLoadingPageState extends State<TSideBarLoadingPage> {
  static const _items = [
    TSideBarItem(value: 0, label: '推荐'),
    TSideBarItem(value: 1, label: '饮品'),
    TSideBarItem(value: 2, label: '甜品'),
    TSideBarItem(value: 3, label: '小食'),
  ];

  var _currentValue = 0;
  var _loading = true;
  Timer? _loadTimer;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    super.dispose();
  }

  void _loadItems() {
    _loadTimer?.cancel();
    setState(() => _loading = true);
    _loadTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _loading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'SideBar 延迟加载',
      exampleCodeGroup: 'sideBar',
      showSingleChild: true,
      singleChild: CodeWrapper(isCenter: false, builder: _buildLoadingSideBar),
    );
  }

  @ExampleCode(group: 'sideBar')
  Widget _buildLoadingSideBar(BuildContext context) {
    final label = _items[_currentValue].label;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerRight,
            child: TButton(
              size: TButtonSize.small,
              variant: TButtonVariant.outline,
              onPressed: _loadItems,
              child: const Text('重新加载'),
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 106,
                child: TSideBar(
                  value: _currentValue,
                  children: _items,
                  loading: _loading,
                  onChanged: (value) => setState(() => _currentValue = value),
                ),
              ),
              Expanded(
                child: Container(
                  color: context.tTheme.bgColorContainer,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(20),
                  child: _loading
                      ? const TLoading(icon: TLoadingIcon.circle, size: 32)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TText(label, font: context.tTheme.fontTitleMedium),
                            const SizedBox(height: 4),
                            TText(
                              '导航数据加载完成后可选择分类',
                              textColor: context.tTheme.textColorSecondary,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
