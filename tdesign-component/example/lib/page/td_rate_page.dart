import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

///
/// TDRadio演示
///
class TDRatePage extends StatefulWidget {
  const TDRatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TDRatePageState();
  }
}

class TDRatePageState extends State<TDRatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        desc: '用于对某行为/事物进行打分。',
        exampleCodeGroup: 'rate',
        backgroundColor: TDTheme.of(context).grayColor2,
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '实心评分', builder: _buildFilledRate),
          ]),
        ]);
  }

  @Demo(group: 'rate')
  Widget _buildFilledRate(BuildContext context) {
    return const Padding(padding: EdgeInsets.all(50), child: TDRate());
  }
}
