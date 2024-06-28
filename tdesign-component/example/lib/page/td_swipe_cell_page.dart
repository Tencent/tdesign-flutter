import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDSwipeCellPage extends StatelessWidget {
  const TDSwipeCellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      exampleCodeGroup: 'swiperCell',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
                desc: '用于承载列表中的更多操作，通过左右滑动来展示，按钮的宽度固定高度根据列表高度而变化。',
                ignoreCode: true,
                builder: (_) {
                  return _buildSwiperCell(context);
                }),
          ],
        ),
      ],
      test: const [],
    );
  }

  // var cl = false;

  @Demo(group: 'swiperCell')
  Widget _buildSwiperCell(BuildContext context) {
    return const _Demo();
  }
}

class _Demo extends StatefulWidget {
  const _Demo({
    Key? key,
  }) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<_Demo> {
  @override
  Widget build(BuildContext context) {
    return TDSwipeAutoClose(
      child: Column(
        children: [
          TDSwipeCell(
            groupTag: '0',
            opened: const [true],
            onChange: (direction, open) {
              print(direction);
              print(open);
            },
            left: TDSwipePanel(
              dragDismissible: true,
              children: [
                const TDSwipeAction(
                  flex: 2,
                  backgroundColor: Color.fromARGB(255, 218, 16, 16),
                  label: '删除',
                  icon: TDIcons.delete,
                  direction: Axis.vertical,
                ),
                const TDSwipeAction(
                  backgroundColor: Color.fromARGB(255, 17, 50, 212),
                  label: '收藏',
                  icon: TDIcons.user_avatar,
                  direction: Axis.vertical,
                ),
              ],
            ),
            right: TDSwipePanel(
              // dragDismissible: true,
              children: [
                const TDSwipeAction(
                  backgroundColor: Color.fromARGB(255, 218, 16, 16),
                  label: '删除',
                  icon: TDIcons.delete,
                  direction: Axis.vertical,
                ),
                const TDSwipeAction(
                  backgroundColor: Color.fromARGB(255, 17, 50, 212),
                  label: '收藏',
                  icon: TDIcons.user_avatar,
                  // direction: Axis.vertical,
                ),
              ],
              confirms: [
                const TDSwipeAction(
                  backgroundColor: Color.fromARGB(255, 218, 16, 16),
                  label: '确认删除？',
                  icon: TDIcons.delete,
                  direction: Axis.vertical,
                  confirmIndex: [1],
                ),
              ],
            ),
            cell: const ListTile(title: Text('Slide me')),
          ),
          TDSwipeCell(
            groupTag: '0',
            // opened: const [true],
            onChange: (direction, open) {
              print(direction);
              print(open);
            },
            left: TDSwipePanel(
              // dragDismissible: true,
              children: [
                const TDSwipeAction(
                  backgroundColor: Color.fromARGB(255, 218, 16, 16),
                  label: '删除',
                  icon: TDIcons.delete,
                  direction: Axis.vertical,
                ),
                const TDSwipeAction(
                  backgroundColor: Color.fromARGB(255, 17, 50, 212),
                  label: '收藏',
                  icon: TDIcons.user_avatar,
                  // direction: Axis.vertical,
                ),
              ],
            ),
            right: TDSwipePanel(
              // dragDismissible: true,
              children: [
                const TDSwipeAction(
                  backgroundColor: Color.fromARGB(255, 218, 16, 16),
                  label: '删除',
                  icon: TDIcons.delete,
                  direction: Axis.vertical,
                ),
                const TDSwipeAction(
                  backgroundColor: Color.fromARGB(255, 17, 50, 212),
                  label: '收藏',
                  icon: TDIcons.user_avatar,
                  // direction: Axis.vertical,
                ),
              ],
            ),
            cell: const ListTile(title: Text('Slide me')),
          ),
        ],
      ),
    );
  }
}
