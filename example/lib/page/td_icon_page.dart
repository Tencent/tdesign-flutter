import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';


class TDIconPage extends StatefulWidget {
  const TDIconPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDIconPageState();
}

class _TDIconPageState extends State<TDIconPage> {

  bool showBorder = false;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(title: tdTitle(),
        exampleCodeGroup: 'icon',
        children: [
        ExampleModule(title: 'icon示例',
        children: [
          ExampleItem(
              desc: 'icon数量: ${TDIcons.all.length}',
              builder: _showAllIcons)
    ])
        ]);

  }

  @Demo(group: 'icon')
  Widget _showAllIcons(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Wrap(
        children: [
          Container(
            child: TDButton(text: showBorder? '隐藏边框':'显示边框',
              shape: TDButtonShape.filled,
              onTap: (){
                setState(() {
                  showBorder = !showBorder;
                });
              },),
            margin: const EdgeInsets.only(bottom: 16),
          ),
          for (var iconData in TDIcons.all.values) SizedBox(
            height: 100,
            width: 175,

            child: Column(
              children: [
                Container(
                  color: showBorder ? Colors.green : Colors.transparent,
                  child: Icon(iconData),
                ),
                TDText(iconData.name)
              ],
            ),
          )
        ],
      ),
    );
  }
}
