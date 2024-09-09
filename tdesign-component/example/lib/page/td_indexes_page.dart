import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

const _list = [
  {
    'index': 'A',
    'children': ['阿坝', '阿拉善', '阿里', '安康', '安庆', '鞍山', '安顺', '安阳', '澳门'],
  },
  {
    'index': 'B',
    'children': [
      '北京',
      '白银',
      '保定',
      '宝鸡',
      '保山',
      '包头',
      '巴中',
      '北海',
      '蚌埠',
      '本溪',
      '毕节',
      '滨州',
      '百色',
      '亳州',
    ],
  },
  {
    'index': 'C',
    'children': [
      '重庆',
      '成都',
      '长沙',
      '长春',
      '沧州',
      '常德',
      '昌都',
      '长治',
      '常州',
      '巢湖',
      '潮州',
      '承德',
      '郴州',
      '赤峰',
      '池州',
      '崇左',
      '楚雄',
      '滁州',
      '朝阳',
    ],
  },
  {
    'index': 'D',
    'children': [
      '大连',
      '东莞',
      '大理',
      '丹东',
      '大庆',
      '大同',
      '大兴安岭',
      '德宏',
      '德阳',
      '德州',
      '定西',
      '迪庆',
      '东营',
    ],
  },
  {
    'index': 'E',
    'children': ['鄂尔多斯', '恩施', '鄂州'],
  },
  {
    'index': 'F',
    'children': ['福州', '防城港', '佛山', '抚顺', '抚州', '阜新', '阜阳'],
  },
  {
    'index': 'G',
    'children': ['广州', '桂林', '贵阳', '甘南', '赣州', '甘孜', '广安', '广元', '贵港', '果洛'],
  },
  {
    'index': 'J',
    'children': ['揭阳', '吉林', '晋江', '吉安', '胶州', '嘉兴', '济南', '鸡西', '荆州', '江门', '基隆'],
  },
  {
    'index': 'K',
    'children': ['昆明', '开封', '康定', '喀什'],
  },
];

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
            ExampleModule(title: '组件样式', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '其他索引类型',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildOther);
                },
              ),
            ]),
          ],
          test: const [],
        ));
  }
}

@Demo(group: 'indexes')
Widget _buildSimple(BuildContext context) {
  final renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  final indexList = _list.map((item) => item['index'] as String).toList();
  return TDButton(
    text: '基础用法',
    isBlock: true,
    size: TDButtonSize.large,
    theme: TDButtonTheme.primary,
    type: TDButtonType.outline,
    onTap: () {
      Navigator.of(context).push(
        TDSlidePopupRoute(
          slideTransitionFrom: SlideTransitionFrom.right,
          modalTop: renderBox?.size.height,
          builder: (context) {
            return Container(
              color: Colors.white,
              child: TDIndexes(
                indexList: indexList,
                builderContent: (context, index) {
                  final list = _list.firstWhere((element) => element['index'] == index)['children'] as List<String>;
                  return TDCellGroup(
                    cells: list
                        .map((e) => TDCell(
                              title: e,
                            ))
                        .toList(),
                  );
                },
              ),
            );
          },
        ),
      );
    },
  );
}

@Demo(group: 'indexes')
Widget _buildOther(BuildContext context) {
  final renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  final indexList = _list.map((item) => item['index'] as String).toList();
  return TDButton(
    text: '胶囊索引',
    isBlock: true,
    size: TDButtonSize.large,
    theme: TDButtonTheme.primary,
    type: TDButtonType.outline,
    onTap: () {
      Navigator.of(context).push(
        TDSlidePopupRoute(
          slideTransitionFrom: SlideTransitionFrom.right,
          modalTop: renderBox?.size.height,
          builder: (context) {
            return Container(
              color: Colors.white,
              child: TDIndexes(
                indexList: indexList,
                capsuleTheme: true,
                builderContent: (context, index) {
                  final list = _list.firstWhere((element) => element['index'] == index)['children'] as List<String>;
                  return TDCellGroup(
                    cells: list
                        .map((e) => TDCell(
                              title: e,
                            ))
                        .toList(),
                  );
                },
              ),
            );
          },
        ),
      );
    },
  );
}