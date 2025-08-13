import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

///
/// TDSideBarAnchorPage演示
///
class TDSideBarAnchorPage extends StatefulWidget {
  const TDSideBarAnchorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDSideBarAnchorPageState();
  }
}

class TDSideBarAnchorPageState extends State<TDSideBarAnchorPage> {
  var currentValue = 1;
  var itemHeight = 278.5;
  var titleBarHeight = 44;
  var testButtonHeight = 80.0;
  final _demoScroller = ScrollController(initialScrollOffset: 278.5);
  final _sideBarController = TDSideBarController();
  static const threshold = 50;
  var lock = false;
  var list = <SideItemProps>[];
  final pages = <Widget>[];

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

    // 锚点用法

    for (var i = 0; i < 20; i++) {
      list.add(SideItemProps(
        index: i,
        label: '选项',
        value: i,
      ));
      pages.add(getAnchorDemo(i));
    }

    list[1].badge = const TDBadge(TDBadgeType.redPoint);
    list[2].badge = const TDBadge(
      TDBadgeType.message,
      count: '8',
    );

    _sideBarController.init(list);
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
    if(mounted){
      setState(() {
        currentValue = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
        title: 'SideBar 锚点用法',
        exampleCodeGroup: 'sideBar',
        showSingleChild: true,
        singleChild: CodeWrapper(
          isCenter: false,
          builder: _buildAnchorSideBar,
        ));
  }

  @Demo(group: 'sideBar')
  Widget _buildAnchorSideBar(BuildContext context) {
    var demoHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        titleBarHeight - testButtonHeight;
    pages.add(Container(
      height: demoHeight - itemHeight,
      decoration: const BoxDecoration(color: Colors.white),
    ));
    return Column(
      children: [
        Container(
          height: testButtonHeight,
          padding: const EdgeInsets.all(16),
          child: TDButton(text: '更新children',
            onTap: () {
              setState(() {
                var children = list
                    .map((e) => SideItemProps(
                    index: e.index,
                    label: '变更',
                    badge: e.badge,
                    value: e.value,
                    icon: e.icon))
                    .toList();
                _sideBarController.children = children;
                setState(() {

                });
              });
            },),
        ),
        Row(
          children: [
            SizedBox(
              width: 110,
              child: TDSideBar(
                height: demoHeight,
                style: TDSideBarStyle.normal,
                value: currentValue,
                controller: _sideBarController,
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
        )
      ],
    );
  }

  Widget getAnchorDemo(int index) {
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
