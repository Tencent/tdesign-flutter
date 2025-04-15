---
title: DropdownMenu 下拉菜单
description: 菜单呈现数个并列的选项类目，用于整个页面的内容筛选，由菜单面板和菜单选项组成。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_dropdown_menu_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_dropdown_menu_page.dart)

### 1 组件类型

单选下拉菜单

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

分栏下拉菜单

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

向上展开

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                
### 1 组件状态

禁用状态

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

分组菜单

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
}</pre>

</td-code-block>
                


## API
### TDDropdownItem
#### 简介
下拉菜单内容
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| disabled | bool? | false | 是否禁用 |
| label | String? | - | 标题 |
| arrowIcon | IconData? | - | 自定义箭头图标 |
| multiple | bool? | false | 是否多选 |
| options | List<TDDropdownItemOption>? | const [] | 选项数据 |
| builder | TDDropdownItemContentBuilder? | - | 完全自定义展示内容 |
| optionsColumns | int? | 1 | 选项分栏（1-3） |
| onChange | ValueChanged<T?>? | - | 值改变时触发 |
| onConfirm | ValueChanged<T?>? | - | 点击确认时触发 |
| onReset | VoidCallback? | - | 点击重置时触发 |
| minHeight | double? | - | 内容最小高度 |
| maxHeight | double? | - | 内容最大高度 |
| tabBarWidth | double? | - | 该item在menu上的宽度，仅在[TDDropdownMenu.isScrollable]为true时有效 |
| tabBarAlign | MainAxisAlignment? | - | [label]和[arrowIcon]/[TDDropdownMenu.arrowIcon]的对齐方式 |
| tabBarFlex | int? | 1 | 该item在menu上的宽度占比，仅在[TDDropdownMenu.isScrollable]为false时有效 |

```
```
 ### TDDropdownItemOption
#### 简介
选项数据
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| value | String | - | 选项值 |
| label | String | - | 选项标题 |
| disabled | bool? | false | 是否禁用 |
| group | String? | - | 分组，相同的为一组 |
| selected | bool? | false | 是否选中 |

```
```
 ### TDDropdownMenu
#### 简介
下拉菜单
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| builder | TDDropdownItemBuilder? | - | 下拉菜单构建器，优先级高于[items] |
| items | List<TDDropdownItem>? | - | 下拉菜单 |
| closeOnClickOverlay | bool? | true | 是否在点击遮罩层后关闭菜单 |
| direction | TDDropdownMenuDirection? | TDDropdownMenuDirection.auto | 菜单展开方向（down、up、auto） |
| duration | double? | 200.0 | 动画时长，毫秒 |
| showOverlay | bool? | true | 是否显示遮罩层 |
| isScrollable | bool? | false | 是否开启滚动列表 |
| arrowIcon | IconData? | - | 自定义箭头图标 |
| labelBuilder | LabelBuilder? | - | 自定义标签内容 |
| onMenuOpened | ValueChanged<int>? | - | 展开菜单事件 |
| onMenuClosed | ValueChanged<int>? | - | 关闭菜单事件 |
| width | double? | - | menu的宽度 |
| height | double? | 48 | menu的高度 |
| tabBarAlign | MainAxisAlignment? | MainAxisAlignment.center | [TDDropdownItem.label]和[arrowIcon]/[TDDropdownItem.arrowIcon]的对齐方式 |
| decoration | Decoration? | - | 下拉菜单的装饰器 |


  