## API

### TFooter

页面底部的版权、链接和品牌信息区域。

#### 构造方法

##### TFooter

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| links | List&lt;Widget&gt; | const [] | 链接内容；仅在 logo 为空时展示，并与 text 组合。多个链接之间自动绘制分隔线。 | 否 |
| logo | Widget? | - | 品牌内容；可与 `text` 组合展示，非空时不展示 `links`。 | 否 |
| text | String | '' | 版权或说明文字；可与 links 或 logo 组合展示。 | 否 |


### TFooterThemeData

页脚组件级 ThemeExtension。

未配置 `height` 时，页脚按内容自然撑开；配置后才会约束外层高度。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| height | double? | - | 页脚外层高度。 默认值为 null，表示由 logo、链接或文字内容自然决定高度。 | 否 |
