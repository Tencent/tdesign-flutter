import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDropdownMenuPage extends StatelessWidget {
  const TDropdownMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '菜单呈现数个并列的选项类目，用于整个页面的内容筛选，由菜单面板和菜单选项组成。',
      exampleCodeGroup: 'dropdownMenu',
      children: const [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '单选下拉菜单', builder: _buildDownSimple),
          ExampleItem(desc: '分栏下拉菜单', builder: _buildDownChunk),
          ExampleItem(desc: '向上展开', builder: _buildUp),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '禁用状态', builder: _buildDisabled),
          ExampleItem(desc: '分组菜单', builder: _buildGroup),
        ]),
      ],
      test: const [
        ExampleItem(desc: '自动弹出方向', builder: _buildHidden),
        ExampleItem(desc: '最大高度限制', builder: _buildHeight),
        ExampleItem(desc: '可横向滚动菜单', builder: _buildOverflow),
        ExampleItem(desc: '可横向滚动菜单（自定义禁用、选中颜色）', builder: _buildCustomOverflow),
        ExampleItem(desc: '自定义箭头颜色', builder: _buildArrowColor),
      ],
    );
  }
}

@Demo(group: 'dropdownMenu')
TDropdownMenu _buildDownSimple(BuildContext context) {
  return TDropdownMenu(
    direction: TDropdownMenuDirection.down,
    onMenuOpened: (value) {
      print('打开第$value个菜单');
    },
    onMenuClosed: (value) {
      print('关闭第$value个菜单');
    },
    items: [
      TDropdownItem(
        options: [
          TDropdownItemOption(label: '全部产品', value: 'all', selected: true),
          TDropdownItemOption(label: '最新产品', value: 'new'),
          TDropdownItemOption(label: '最火产品', value: 'hot'),
        ],
        onChange: (value) {
          print('选择：$value');
        },
      ),
      TDropdownItem(
        options: [
          TDropdownItemOption(label: '默认排序', value: 'default', selected: true),
          TDropdownItemOption(label: '价格从高到低', value: 'price'),
        ],
      ),
    ],
  );
}

@Demo(group: 'dropdownMenu')
TDropdownMenu _buildDownChunk(BuildContext context) {
  return TDropdownMenu(
    direction: TDropdownMenuDirection.down,
    items: [
      TDropdownItem(
        label: '单列多选',
        multiple: true,
        options: [
          TDropdownItemOption(label: '选项1', value: '1', selected: true),
          TDropdownItemOption(label: '选项2', value: '2'),
          TDropdownItemOption(label: '选项3', value: '3'),
          TDropdownItemOption(label: '选项4', value: '4'),
          TDropdownItemOption(label: '选项5', value: '5'),
          TDropdownItemOption(label: '选项6', value: '6'),
          TDropdownItemOption(label: '选项7', value: '7'),
          TDropdownItemOption(label: '选项8', value: '8'),
          TDropdownItemOption(label: '禁用选项', value: '9', disabled: true),
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
      TDropdownItem(
        // label: '双列单选',
        multiple: false,
        optionsColumns: 2,
        maxHeight: 300,
        options: [
          TDropdownItemOption(label: '双列单选1', value: '1'),
          TDropdownItemOption(label: '双列单选2', value: '2', selected: true),
          TDropdownItemOption(label: '双列单选3', value: '3'),
          TDropdownItemOption(label: '双列单选4', value: '4'),
          TDropdownItemOption(label: '双列单选5', value: '5'),
          TDropdownItemOption(label: '双列单选6', value: '6'),
          TDropdownItemOption(label: '双列单选7', value: '7'),
          TDropdownItemOption(label: '双列单选8', value: '8'),
          TDropdownItemOption(label: '禁用选项', value: '9', disabled: true),
          TDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
        ],
      ),
      TDropdownItem(
        label: '双列多选',
        multiple: true,
        optionsColumns: 2,
        options: [
          TDropdownItemOption(label: '选项1', value: '1', selected: true),
          TDropdownItemOption(label: '选项2', value: '2', selected: true),
          TDropdownItemOption(label: '选项3', value: '3'),
          TDropdownItemOption(label: '选项4', value: '4'),
          TDropdownItemOption(label: '选项5', value: '5'),
          TDropdownItemOption(label: '选项6', value: '6'),
          TDropdownItemOption(label: '选项7', value: '7'),
          TDropdownItemOption(label: '选项8', value: '8'),
          TDropdownItemOption(label: '禁用选项', value: '9', disabled: true),
          TDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
        ],
      ),
      TDropdownItem(
        label: '三列多选',
        multiple: true,
        optionsColumns: 3,
        options: [
          TDropdownItemOption(label: '选项1', value: '1', selected: true),
          TDropdownItemOption(label: '选项2', value: '2', selected: true),
          TDropdownItemOption(label: '选项3', value: '3', selected: true),
          TDropdownItemOption(label: '选项4', value: '4'),
          TDropdownItemOption(label: '选项5', value: '5'),
          TDropdownItemOption(label: '选项6', value: '6'),
          TDropdownItemOption(label: '选项7', value: '7'),
          TDropdownItemOption(label: '选项8', value: '8'),
          TDropdownItemOption(label: '选项9', value: '9'),
          TDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
          TDropdownItemOption(label: '禁用选项', value: '11', disabled: true),
          TDropdownItemOption(label: '禁用选项', value: '12', disabled: true),
        ],
      ),
    ],
  );
}

@Demo(group: 'dropdownMenu')
TDropdownMenu _buildUp(BuildContext context) {
  return TDropdownMenu(
    direction: TDropdownMenuDirection.up,
    onMenuOpened: (value) {
      print('打开第$value个菜单');
    },
    onMenuClosed: (value) {
      print('关闭第$value个菜单');
    },
    builder: (context) {
      return [
        TDropdownItem(
          options: [
            TDropdownItemOption(label: '全部产品', value: 'all', selected: true),
            TDropdownItemOption(label: '最新产品', value: 'new'),
            TDropdownItemOption(label: '最火产品', value: 'hot'),
          ],
          onChange: (value) {
            print('选择：$value');
          },
        ),
        TDropdownItem(
          options: [
            TDropdownItemOption(
                label: '默认排序', value: 'default', selected: true),
            TDropdownItemOption(label: '价格从高到低', value: 'price'),
          ],
        ),
      ];
    },
  );
}

@Demo(group: 'dropdownMenu')
TDropdownMenu _buildDisabled(BuildContext context) {
  return TDropdownMenu(
    direction: TDropdownMenuDirection.down,
    builder: (context) {
      return [
        const TDropdownItem(
          disabled: true,
          label: '禁用菜单',
        ),
        const TDropdownItem(
          disabled: true,
          label: '禁用菜单',
        ),
      ];
    },
  );
}

@Demo(group: 'dropdownMenu')
TDropdownMenu _buildGroup(BuildContext context) {
  return TDropdownMenu(
    direction: TDropdownMenuDirection.up,
    builder: (context) {
      return [
        TDropdownItem(
          label: '分组菜单',
          multiple: true,
          optionsColumns: 3,
          options: [
            TDropdownItemOption(
                label: '选项1', value: '1', selected: true, group: '类型'),
            TDropdownItemOption(label: '选项2', value: '2', group: '类型'),
            TDropdownItemOption(label: '选项3', value: '3', group: '类型'),
            TDropdownItemOption(label: '选项4', value: '4', group: '类型'),
            TDropdownItemOption(label: '选项5', value: '5', group: '角色'),
            TDropdownItemOption(label: '选项6', value: '6', group: '角色'),
            TDropdownItemOption(label: '选项7', value: '7', group: '角色'),
            TDropdownItemOption(label: '选项8', value: '8', group: '角色'),
            TDropdownItemOption(label: '选项9', value: '9', group: '能力'),
            TDropdownItemOption(label: '选项10', value: '10', group: '能力'),
            TDropdownItemOption(label: '选项11', value: '11', group: '能力'),
            TDropdownItemOption(label: '选项12', value: '12', group: '能力'),
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
TDropdownMenu _buildHidden(BuildContext context) {
  return TDropdownMenu(
    direction: TDropdownMenuDirection.auto,
    arrowIcon: TIcons.caret_up_small,
    builder: (context) {
      return [
        TDropdownItem(
          label: '分组菜单',
          multiple: true,
          optionsColumns: 3,
          options: [
            TDropdownItemOption(
                label: '选项1', value: '1', selected: true, group: '类型'),
            TDropdownItemOption(label: '选项2', value: '2', group: '类型'),
            TDropdownItemOption(label: '选项3', value: '3', group: '类型'),
            TDropdownItemOption(label: '选项4', value: '4', group: '类型'),
            TDropdownItemOption(label: '选项5', value: '5', group: '角色'),
            TDropdownItemOption(label: '选项6', value: '6', group: '角色'),
            TDropdownItemOption(label: '选项7', value: '7', group: '角色'),
            TDropdownItemOption(label: '选项8', value: '8', group: '角色'),
            TDropdownItemOption(label: '选项9', value: '9', group: '能力'),
            TDropdownItemOption(label: '选项10', value: '10', group: '能力'),
            TDropdownItemOption(label: '选项11', value: '11', group: '能力'),
            TDropdownItemOption(label: '选项12', value: '12', group: '能力'),
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
TDropdownMenu _buildHeight(BuildContext context) {
  return TDropdownMenu(
    direction: TDropdownMenuDirection.up,
    onMenuOpened: (value) {
      print('打开第$value个菜单');
    },
    onMenuClosed: (value) {
      print('关闭第$value个菜单');
    },
    builder: (context) {
      return [
        TDropdownItem(
          label: '最大高度限制',
          multiple: true,
          maxHeight: 200,
          options: [
            TDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDropdownItemOption(label: '选项2', value: '2', selected: true),
            TDropdownItemOption(label: '选项3', value: '3', selected: true),
            TDropdownItemOption(label: '选项4', value: '4'),
            TDropdownItemOption(label: '选项5', value: '5'),
            TDropdownItemOption(label: '选项6', value: '6'),
            TDropdownItemOption(label: '选项7', value: '7'),
            TDropdownItemOption(label: '选项8', value: '8'),
            TDropdownItemOption(label: '选项9', value: '9'),
            TDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
            TDropdownItemOption(label: '禁用选项', value: '11', disabled: true),
            TDropdownItemOption(label: '禁用选项', value: '12', disabled: true),
          ],
          onChange: (value) {
            print('选择：$value');
          },
        ),
        TDropdownItem(
          maxHeight: 200,
          options: [
            TDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDropdownItemOption(label: '选项2', value: '2'),
            TDropdownItemOption(label: '选项3', value: '3'),
            TDropdownItemOption(label: '选项4', value: '4'),
            TDropdownItemOption(label: '选项5', value: '5'),
            TDropdownItemOption(label: '选项6', value: '6'),
            TDropdownItemOption(label: '选项7', value: '7'),
            TDropdownItemOption(label: '选项8', value: '8'),
            TDropdownItemOption(label: '选项9', value: '9'),
            TDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
            TDropdownItemOption(label: '禁用选项', value: '11', disabled: true),
            TDropdownItemOption(label: '禁用选项', value: '12', disabled: true),
          ],
        ),
      ];
    },
  );
}

@Demo(group: 'dropdownMenu')
TDropdownMenu _buildOverflow(BuildContext context) {
  return TDropdownMenu(
    isScrollable: true,
    tabBarAlign: MainAxisAlignment.spaceAround,
    direction: TDropdownMenuDirection.up,
    onMenuOpened: (value) {
      print('打开第$value个菜单');
    },
    onMenuClosed: (value) {
      print('关闭第$value个菜单');
    },
    builder: (context) {
      return [
        TDropdownItem(
          label: '最大高度限制',
          multiple: true,
          maxHeight: 200,
          tabBarWidth: 150,
          options: [
            TDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDropdownItemOption(label: '选项2', value: '2', selected: true),
            TDropdownItemOption(label: '选项3', value: '3', selected: true),
            TDropdownItemOption(label: '选项4', value: '4'),
            TDropdownItemOption(label: '选项5', value: '5'),
            TDropdownItemOption(label: '选项6', value: '6'),
            TDropdownItemOption(label: '选项7', value: '7'),
            TDropdownItemOption(label: '选项8', value: '8'),
            TDropdownItemOption(label: '选项9', value: '9'),
            TDropdownItemOption(label: '禁用选项', value: '10', disabled: true),
            TDropdownItemOption(label: '禁用选项', value: '11', disabled: true),
            TDropdownItemOption(label: '禁用选项', value: '12', disabled: true),
          ],
          onChange: (value) {
            print('选择：$value');
          },
        ),
        TDropdownItem(
          maxHeight: 200,
          tabBarWidth: 200,
          tabBarAlign: MainAxisAlignment.start,
          options: [
            TDropdownItemOption(
                label: '选项1选项1选项1选项1选项1选项1选项1', value: '1', selected: true),
            TDropdownItemOption(label: '选项2', value: '2'),
          ],
        ),
        TDropdownItem(
          maxHeight: 200,
          options: [
            TDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDropdownItemOption(label: '选项2', value: '2'),
          ],
        ),
        TDropdownItem(
          maxHeight: 200,
          options: [
            TDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDropdownItemOption(label: '选项2', value: '2'),
          ],
        ),
        TDropdownItem(
          maxHeight: 200,
          options: [
            TDropdownItemOption(label: '选项1', value: '1', selected: true),
            TDropdownItemOption(label: '选项2', value: '2'),
          ],
        ),
      ];
    },
  );
}

@Demo(group: 'dropdownMenu')
TDropdownMenu _buildCustomOverflow(BuildContext context) {
  return TDropdownMenu(
    direction: TDropdownMenuDirection.up,
    onMenuOpened: (value) {
      print('打开第$value个菜单');
    },
    onMenuClosed: (value) {
      print('关闭第$value个菜单');
    },
    items: [
      TDropdownItem(
        options: [
          TDropdownItemOption(
              label: '全部产品',
              value: 'all',
              selected: true,
              selectedColor: Colors.red),
          TDropdownItemOption(
              label: '最新产品', value: 'new', selectedColor: Colors.blue),
          TDropdownItemOption(
              label: '最火产品', value: 'hot', selectedColor: Colors.green),
        ],
        onChange: (value) {
          print('选择：$value');
        },
      ),
      TDropdownItem(
        multiple: true,
        options: [
          TDropdownItemOption(
              label: '默认排序',
              value: 'default',
              selected: true,
              selectedColor: Colors.red),
          TDropdownItemOption(
              label: '价格从高到低', value: 'price', selectedColor: Colors.green),
        ],
      ),
    ],
  );
}

@Demo(group: 'dropdownMenu')
TDropdownMenu _buildArrowColor(BuildContext context) {
  return TDropdownMenu(
    direction: TDropdownMenuDirection.up,
    arrowColor: Colors.red,
    items: [
      TDropdownItem(
        label: '菜单级箭头颜色(红)',
        options: [
          TDropdownItemOption(label: '选项1', value: '1'),
        ],
      ),
      TDropdownItem(
        label: 'Item级箭头颜色(蓝)',
        arrowColor: Colors.blue,
        options: [
          TDropdownItemOption(label: '选项1', value: '1'),
        ],
      ),
    ],
  );
}
