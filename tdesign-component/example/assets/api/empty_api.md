## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TEmpty

#### 声明

```dart
class TEmpty extends StatelessWidget
```

#### 默认构造方法


```dart
const TEmpty({
  this.icon = TIcons.info_circle_filled,
  this.image,
  this.emptyText,
  this.operation,
  Key? key,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| emptyText | String? | - | 描述文字。 | 否 |
| icon | IconData? | TIcons.info_circle_filled | 默认图标；`image` 非空时不显示。 | 否 |
| image | Widget? | - | 自定义图片或插画；优先于 `icon`。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| operation | Widget? | - | 描述下方的操作内容，通常为按钮。 | 否 |
