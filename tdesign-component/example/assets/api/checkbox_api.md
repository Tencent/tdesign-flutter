## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TCheckbox

#### 声明

```dart
class TCheckbox extends StatelessWidget
```

#### 默认构造方法


```dart
const TCheckbox({
  super.key,
  required this.value,
  this.onChanged,
  this.title,
  this.subTitle,
  this.size = TCheckboxSize.medium,
  this.cardMode = false,
  this.showDivider = true,
  this.contentDirection = TContentDirection.right,
  this.titleMaxLines = 3,
  this.subTitleMaxLines = 5,
  this.customIconBuilder,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| cardMode | bool | false | 是否使用卡片模式。 | 否 |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向。 | 否 |
| customIconBuilder | TCheckboxIconBuilder? | - | 自定义复选框指示器。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| onChanged | ValueChanged&lt;bool?&gt;? | - | 选中态变更回调；为 null 时禁用。 | 否 |
| showDivider | bool | true | 普通模式是否显示底部分割线，默认显示；卡片模式不显示。 | 否 |
| size | TCheckboxSize | TCheckboxSize.medium | 复选框尺寸。 | 否 |
| subTitle | String? | - | 副标题文案。 | 否 |
| subTitleMaxLines | int | 5 | 副标题最大行数，默认 5 行。 | 否 |
| title | String? | - | 主标题文案。 | 否 |
| titleMaxLines | int | 3 | 主标题最大行数，默认 3 行。 | 否 |
| value | bool? | - | 受控选中态；null 表示半选。 | 是 |


### TCheckboxGroup

#### 声明

```dart
class TCheckboxGroup<T> extends StatelessWidget
```

#### 默认构造方法


```dart
const TCheckboxGroup({
  super.key,
  required this.value,
  required this.options,
  this.onChanged,
  this.direction = Axis.vertical,
  this.columns = 1,
  this.cardMode = false,
  this.showDivider = true,
  this.contentDirection = TContentDirection.right,
  this.size = TCheckboxSize.medium,
  this.maxSelected,
  this.onMaxSelected,
  this.itemBuilder,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| cardMode | bool | false | 是否使用卡片模式。 | 否 |
| columns | int | 1 | 每行列数，必须大于 0。 | 否 |
| contentDirection | TContentDirection | TContentDirection.right | 控件与文案排列方向。 | 否 |
| direction | Axis | Axis.vertical | 排列方向。 | 否 |
| itemBuilder | TCheckboxOptionBuilder&lt;T&gt;? | - | 自定义数据项视觉；交互仍由组接管。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxSelected | int? | - | 最多可选数量。 | 否 |
| onChanged | ValueChanged&lt;List&lt;T&gt;&gt;? | - | 选中项列表变更回调；为 null 时整组禁用。 | 否 |
| onMaxSelected | VoidCallback? | - | 超过最多可选数量时触发。 | 否 |
| options | List&lt;TCheckboxOption&lt;T&gt;&gt; | - | 复选框数据项。 | 是 |
| showDivider | bool | true | 普通模式是否显示项间分割线，默认显示；卡片模式不显示。 | 否 |
| size | TCheckboxSize | TCheckboxSize.medium | 复选框尺寸。 | 否 |
| value | List&lt;T&gt; | - | 受控选中项列表。 | 是 |


### TContentDirection
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 控件位于文案右侧。 |
| right | 控件位于文案左侧。 |


### TCheckboxSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸。 |
| medium | 中尺寸。 |
| large | 大尺寸。 |


### TCheckboxIconBuilder
#### 类型定义

```dart
typedef TCheckboxIconBuilder = Widget Function(BuildContext context, bool? value, bool disabled);
```


### TCheckboxOptionBuilder
#### 类型定义

```dart
typedef TCheckboxOptionBuilder<T> = Widget Function(BuildContext context, TCheckboxOption<T> option, bool selected, bool disabled);
```
