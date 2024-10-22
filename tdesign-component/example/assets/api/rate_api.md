## API
### TDRate
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| allowHalf | bool? | false | 是否允许半选 |
| color | List<Color>? | - | 评分图标的颜色，示例：[选中颜色] / [选中颜色，未选中颜色]，默认：[TDTheme.of(context).warningColor5, TDTheme.of(context).grayColor4] |
| count | int? | 5 | 评分的数量 |
| disabled | bool? | false | 是否禁用评分 |
| gap | double? | - | 评分图标的间距，默认：TDTheme.of(context).spacer8 |
| icon | List<IconData>? | - | 自定义评分图标，[选中和未选中图标] / [选中图标，未选中图标]，默认：[TDIcons.star_filled] |
| placement | PlacementEnum? | PlacementEnum.top | 选择评分弹框的位置，值为[PlacementEnum.none]表示不显示评分弹框。 |
| showText | bool? | false | 是否显示对应的辅助文字 |
| size | double? | 24.0 | 评分图标的大小 |
| texts | List<String>? | const ['极差', '失望', '一般', '满意', '惊喜'] | 评分等级对应的辅助文字， |
| textWidth | double? | 48.0 | 评分等级对应的辅助文字宽度 |
| builderText | Widget Function(BuildContext context, double value)? | - | 评分等级对应的辅助文字自定义构建，优先级高于[texts] |
| value | double? | 0 | 选择评分的值 |
| onChange | void Function(double value)? | - | 评分数改变时触发 |
| direction | Axis? | Axis.horizontal | 评分图标与辅助文字的布局方向 |
| mainAxisAlignment | MainAxisAlignment? | MainAxisAlignment.start | 评分图标与辅助文字的主轴对齐方式 |
| crossAxisAlignment | CrossAxisAlignment? | CrossAxisAlignment.center | 评分图标与辅助文字的交叉轴对齐方式 |
| mainAxisSize | MainAxisSize? | MainAxisSize.min | 评分图标与辅助文字主轴方向上如何占用空间 |
| iconTextGap | double? | - | 评分图标与辅助文字的间距，默认：[TDTheme.of(context).spacer16] |
