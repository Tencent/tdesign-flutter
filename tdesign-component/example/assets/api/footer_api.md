## API
### TFooter
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| links | List<Widget> | const [] | 链接内容；多个链接之间自动绘制分隔线。 |
| logo | Widget? | - | 品牌内容；可与 `text` 组合展示，非空时不展示 `links`。 |
| text | String | '' | 文字 |


### TFooterThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| height | double? | - | 页脚外层高度。 默认值为 null，表示由 logo、链接或文字内容自然决定高度；这与 TDesign 小程序 Footer 的内容驱动布局一致。 |
