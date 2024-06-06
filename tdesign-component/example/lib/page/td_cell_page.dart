import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDCellPage extends StatelessWidget {
  const TDCellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: TDTheme.of(context).grayColor2,
        child: ExamplePage(
          title: tdTitle(context),
          desc: '一行内容/功能的垂直排列方式。一行项目左侧为主要内容展示区域，右侧可增加更多操作内容。',
          exampleCodeGroup: 'cell',
          children: [
            ExampleModule(title: '组件类型', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '单行单元格',
                center: false,
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildSimple);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '多行单元格',
                center: false,
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildDesSimple);
                },
              ),
            ]),
            ExampleModule(title: '组件样式', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '卡片单元格',
                center: false,
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildCard);
                },
              ),
            ]),
          ],
          test: const [
            // ExampleItem(
            //   ignoreCode: true,
            //   desc: '显示外边框',
            //   center: false,
            //   builder: (BuildContext context) {
            //     return const CodeWrapper(builder: _buildBorder);
            //   },
            // ),
            // ExampleItem(
            //   ignoreCode: true,
            //   desc: '显示标题',
            //   center: false,
            //   builder: (BuildContext context) {
            //     return const CodeWrapper(builder: _buildTitle);
            //   },
            // ),
          ],
        ));
  }
}

@Demo(group: 'cell')
Widget _buildSimple(BuildContext context) {
  return const TDCellGroup(
    cells: [
      TDCell(arrow: true, title: '单行标题'),
      TDCell(arrow: true, title: '单行标题', required: true),
      TDCell(arrow: true, title: '单行标题', noteWidget: TDBadge(TDBadgeType.message, count: '8')),
      TDCell(arrow: false, title: '单行标题', rightIconWidget: TDSwitch(isOn: true)),
      TDCell(arrow: true, title: '单行标题', note: '辅助信息'),
      TDCell(arrow: true, title: '单行标题', leftIcon: TDIcons.lock_on),
      TDCell(arrow: false, title: '单行标题'),
    ],
  );
}

@Demo(group: 'cell')
Widget _buildDesSimple(BuildContext context) {
  return const TDCellGroup(
    cells: [
      TDCell(arrow: true, title: '单行标题', description: '一段很长很长的内容文字'),
      TDCell(arrow: true, title: '单行标题', description: '一段很长很长的内容文字', required: true),
      TDCell(
          arrow: true, title: '单行标题', description: '一段很长很长的内容文字', noteWidget: TDBadge(TDBadgeType.message, count: '8')),
      TDCell(arrow: false, title: '单行标题', description: '一段很长很长的内容文字', rightIconWidget: TDSwitch(isOn: true)),
      TDCell(arrow: true, title: '单行标题', description: '一段很长很长的内容文字', note: '辅助信息'),
      TDCell(arrow: true, title: '单行标题', description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内', leftIcon: TDIcons.lock_on),
      TDCell(arrow: false, title: '单行标题', description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内'),
      TDCell(arrow: false, title: '多行高度不定，长文本自动换行，该选项的描述是一段很长的内容', description: '一段很长很长的内容文字一段很长很长的内容文字一段很长很长的内'),
      TDCell(
        arrow: true,
        title: '多行带头像',
        description: '一段很长很长的内容文字',
        image: AssetImage('assets/img/td_avatar_1.png'),
      ),
      // NetworkImage('https://tdesign.gtimg.com/mobile/demos/avatar1.png')),
      TDCell(
        arrow: true,
        title: '多行带图片',
        description: '一段很长很长的内容文字',
        image: AssetImage('assets/img/image.png'),
        imageCircle: 8,
      ),
    ],
  );
}

@Demo(group: 'cell')
Widget _buildCard(BuildContext context) {
  return const TDCellGroup(
    theme: TDCellGroupTheme.cardTheme,
    cells: [
      TDCell(arrow: true, title: '单行标题'),
      TDCell(arrow: true, title: '单行标题', required: true),
      TDCell(arrow: true, title: '单行标题'),
    ],
  );
}

// @Demo(group: 'cell')
// Widget _buildBorder(BuildContext context) {
//   return const TDCellGroup(
//     theme: TDCellGroupTheme.cardTheme,
//     bordered: true,
//     cells: [
//       TDCell(arrow: true, title: '单行标题'),
//       TDCell(arrow: true, title: '单行标题', required: true),
//       TDCell(arrow: true, title: '单行标题'),
//     ],
//   );
// }

// @Demo(group: 'cell')
// Widget _buildTitle(BuildContext context) {
//   var style = TDCellStyle.cellStyle(context);
//   style.leftIconColor = TDTheme.of(context).fontGyColor1;
//   return TDCellGroup(
//     title: '标题',
//     style: style,
//     cells: const [
//       TDCell(title: 'item', leftIcon: TDIcons.app),
//       TDCell(title: 'item', leftIcon: TDIcons.app),
//       TDCell(title: 'item', leftIcon: TDIcons.app),
//     ],
//   );
// }