import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';
class TDCollapsePage extends StatefulWidget {
  const TDCollapsePage({Key? key}) : super(key: key);

  @override
  TDCollapsePageState createState() => TDCollapsePageState();
}

const String randomString =
    "In the heart of the bustling city, a small park offered a sanctuary of tranquility.Children's laughter echoed from the playground, mingling with the soft rustling of leaves in the gentle breeze.Joggers navigated winding paths, their steady breaths in rhythm with the chirping of the early morning birds.Nearby, an elderly man sat on a bench, engrossed in a book, oblivious to the world around him.The park was a microcosm of life, a testament to the city's vibrant spirit and the enduring allure of nature's simple pleasures.";

class TDCollapsePageState extends State<TDCollapsePage> {
  final List<CollapseDataItem> _basicData = generateItems(5);
  final List<CollapseDataItem> _blockStyleData = generateItems(5);
  final List<CollapseDataItem> _cardStyleData = generateItems(5);
  final List<CollapseDataItem> _blockStyleWithOpText = generateItems(5);
  final List<CollapseDataItem> _accordionData = generateItems(5);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        exampleCodeGroup: 'collapse',
        desc: '可以折叠/展开的内容区域。',
        children: [
          ExampleModule(title: 'Type 组件类型', children: [
            ExampleItem(
              desc: 'Basic 基础折叠面板',
              builder: _buildBasicCollapse,
            ),
            ExampleItem(
              desc: 'with Operation Instructions 带操作说明',
              builder: _buildCollapseWithOperationText,
            ),
            ExampleItem(
              desc: 'Accordion 手风琴式',
              builder: _buildAccordionCollapse,
            ),
          ]),
          ExampleModule(title: 'Style 组件样式', children: [
            ExampleItem(
              desc: 'Block Style 通栏样式',
              builder: _buildBlockStyleCollapse,
            ),
            ExampleItem(
              desc: 'Card Style 卡片样式',
              builder: _buildCardCollapse,
            ),
          ]),
        ]);
  }

  @Demo(group: 'collapse')
  Widget _buildBasicCollapse(BuildContext context) {
    return TDCollapse(
      style: TDCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _basicData[index].isExpanded = !isExpanded;
        });
      },
      children: _basicData.map((CollapseDataItem item) {
        return TDCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }

  @Demo(group: 'collapse')
  Widget _buildBlockStyleCollapse(BuildContext context) {
    return TDCollapse(
      style: TDCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _blockStyleData[index].isExpanded = !isExpanded;
        });
      },
      children: _blockStyleData.map((CollapseDataItem item) {
        return TDCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }

  @Demo(group: 'collapse')
  Widget _buildCardCollapse(BuildContext context) {
    return TDCollapse(
      style: TDCollapseStyle.card,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _cardStyleData[index].isExpanded = !isExpanded;
        });
      },
      children: _cardStyleData.map((CollapseDataItem item) {
        return TDCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }

  @Demo(group: 'collapse')
  Widget _buildCollapseWithOperationText(BuildContext context) {
    return TDCollapse(
      style: TDCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _blockStyleWithOpText[index].isExpanded = !isExpanded;
        });
      },
      children: _blockStyleWithOpText.map((CollapseDataItem item) {
        return TDCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          expandIconTextBuilder: (BuildContext context, bool isExpanded) {
            return isExpanded ? '收起' : '展开';
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }

  @Demo(group: 'collapse')
  Widget _buildAccordionCollapse(BuildContext context) {
    return TDCollapse.accordion(
      style: TDCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _accordionData[index].isExpanded = !isExpanded;
        });
      },
      children: _accordionData.map((CollapseDataItem item) {
        return TDCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
          value: item.expandedValue,
        );
      }).toList(),
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
}

List<CollapseDataItem> generateItems(int numOfItems) {
  return List.generate(numOfItems, (index) {
    return CollapseDataItem(
      headerValue: '标题 $index',
      expandedValue: '$index',
    );
  });
}
