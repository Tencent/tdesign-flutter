## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TFooter

#### 声明

```dart
class TFooter extends StatelessWidget
```

#### 默认构造方法


```dart
const TFooter({Key? key, this.logo, this.text = '', this.links = const []})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| links | List&lt;Widget&gt; | const [] | 链接内容；多个链接之间自动绘制分隔线。 | 否 |
| logo | Widget? | - | 品牌内容；可与 `text` 组合展示，非空时不展示 `links`。 | 否 |
| text | String | '' | 文字 | 否 |
