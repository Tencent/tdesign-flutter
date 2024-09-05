import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDIndexesPage extends StatelessWidget {
  const TDIndexesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: TDTheme.of(context).grayColor2,
        child: ExamplePage(
          title: tdTitle(context),
          desc: '用于页面中信息快速检索，可以根据目录中的页码快速找到所需的内容。',
          exampleCodeGroup: 'indexes',
          children: [
            ExampleModule(title: '组件类型', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '基础索引类型',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildSimple);
                },
              ),
            ]),
          ],
          test: [],
        ));
  }
}

@Demo(group: 'dropdownMenu')
Widget _buildSimple(BuildContext context) {
  // final renderBox = navBarkey.currentContext!.findRenderObject() as RenderBox;
  // final navHeight = renderBox.size.height;
  // final screenHeight = MediaQuery.of(context).size.height;
  return SizedBox(
    height: 150, // screenHeight - navHeight,
    child: TDIndexes(
      capsuleTheme: true,
      // sticky: true,
      indexList: const ['A', 'B'],
      builderContent: (context, index) {
        return TDCellGroup(cells: [
          TDCell(title: 'test$index'),
          TDCell(title: 'test$index'),
          TDCell(title: 'test$index'),
        ]);
      },
    ),
  );
}
