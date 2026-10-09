## API

### TEmpty

#### 构造方法

##### TEmpty

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| emptyText | String? | - | 描述文字。 | 否 |
| icon | IconData? | TIcons.info_circle_filled | 默认图标；image 非空时不显示，显式 null 仍回退为 info_circle_filled。 | 否 |
| image | Widget? | - | 自定义图片或插画；优先于 `icon`。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| operation | Widget? | - | 描述下方的操作内容，通常为按钮。 | 否 |


### TEmptyThemeData

空态组件级 ThemeExtension

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| emptyTextColor | Color? | - | 描述文字颜色 未配置时使用 textColorPlaceholder Token。 | 否 |
| emptyTextFont | Font? | - | 描述文字字号 未配置时使用 fontBodyMedium Token。 | 否 |
