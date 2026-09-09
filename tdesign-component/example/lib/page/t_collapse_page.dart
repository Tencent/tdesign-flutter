import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TCollapsePage extends StatefulWidget {
  const TCollapsePage({Key? key}) : super(key: key);

  @override
  TCollapsePageState createState() => TCollapsePageState();
}

const String randomString =
    '此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容此处可自定义内容';

class TCollapsePageState extends State<TCollapsePage> {
  final List<CollapseDataItem> _basicData = generateItems(1, expanded: 0);
  final List<CollapseDataItem> _cardStyleData = generateItems(4, expanded: 3);
  final List<CollapseDataItem> _blockStyleWithOpText =
      generateItems(1, expanded: 0);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tTitle(),
        exampleCodeGroup: 'collapse',
        desc: '可以折叠/展开的内容区域。',
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF6F6F6)
            : context.tTheme.bgColorPage,
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
              desc: '基础折叠面板',
              builder: _buildBasicCollapse,
            ),
            ExampleItem(
              desc: '带操作说明',
              builder: _buildCollapseWithOperationText,
            ),
            ExampleItem(
              desc: '手风琴式',
              builder: _buildAccordionCollapse,
              center: false,
            ),
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(
              desc: '卡片折叠面板',
              builder: _buildCardCollapse,
            ),
          ]),
        ]);
  }

  @ExampleCode(group: 'collapse')
  Widget _buildBasicCollapse(BuildContext context) {
    return TCollapse(
      onExpansionChanged: (int index, bool isExpanded) {
        setState(() {
          _basicData[index].isExpanded = !isExpanded;
        });
      },
      children: _basicData.map((CollapseDataItem item) {
        return TCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }

  @ExampleCode(group: 'collapse')
  Widget _buildCardCollapse(BuildContext context) {
    return TCollapse(
      variant: TCollapseVariant.card,
      onExpansionChanged: (int index, bool isExpanded) {
        setState(() {
          _cardStyleData[index].isExpanded = !isExpanded;
        });
      },
      children: _cardStyleData.map((CollapseDataItem item) {
        return TCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          disabled: item.disabled,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }

  @ExampleCode(group: 'collapse')
  Widget _buildCollapseWithOperationText(BuildContext context) {
    return TCollapse(
      onExpansionChanged: (int index, bool isExpanded) {
        setState(() {
          _blockStyleWithOpText[index].isExpanded = !isExpanded;
        });
      },
      children: _blockStyleWithOpText.map((CollapseDataItem item) {
        return TCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          expandIconTextBuilder: (BuildContext context, bool isExpanded) {
            return isExpanded ? '收起' : '展开';
          },
          isExpanded: item.isExpanded,
          disabled: item.disabled,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }

  @ExampleCode(group: 'collapse')
  Widget _buildAccordionCollapse(BuildContext context) {
    final values = List.generate(4, (index) => '$index');
    String? value = '0';
    return StatefulBuilder(
      builder: (context, setState) {
        return TCollapse<String>(
          mode: TCollapseMode.accordion,
          value: value,
          onChanged: (nextValue) => setState(() => value = nextValue),
          children: values.map((panelValue) {
            return TCollapsePanel(
              headerBuilder: (context, isExpanded) {
                return const Text('折叠面板标题');
              },
              body: const Text(randomString),
              value: panelValue,
              disabled: panelValue == '3',
            );
          }).toList(),
        );
      },
    );
  }
}

class CollapseDataItem {
  CollapseDataItem(
      {required this.expandedValue,
      required this.headerValue,
      this.isExpanded = false});

  final String expandedValue;
  final String headerValue;
  bool isExpanded;
  bool get disabled => expandedValue == '3';
}

List<CollapseDataItem> generateItems(int numOfItems, {int? expanded}) {
  return List.generate(numOfItems, (index) {
    return CollapseDataItem(
      headerValue: '折叠面板标题',
      expandedValue: '$index',
      isExpanded: index == expanded,
    );
  });
}
