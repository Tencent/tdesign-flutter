import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDCalendarPage extends StatelessWidget {
  const TDCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TDTheme.of(context).grayColor2,
      child: ExamplePage(
        title: tdTitle(context),
        desc: '按照日历形式展示数据或日期的容器。',
        exampleCodeGroup: 'calendar',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
              ignoreCode: true,
              center: false,
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildSimple);
              },
            ),
          ]),
        ],
        test: [],
      ),
    );
  }
}

@Demo(group: 'calendar')
Widget _buildSimple(BuildContext context) {
  return const TDCalendar(
    title: '请选择日期',
  );
}
