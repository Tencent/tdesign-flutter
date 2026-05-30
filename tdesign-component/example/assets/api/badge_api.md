## API
### TBadge
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| type | TBadgeType | - | 红点样式 |
| border | TBadgeBorder | TBadgeBorder.large | 红点圆角大小 |
| color | Color? | - | 红点颜色 |
| count | String? | - | 红点数量 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxCount | String? | '99' | 最大红点数量 |
| message | String? | - | 消息内容 |
| padding | EdgeInsetsGeometry? | - | 角标自定义padding |
| showZero | bool | true | 值为0是否显示 |
| size | TBadgeSize | TBadgeSize.small | 红点尺寸 |
| textColor | Color? | - | 文字颜色 |
| widthLarge | double | 32 | 角标大三角形宽 |
| widthSmall | double | 12 | 角标小三角形宽 |


### TBadgeType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| redPoint | 红点样式 |
| message | 消息样式 |
| bubble | 气泡样式 |
| square | 方形样式 |
| subscript | 角标样式 |


### TBadgeBorder
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 大圆角 8px |
| small | 小圆角 2px |


### TBadgeSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | 宽 20px |
| small | 宽 16px |
