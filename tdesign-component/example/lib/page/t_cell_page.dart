import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TCellPage extends StatelessWidget {
  const TCellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Cell 单元格',
      exampleCodeGroup: 'cell',
      children: [
        ExampleModule(
          title: '内容槽位',
          children: [
            ExampleItem(desc: '基础单元格', builder: _buildBasic),
            ExampleItem(desc: '副标题与说明', builder: _buildDetail),
            ExampleItem(desc: '图片与图标', builder: _buildLeading),
          ],
        ),
        ExampleModule(
          title: '单元格组',
          children: [
            ExampleItem(desc: '通栏', builder: _buildGroup),
            ExampleItem(desc: '卡片', builder: _buildCardGroup),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'cell')
  Widget _buildBasic(BuildContext context) {
    return const TCell(
      title: Text('单行标题'),
      arrow: true,
    );
  }

  @ExampleCode(group: 'cell')
  Widget _buildDetail(BuildContext context) {
    return const TCell(
      title: Text('单元格标题'),
      subtitle: Text('描述信息'),
      note: Text('辅助信息'),
      required: true,
      arrow: true,
    );
  }

  @ExampleCode(group: 'cell')
  Widget _buildLeading(BuildContext context) {
    return const TCell(
      image: CircleAvatar(
        backgroundImage: AssetImage('assets/img/t_avatar_1.png'),
      ),
      prefix: Icon(Icons.person),
      title: Text('用户信息'),
      trailing: Icon(Icons.more_horiz),
    );
  }

  @ExampleCode(group: 'cell')
  Widget _buildGroup(BuildContext context) {
    return const TCellGroup(
      title: Text('分组标题'),
      cells: [
        TCell(title: Text('单元格一'), arrow: true),
        TCell(title: Text('单元格二'), subtitle: Text('描述信息')),
      ],
    );
  }

  @ExampleCode(group: 'cell')
  Widget _buildCardGroup(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TCellGroup(
        variant: TCellGroupVariant.card,
        cells: [
          TCell(title: Text('单元格一')),
          TCell(title: Text('单元格二'), arrow: true),
        ],
      ),
    );
  }
}
