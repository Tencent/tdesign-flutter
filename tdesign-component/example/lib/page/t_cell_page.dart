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
      desc: '用于各个类别行的信息展示。',
      exampleCodeGroup: 'cell',
      backgroundColor: context.tTheme.bgColorPage,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              key: const Key('cell-demo-single-line'),
              desc: '单行单元格',
              builder: _buildSingleLine,
              center: false,
            ),
            ExampleItem(
              key: const Key('cell-demo-multiple-line'),
              desc: '多行单元格',
              builder: _buildMultipleLine,
              center: false,
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              key: const Key('cell-demo-card'),
              desc: '卡片单元格',
              builder: _buildCardGroup,
              center: false,
            ),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'cell')
  Widget _buildSingleLine(BuildContext context) {
    var switchValue = true;
    return StatefulBuilder(
      builder: (context, setState) {
        final cells = [
          TCell(title: const Text('单行标题'), arrow: true, onTap: () {}),
          TCell(
            title: const Text('单行标题'),
            required: true,
            arrow: true,
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题', semanticsLabel: '单行标题，有16条消息'),
            note: const TBadge(label: '16'),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            note: TSwitch(
              value: switchValue,
              onChanged: (value) => setState(() => switchValue = value),
            ),
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            note: const Text('辅助信息'),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            prefix: Icon(
              TIcons.app,
              size: 24,
              color: context.tTheme.brandNormalColor,
            ),
            title: const Text('单行标题'),
            arrow: true,
            onTap: () {},
          ),
        ];
        return Column(
          children: [
            for (var index = 0; index < cells.length; index++) ...[
              cells[index],
              if (index < cells.length - 1)
                Divider(
                  height: 0.5,
                  thickness: 0.5,
                  indent: 16,
                  color: context.tTheme.componentStrokeColor,
                ),
            ],
          ],
        );
      },
    );
  }

  @ExampleCode(group: 'cell')
  Widget _buildMultipleLine(BuildContext context) {
    var switchValue = true;
    const description = '一段很长很长的内容文字';
    return StatefulBuilder(
      builder: (context, setState) {
        final cells = [
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text(description),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text(description),
            required: true,
            arrow: true,
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text(description),
            note: const TBadge(label: '16'),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text(description),
            note: TSwitch(
              value: switchValue,
              onChanged: (value) => setState(() => switchValue = value),
            ),
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text(description),
            note: const Text('辅助信息'),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            prefix: Icon(
              TIcons.app,
              size: 24,
              color: context.tTheme.brandNormalColor,
            ),
            title: const Text('单行标题'),
            subtitle: const Text(description),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            title: const Text('单行标题'),
            subtitle: const Text('一段很长很长的内容文字，长文本自动换行，该选项的描述是一段很长的内容'),
            onTap: () {},
          ),
          TCell(
            image: const TImage(
              src: 'assets/img/t_avatar_1.png',
              variant: TImageVariant.circle,
              width: 48,
              height: 48,
            ),
            title: const Text('单行标题'),
            subtitle: const Text('一段很长很长很长的内容文字'),
            arrow: true,
            onTap: () {},
          ),
          TCell(
            image: const TImage(
              src: 'assets/img/t_avatar_1.png',
              variant: TImageVariant.circle,
              width: 48,
              height: 48,
            ),
            title: const Text('单行标题'),
            subtitle: const Text(description),
            align: TCellAlign.top,
            onTap: () {},
          ),
        ];
        return Column(
          children: [
            for (var index = 0; index < cells.length; index++) ...[
              cells[index],
              if (index < cells.length - 1)
                Divider(
                  height: 0.5,
                  thickness: 0.5,
                  indent: 16,
                  color: context.tTheme.componentStrokeColor,
                ),
            ],
          ],
        );
      },
    );
  }

  @ExampleCode(group: 'cell')
  Widget _buildCardGroup(BuildContext context) {
    return TCellGroup(
      variant: TCellGroupVariant.card,
      cells: [
        TCell(
          prefix: Icon(
            TIcons.service,
            size: 24,
            color: context.tTheme.brandNormalColor,
          ),
          title: const Text('单行标题'),
          arrow: true,
          onTap: () {},
        ),
        TCell(
          prefix: Icon(
            TIcons.internet,
            size: 24,
            color: context.tTheme.brandNormalColor,
          ),
          title: const Text('单行标题'),
          arrow: true,
          onTap: () {},
        ),
        TCell(
          prefix: Icon(
            TIcons.lock_on,
            size: 24,
            color: context.tTheme.brandNormalColor,
          ),
          title: const Text('单行标题'),
          arrow: true,
          onTap: () {},
        ),
      ],
    );
  }
}
