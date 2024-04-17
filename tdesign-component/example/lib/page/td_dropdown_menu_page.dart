import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDDropdownMenuPage extends StatelessWidget {
  const TDDropdownMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: TDTheme.of(context).grayColor2,
        child: ExamplePage(
          title: tdTitle(context),
          desc: '菜单呈现数个并列的选项类目，用于整个页面的内容筛选，由菜单面板和菜单选项组成。',
          exampleCodeGroup: 'dropdownMenu',
          children: [
            ExampleModule(title: '组件类型', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '单选上拉菜单',
                // center: false,
                // padding: const EdgeInsets.only(left: 16),
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildUpSimple);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '单选下拉菜单',
                // center: false,
                // padding: const EdgeInsets.only(left: 16),
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildDownSimple);
                },
              ),
            ]),
          ],
        ));
  }
}

@Demo(group: 'dropdownMenu')
TDDropdownMenu _buildUpSimple(BuildContext context) {
  return TDDropdownMenu(
    direction: TDDropdownMenuDirection.up,
    builder: (context) {
      return [
        TDDropdownItem(
          options: [
            TDDropdownItemOption(label: 'test1', value: '1'),
            TDDropdownItemOption(label: 'test2', value: '2', disabled: true),
            TDDropdownItemOption(label: 'test3', value: '3', selected: true),
          ],
          // ignore: unnecessary_lambdas
          onChange: (value) {
            print(value);
          },
        ),
        const TDDropdownItem(label: 'test2', disabled: true)
      ];
    },
  );
}


@Demo(group: 'dropdownMenu')
TDDropdownMenu _buildDownSimple(BuildContext context) {
  return TDDropdownMenu(direction: TDDropdownMenuDirection.down, builder: (context) {
    return [
      TDDropdownItem(
        multiple: true,
        options: [
            TDDropdownItemOption(label: 'test1', value: '1'),
            TDDropdownItemOption(label: 'test2', value: '2', disabled: true),
            TDDropdownItemOption(label: 'test3', value: '3', selected: true),
        ],
      ),
      TDDropdownItem(
        label: 'test2',
        multiple: true,
        optionsColumns: 2,
        options: [
            TDDropdownItemOption(label: 'test1，是的是的是', value: '1'),
            TDDropdownItemOption(label: 'test2', value: '2', disabled: true),
            TDDropdownItemOption(label: 'test3', value: '3', selected: true),
        ],
      )
    ];
  });
}