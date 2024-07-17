## API
### TDTreeSelect
#### 简介
树形选择器
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| options | List<TDSelectOption> | [] | 展示的选项列表 |
| defaultValue | List<dynamic> | [] | 初始值，对应options中的value值 |
| onChange | TDTreeSelectChangeEvent? | - | 选中值发生变化 |
| height | double | 336 | 高度 |
| multiple | bool | false | 支持多选 |
| style | TDTreeSelectStyle | TDTreeSelectStyle.normal | 一级菜单样式 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDTreeSelectStyle.normal  | 普通一级菜单样式 |
| TDTreeSelectStyle.outline  | 一级菜单outline样式 |

#### 相关类

typedef TDTreeSelectChangeEvent = void Function(List<dynamic>, int level);

class TDSelectOption {
  TDSelectOption(
      {required this.label, required this.value, this.children = const []});

  final String label;
  final int value;
  List<TDSelectOption> children;
}
