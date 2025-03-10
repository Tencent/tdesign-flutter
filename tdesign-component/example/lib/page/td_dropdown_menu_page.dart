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
                desc: '单选下拉菜单',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildDownSimple);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '分栏下拉菜单',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildDownChunk);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '向上展开',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildUp);
                },
              ),
            ]),
            ExampleModule(title: '组件状态', children: [
              ExampleItem(
                ignoreCode: true,
                desc: '禁用状态',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildDisabled);
                },
              ),
              ExampleItem(
                ignoreCode: true,
                desc: '分组菜单',
                builder: (BuildContext context) {
                  return const CodeWrapper(builder: _buildGroup);
                },
              ),
            ]),
          ],
          test: [
            ExampleItem(
              ignoreCode: true,
              desc: '自动弹出方向',
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildHidden);
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '最大高度限制',
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildHeight);
              },
            ),
            ExampleItem(
              ignoreCode: true,
              desc: '可横向滚动菜单',
              builder: (BuildContext context) {
                return const CodeWrapper(builder: _buildOverflow);
              },
            ),
          ],
        ));
  }
}

@Demo(group: 'dropdownMenu')
TDDropdownMenu _buildDownSimple(BuildContext context) {
  return TDDropdownMenu(
    direction: TDDropdownMenuDirection.down,
    onMenuOpened: (value) {
      print('打开第$value个菜单');
    },
    onMenuClosed: (value) {
      print('关闭第$value个菜单');
    },
    items: [
      TDDropdownItem(
        options: [
          TDDropdownItemOption(label: '全部产品', value: 'all', selected: true),
          TDDropdownItemOption(label: '最新产品', value: 'new'),
          TDDropdownItemOption(label: '最火产品', value: 'hot'),
        ],
        onChange: (value) {
          print('选择：$value');
        },
      ),
      TDDropdownItem(
        options: [
          TDDropdownItemOption(label: '默认排序', value: 'default', selected: true),
          TDDropdownItemOption(label: '价格从高到低', value: 'price'),
        ],
      ),
    ],
  );
}

@Demo(group: 'dropdownMenu')
TDDropdownMenu _buildDownChunk(BuildContext context) {
  return TDDropdownMenu(
    direction: TDDropdownMenuDirection.down,
    items: [
      TDDropdownItem(
        label: '单列多选',
        multiple: true,
        options: [
          TDDropdownItemOption(label: '选项1', value: '1', selected: true),
          TDDropdownItemOption(label: '选项2', value: '2'),
          TDDropdownItemOption(label: '选项3', value: '3'),
          TDDropdownItemOption(label: '选项4', value: '4'),
          TDDropdownItemOption(label: '选项5', value: '5'),
          TDDropdownItemOption(label: '选项6', value: '6'),
          TDDropdownItemOption(label: '选项7', value: '7'),
          TDDropdownItemOption(label: '选项8', value: '8'),
          TDDropdownItemOption(label: '禁用选项', value: '9', disabled: true),
        ],
        onChange: (value) {
          print('选择：$value');
        },
        onConfirm: (value) {
          print('确定选择：$value');
        },
        onReset: () {
          print('清空选择');
        },
      ),
      TDDropdownItem(
        // label: '双列单选',
        multiple: false,
        optionsColumns: 2,
        maxHeight: 300,
        options: [
          TDDropdownItemOption(label: '双列单选1', value: '1'),
          TDDropdownItemOption(label: '双列单选2', value: '2', selected: true),
          TDDropdownItemOption(label: '双列单选3', value: '3'),
          TDDropdownItemOption(label: '双列单选4', value: '4'),
          TDDropdownItemOption(label: '双列单选5', value: '5'),
          TDDropdownItemOption(label: '双列单选6', value: '6'),
          TDDropdownItemOption(label: '双列单选7', value: '7'),
          TDDropdownItemOption(label: '双列单选8', value: '8'),
          TDDropdownItemOption(label: '禁用选项', value: '9', disabled: true),
          TDDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
        ],
      ),
      TDDropdownItem(
        label: '双列多选',
        multiple: true,
        optionsColumns: 2,
        options: [
          TDDropdownItemOption(label: '选项1', value: '1', selected: true),
          TDDropdownItemOption(label: '选项2', value: '2', selected: true),
          TDDropdownItemOption(label: '选项3', value: '3'),
          TDDropdownItemOption(label: '选项4', value: '4'),
          TDDropdownItemOption(label: '选项5', value: '5'),
          TDDropdownItemOption(label: '选项6', value: '6'),
          TDDropdownItemOption(label: '选项7', value: '7'),
          TDDropdownItemOption(label: '选项8', value: '8'),
          TDDropdownItemOption(label: '禁用选项', value: '9', disabled: true),
          TDDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
        ],
      ),
      TDDropdownItem(
        label: '三列多选',
        multiple: true,
        optionsColumns: 3,
        options: [
          TDDropdownItemOption(label: '选项1', value: '1', selected: true),
          TDDropdownItemOption(label: '选项2', value: '2', selected: true),
          TDDropdownItemOption(label: '选项3', value: '3', selected: true),
          TDDropdownItemOption(label: '选项4', value: '4'),
          TDDropdownItemOption(label: '选项5', value: '5'),
          TDDropdownItemOption(label: '选项6', value: '6'),
          TDDropdownItemOption(label: '选项7', value: '7'),
          TDDropdownItemOption(label: '选项8', value: '8'),
          TDDropdownItemOption(label: '选项9', value: '9'),
          TDDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
          TDDropdownItemOption(label: '禁用选项', value: '11', disabled: true),
          TDDropdownItemOption(label: '禁用选项', value: '12', disabled: true),
        ],
      ),
    ],
  );
}

@Demo(group: 'dropdownMenu')
TDDropdownMenu _buildUp(BuildContext context) {
  return TDDropdownMenu(
    direction: TDDropdownMenuDirection.up,
    onMenuOpened: (value) {
      print('打开第$value个菜单');
    },
    onMenuClosed: (value) {
      print('关闭第$value个菜单');
    },
    builder: (context) {
      return [
        TDDropdownItem(
          options: [
            TDDropdownItemOption(label: '全部产品', value: 'all', selected: true),
            TDDropdownItemOption(label: '最新产品', value: 'new'),
            TDDropdownItemOption(label: '最火产品', value: 'hot'),
          ],
          onChange: (value) {
            print('选择：$value');
          },
        ),
        TDDropdownItem(
          options: [
            TDDropdownItemOption(label: '默认排序', value: 'default', selected: true),
            TDDropdownItemOption(label: '价格从高到低', value: 'price'),
          ],
        ),
      ];
    },
  );
}

@Demo(group: 'dropdownMenu')
TDDropdownMenu _buildDisabled(BuildContext context) {
  return TDDropdownMenu(
    direction: TDDropdownMenuDirection.down,
    builder: (context) {
      return [
        const TDDropdownItem(
          disabled: true,
          label: '禁用菜单',
        ),
        const TDDropdownItem(
          disabled: true,
          label: '禁用菜单',
        ),
      ];
    },
  );
}

@Demo(group: 'dropdownMenu')
TDDropdownMenu _buildGroup(BuildContext context) {
  return TDDropdownMenu(
    direction: TDDropdownMenuDirection.up,
    builder: (context) {
      return [
        TDDropdownItem(
          label: '分组菜单',
          multiple: true,
          optionsColumns: 3,
          options: [
            TDDropdownItemOption(label: '选项1', value: '1', selected: true, group: '类型'),
            TDDropdownItemOption(label: '选项2', value: '2', group: '类型'),
            TDDropdownItemOption(label: '选项3', value: '3', group: '类型'),
            TDDropdownItemOption(label: '选项4', value: '4', group: '类型'),
            TDDropdownItemOption(label: '选项5', value: '5', group: '角色'),
            TDDropdownItemOption(label: '选项6', value: '6', group: '角色'),
            TDDropdownItemOption(label: '选项7', value: '7', group: '角色'),
            TDDropdownItemOption(label: '选项8', value: '8', group: '角色'),
            TDDropdownItemOption(label: '禁用选项', value: '9', disabled: true, group: '角色'),
          ],
          onChange: (value) {
            print('选择：$value');
          },
          onConfirm: (value) {
            print('确定选择：$value');
          },
        ),
      ];
    },
  );
}

@Demo(group: 'dropdownMenu')
TDDropdownMenu _buildHidden(BuildContext context) {
  return TDDropdownMenu(
    direction: TDDropdownMenuDirection.auto,
    arrowIcon: TDIcons.caret_up_small,
    builder: (context) {
      return [
        TDDropdownItem(
          label: '分组菜单',
          multiple: true,
          optionsColumns: 3,
          options: [
            TDDropdownItemOption(label: '选项1', value: '1', selected: true, group: '类型'),
            TDDropdownItemOption(label: '选项2', value: '2', group: '类型'),
            TDDropdownItemOption(label: '选项3', value: '3', group: '类型'),
            TDDropdownItemOption(label: '选项4', value: '4', group: '类型'),
            TDDropdownItemOption(label: '选项5', value: '5', group: '角色'),
            TDDropdownItemOption(label: '选项6', value: '6', group: '角色'),
            TDDropdownItemOption(label: '选项7', value: '7', group: '角色'),
            TDDropdownItemOption(label: '选项8', value: '8', group: '角色'),
            TDDropdownItemOption(label: '禁用选项', value: '9', disabled: true, group: '角色'),
          ],
          onChange: (value) {
            print('选择：$value');
          },
        ),
      ];
    },
  );
}

@Demo(group: 'dropdownMenu')
TDDropdownMenu _buildHeight(BuildContext context) {
  return TDDropdownMenu(
    direction: TDDropdownMenuDirection.up,
    onMenuOpened: (value) {
      print('打开第$value个菜单');
    },
    onMenuClosed: (value) {
      print('关闭第$value个菜单');
    },
    builder: (context) {
      return [
        TDDropdownItem(
          label: '最大高度限制',
          multiple: true,
          maxHeight: 200,
          options: [
            TDDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDDropdownItemOption(label: '选项2', value: '2', selected: true),
            TDDropdownItemOption(label: '选项3', value: '3', selected: true),
            TDDropdownItemOption(label: '选项4', value: '4'),
            TDDropdownItemOption(label: '选项5', value: '5'),
            TDDropdownItemOption(label: '选项6', value: '6'),
            TDDropdownItemOption(label: '选项7', value: '7'),
            TDDropdownItemOption(label: '选项8', value: '8'),
            TDDropdownItemOption(label: '选项9', value: '9'),
            TDDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
            TDDropdownItemOption(label: '禁用选项', value: '11', disabled: true),
            TDDropdownItemOption(label: '禁用选项', value: '12', disabled: true),
          ],
          onChange: (value) {
            print('选择：$value');
          },
        ),
        TDDropdownItem(
          maxHeight: 200,
          options: [
            TDDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDDropdownItemOption(label: '选项2', value: '2'),
            TDDropdownItemOption(label: '选项3', value: '3'),
            TDDropdownItemOption(label: '选项4', value: '4'),
            TDDropdownItemOption(label: '选项5', value: '5'),
            TDDropdownItemOption(label: '选项6', value: '6'),
            TDDropdownItemOption(label: '选项7', value: '7'),
            TDDropdownItemOption(label: '选项8', value: '8'),
            TDDropdownItemOption(label: '选项9', value: '9'),
            TDDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
            TDDropdownItemOption(label: '禁用选项', value: '11', disabled: true),
            TDDropdownItemOption(label: '禁用选项', value: '12', disabled: true),
          ],
        ),
      ];
    },
  );
}

@Demo(group: 'dropdownMenu')
TDDropdownMenu _buildOverflow(BuildContext context) {
  return TDDropdownMenu(
    isScrollable: true,
    tabBarAlign: MainAxisAlignment.spaceAround,
    direction: TDDropdownMenuDirection.up,
    onMenuOpened: (value) {
      print('打开第$value个菜单');
    },
    onMenuClosed: (value) {
      print('关闭第$value个菜单');
    },
    builder: (context) {
      return [
        TDDropdownItem(
          label: '最大高度限制',
          multiple: true,
          maxHeight: 200,
          tabBarWidth: 200,
          options: [
            TDDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDDropdownItemOption(label: '选项2', value: '2', selected: true),
            TDDropdownItemOption(label: '选项3', value: '3', selected: true),
            TDDropdownItemOption(label: '选项4', value: '4'),
            TDDropdownItemOption(label: '选项5', value: '5'),
            TDDropdownItemOption(label: '选项6', value: '6'),
            TDDropdownItemOption(label: '选项7', value: '7'),
            TDDropdownItemOption(label: '选项8', value: '8'),
            TDDropdownItemOption(label: '选项9', value: '9'),
            TDDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
            TDDropdownItemOption(label: '禁用选项', value: '11', disabled: true),
            TDDropdownItemOption(label: '禁用选项', value: '12', disabled: true),
          ],
          onChange: (value) {
            print('选择：$value');
          },
        ),
        TDDropdownItem(
          maxHeight: 200,
          tabBarWidth: 200,
          tabBarAlign: MainAxisAlignment.start,
          options: [
            TDDropdownItemOption(label: '选项1选项1选项1选项1选项1选项1选项1', value: '1', selected: true),
            TDDropdownItemOption(label: '选项2', value: '2'),
          ],
        ),
        TDDropdownItem(
          maxHeight: 200,
          options: [
            TDDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDDropdownItemOption(label: '选项2', value: '2'),
          ],
        ),
        TDDropdownItem(
          maxHeight: 200,
          options: [
            TDDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDDropdownItemOption(label: '选项2', value: '2'),
          ],
        ),
        TDDropdownItem(
          maxHeight: 200,
          options: [
            TDDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDDropdownItemOption(label: '选项2', value: '2'),
          ],
        ),
      ];
    },
  );
}