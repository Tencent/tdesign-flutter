## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TLink

#### 声明

```dart
class TLink extends StatelessWidget
```

#### 默认构造方法


```dart
const TLink({
  super.key,
  this.child,
  this.prefixIcon,
  this.suffixIcon,
  this.underline,
  this.colorPreset,
  this.size,
  this.onPressed,
  this.semanticLabel,
  this.tooltip,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| child | Widget? | - | 链接内容，通常为 `Text`。 | 否 |
| colorPreset | TLinkColorPreset? | - | 内置配色预设；未设置时默认为 `TLinkColorPreset.defaultTheme`。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onPressed | VoidCallback? | - | 点击回调；为 null 时链接为禁用态。 | 否 |
| prefixIcon | Widget? | - | 前置图标；为 null 时不占位。 | 否 |
| semanticLabel | String? | - | 无障碍语义标签。 | 否 |
| size | TLinkSize? | - | 链接尺寸；未设置时默认为 `TLinkSize.medium`。 | 否 |
| suffixIcon | Widget? | - | 后置图标；为 null 时不占位。 | 否 |
| tooltip | String? | - | 鼠标悬浮提示。 | 否 |
| underline | bool? | - | 是否显示下划线；未设置时为 false。 | 否 |


### TLinkColorPreset
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| primary | 品牌主色链接。 |
| defaultTheme | 默认文本色链接。 |
| danger | 危险操作链接。 |
| warning | 警告提示链接。 |
| success | 成功状态链接。 |
