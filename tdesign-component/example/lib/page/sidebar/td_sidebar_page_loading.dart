import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TDSideBarLoadingPage演示
///
class TDSideBarLoadingPage extends StatefulWidget {
  const TDSideBarLoadingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDSideBarLoadingPageState();
  }
}

class TDSideBarLoadingPageState extends State<TDSideBarLoadingPage> {
  var currentValue = 1;
  var itemHeight = 278.5;
  final _demoScroller = ScrollController(initialScrollOffset: 278.5);
  final _sideBarController = TDSideBarController();
  static const threshold = 50;
  var lock = false;

  @override
  void initState() {
    super.initState();

    _demoScroller.addListener(() {
      if (lock) {
        return;
      }

      var scrollTop = _demoScroller.offset;
      var index = (scrollTop + threshold) ~/ itemHeight;

      if (currentValue != index) {
        setState(() {
          _sideBarController.selectTo(index);
        });
      }
    });
  }

  Future<void> onSelected(int value) async {
    if (currentValue != value) {
      setState(() {
        currentValue = value;
      });

      lock = true;
      await _demoScroller.animateTo(value.toDouble() * itemHeight,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      lock = false;
    }
  }

  void onChanged(int value) {
    setState(() {
      currentValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
        title: 'SideBar 延迟加载',
        exampleCodeGroup: 'sideBar',
        showSingleChild: true,
        singleChild: CodeWrapper(
          isCenter: false,
          builder: _buildLoadingSideBar,
        ));
  }

  List<SideItemProps> list = <SideItemProps>[];
  List<Widget> pages = <Widget>[];

  void _initData() {
    list = [];
    pages = [];
    for (var i = 0; i < 20; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getLoadingDemo(i));
    }

    pages.add(Container(
      height: MediaQuery.of(context).size.height - itemHeight,
      decoration: const BoxDecoration(color: Colors.white),
    ));

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );
    if(_sideBarController.loading) {
      _sideBarController.init(list);
      _sideBarController.selectTo(currentValue);
      // 初始化时避免右侧内容与左侧item不匹配
      _demoScroller.animateTo(currentValue.toDouble() * itemHeight,
          duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
    }
  }

  @Demo(group: 'sideBar')
  Widget _buildLoadingSideBar(BuildContext context) {
    // 延迟加载
    Future.delayed(const Duration(seconds: 3), _initData);
    var size = MediaQuery.of(context).size;
    var demoHeight = size.height;

    return Row(
      children: [
        SizedBox(
          width: list.isEmpty ? size.width : 110,
          child: TDSideBar(
            height: demoHeight,
            style: TDSideBarStyle.normal,
            value: currentValue,
            controller: _sideBarController,
            loading: true,
            children: list
                .map((ele) => TDSideBarItem(
                    label: ele.label ?? '',
                    badge: ele.badge,
                    value: ele.value,
                    icon: ele.icon))
                .toList(),
            onChanged: onChanged,
            onSelected: onSelected,
          ),
        ),
        Expanded(
            child: SizedBox(
          height: demoHeight,
          child: SingleChildScrollView(
            controller: _demoScroller,
            child: Column(
              children: pages,
            ),
          ),
        ))
      ],
    );
  }

  Widget getLoadingDemo(int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15, right: 9),
            child: TDText('标题$index',
                style: const TextStyle(
                  fontSize: 14,
                )),
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
        const TDDivider(),
        displayImageItem(),
        const TDDivider(),
        displayImageItem(),
        const TDDivider(),
      ],
    );
  }

  Widget displayImageItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          TDImage(
            assetUrl: 'assets/img/empty.png',
            type: TDImageType.roundedSquare,
            width: 48,
            height: 48,
          ),
          SizedBox(
            width: 16,
          ),
          TDText(
            '标题',
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
