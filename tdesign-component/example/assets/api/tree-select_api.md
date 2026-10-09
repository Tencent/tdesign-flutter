## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TTreeSelect

#### 声明

```dart
class TTreeSelect extends StatefulWidget
```

#### 默认构造方法


```dart
const TTreeSelect({
  super.key,
  required this.options,
  required this.value,
  this.onChanged,
  this.multiple = false,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| multiple | bool | false | 是否允许选择多个叶子节点。 为 false 时，`value` 最多包含一条路径。 | 否 |
| onChanged | ValueChanged&lt;List&lt;List&lt;Object?&gt;&gt;&gt;? | - | 选中路径变化回调；为 null 时禁用。 | 否 |
| options | List&lt;TTreeSelectOption&gt; | - | 根选项。 | 是 |
| value | List&lt;List&lt;Object?&gt;&gt; | - | 受控选中路径；每一项应为从根到叶子的完整 `TTreeSelectOption.value` 路径。 单选模式最多传入一条，多选模式可传入多条且不得重复。 | 是 |


### TTreeSelectOption

#### 声明

```dart
class TTreeSelectOption
```

#### 默认构造方法


```dart
const TTreeSelectOption({
  required this.label,
  required this.value,
  this.children = const [],
  this.disabled = false,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| children | List&lt;TTreeSelectOption&gt; | const [] | 子选项。 | 否 |
| disabled | bool | false | 是否禁用。 | 否 |
| label | String | - | 展示文案。 | 是 |
| value | Object? | - | 业务值；同一层级的选项必须保持唯一。 | 是 |
