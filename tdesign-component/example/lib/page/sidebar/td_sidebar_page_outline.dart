import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TSideBarOutlinePage演示
///
class TSideBarOutlinePage extends StatefulWidget {
  const TSideBarOutlinePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TSideBarOutlinePageState();
  }
}

class TSideBarOutlinePageState extends State<TSideBarOutlinePage> {
  var currentValue = 1;
  var itemHeight = 278.5;
  final _demoScroller = ScrollController(initialScrollOffset: 278.5);
  final _sideBarController = TSideBarController();
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
        title: 'SideBar 非通栏选项样式',
        exampleCodeGroup: 'sideBar',
        showSingleChild: true,
        singleChild: CodeWrapper(
          isCenter: false,
          builder: _buildOutlineSideBar,
        ));
  }

  @Demo(group: 'sideBar')
  Widget _buildOutlineSideBar(BuildContext context) {
    // 非通栏选项样式
    final list = <SideItemProps>[];
    final pages = <Widget>[];

    for (var i = 0; i < 20; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项${i}',
        value: i,
      ));
      pages.add(getAnchorDemo(i));
    }

    pages.add(Container(
      height: MediaQuery.of(context).size.height - itemHeight,
      decoration: BoxDecoration(color: TTheme.of(context).bgColorContainer),
    ));

    list[1].badge = const TBadge(TBadgeType.redPoint);
    list[2].badge = const TBadge(
      TBadgeType.message,
      count: '8',
    );

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: TSideBar(
            style: TSideBarStyle.outline,
            value: currentValue,
            controller: _sideBarController,
            children: list
                .map((ele) => TSideBarItem(
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
          child: SingleChildScrollView(
            controller: _demoScroller,
            child: Column(
              children: pages,
            ),
          ),
        )
      ],
    );
  }

  Widget getAnchorDemo(int index) {
    return Container(
      decoration: BoxDecoration(color: TTheme.of(context).bgColorContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 15, right: 9),
            child: TText('标题 $index',
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
        // spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TImage(
            assetUrl: 'assets/img/empty.png',
            type: TImageType.roundedSquare,
            width: 48,
            height: 48,
          ),
          SizedBox(width: 16),
          TText('标题', style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}
