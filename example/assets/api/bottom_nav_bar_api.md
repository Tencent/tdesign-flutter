## API

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| basicType | TDBottomNavBarBasicType | basicType |  |
| key | Key | - |  |
| componentType | TDBottomNavBarComponentType? | TDBottomNavBarComponentType.label |  |
| outlineType | TDBottomNavBarOutlineType? | TDBottomNavBarOutlineType.filled |  |
| navigationTabs | List<TDBottomNavBarTabConfig> | - | tabs配置 |
| barHeight | double? | _kDefaultNavBarHeight | tab高度 |
| useVerticalDivider | bool? | - | 是否使用竖线分隔(如果选项样式为label则强制为false) |
| dividerHeight | double? | - | 分割线高度（可选） |
| dividerThickness | double? | - | 分割线厚度（可选） |
| dividerColor | Color? | - | 分割线颜色（可选） |
| showTopBorder | bool? | true | 是否展示bar上边线（设置为true 但是topBorder样式未设置，则使用默认值） |
| topBorder | BorderSide? | - | 上边线样式 |
