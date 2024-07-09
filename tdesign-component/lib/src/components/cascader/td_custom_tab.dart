import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

typedef TapCallback = void Function(int index);

class TDCustomTab extends StatefulWidget {
  final List<String> tabs;
  final TapCallback? onTap;
  final int? initialIndex;
  const TDCustomTab({super.key, required this.tabs, this.onTap,this.initialIndex});

  @override
  State<TDCustomTab> createState() => _TDCustomTabState();
}

class _TDCustomTabState extends State<TDCustomTab> {
  ScrollController _scrollController = ScrollController();
  int _currentTabIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    _currentTabIndex=widget.initialIndex??0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(widget.tabs.length, (index) {
            return GestureDetector(
                onTap:(){
                  setState(() {
                    _currentTabIndex = index;
                  });
                  // final ScrollPosition position = _scrollController!.position;
                  // _scrollToListIndex(index);
                  _onChangeTab(index);
                },
                child: Container(
                    width: 96,
                    height: 52,
                    child: Stack(
                      children: [
                        Center(
                          child: TDText(
                            widget.tabs[index],
                            style: TextStyle(
                                fontSize: 16,
                                color: _currentTabIndex == index ? TDTheme.of(context).brandNormalColor : Colors.black),
                                fontWeight: _currentTabIndex == index ?FontWeight.w600:FontWeight.w400,
                          ),
                        ),
                        if (_currentTabIndex == index)
                          Positioned(
                            bottom: 0,
                            left: (96 - 20) / 2,
                            child: Center(
                              child: Container(
                                width: 20,
                                height: 1.5,
                                color: TDTheme.of(context).brandNormalColor,
                              ),
                            ),
                          ),
                      ],
                    ))
            );
          })),
    );
  }

  void _onChangeTab(int index) {
    if (widget.onTap != null) {
      widget.onTap!(index);
    }
  }
  /// 定位选项在列表中位置
  void _scrollToListIndex(int index) {
    // 计算列表中特定索引的位置
    double scrollTo = index * 96.0;

    _scrollController.animateTo(
      scrollTo,
      duration: Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }
}
