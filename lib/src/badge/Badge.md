# Badge

Badge - 徽标组件

能力及接口参考：[TDesign Mobile Badge](http://tdesign.woa.com/vue-mobile/components/)

### 使用示例

```dart
TDBadge(
  dot: true,
  child: Icon(TDIcons.refresh),
)
TDBadge(
  content: 'NEW',
  shape: BadgeShape.ribbon,
  child: ListTile(title: Text('ListTile')),
)
```

### API

**Properties**

(带下划线表示和TDTheme主题相关)

| 属性      | 类型         | 默认值                                   | 必传 | 说明                                                         |
| --------- | ------------ | ---------------------------------------- | ---- | ------------------------------------------------------------ |
| child     | Widget       |                                          | N    | 这个Badge所依附的widget。如果为`null`，则badge独立存在。     |
| shape     | TDBadgeShape | circle                                   | N    | Badge的形状。enum: `circle`, `rounded`, `ribbon`             |
| sizecolor | TDBadgeSize  | medium                                   | N    | Badge的大小。enum: `medium`, `small`。                       |
| content   | String?      |                                          | N    | Badge上展示的自定义文字，优先级高于`count`。                 |
| color     | Color?       | <u>errorColor</u> (0xFFE34D59)           | N    | Bagde主体的背景色。                                          |
| textColor | Color?       | <u>textAntiPrimaryColor</u> (0xFFFFFFFF) | N    | Badge上的文字颜色。                                          |
| count     | int?         |                                          | N    | Badge上展示的数字，优先级低于`content`。若`content`, `count`都为null，则Badge展示为小红点 |
| dot       | Bool         | False                                    | N    | Badge是否显示为小红点。                                      |
| maxCount  | int          | 99                                       | N    | Badge上展示的数字的最大值。超过该值则数字不再增加，后带`+`，例如`99+`。 |
| offset    | Offset       | Offset(0, 0)                             | N    | Badge在`child`上的位置偏移。默认的位置是`child`的右上角。    |
| showZero  | bool         | false                                    | N    | 在显示`count`的情况下，当`count = 0`时是否还要显示Badge。    |



### Design config

(带下划线表示和TDTheme主题相关)

- Medium

  | 属性                | 数值                           |
  | ------------------- | ------------------------------ |
  | badge长宽           | 根据文字宽度和大小动态决定     |
  | 文字左右padding     | 4                              |
  | 文字上下padding     | 1.8                            |
  | dot badge直径       | 10                             |
  | 文字字体大小        | <u>fontSizeXS</u> (10)         |
  | 圆角型badge圆角大小 | 4                              |
  | 缎带型badge宽度     | 近角侧距离: 12, 远角侧距离: 32 |

- Small

  | 属性                | 数值                           |
  | ------------------- | ------------------------------ |
  | badge长宽           | 根据文字宽度和大小动态决定     |
  | 文字左右padding     | 3                              |
  | 文字上下padding     | 1.2                            |
  | dot badge直径       | 8                              |
  | 文字字体大小        | <u>fontSizeXS - 2</u> (8)      |
  | 圆角型badge圆角大小 | 3                              |
  | 缎带型badge宽度     | 近角侧距离: 10, 远角侧距离: 27 |