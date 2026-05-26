## API
### TFooter
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| type | TFooterType | - | 样式 |
| height | double? | - | 自定义图片高 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| links | List<TLink> | const [] | 链接 |
| logo | String? | - | 品牌图片 |
| text | String | '' | 文字 |
| width | double? | - | 自定义图片宽 |


### TFooterType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| text | 文字样式 |
| link | 链接样式 |
| brand | 品牌样式 |
