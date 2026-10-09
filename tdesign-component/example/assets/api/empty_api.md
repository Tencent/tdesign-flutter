## API

### TEmpty

用于空数据、网络异常和操作引导的空状态组件。

#### 主题配置

组件主题通过 `TEmptyThemeData` 配置，放入 Flutter `ThemeData.extensions`
后作用于对应子树。可配置字段和未设置时的回退见本页的
`TEmptyThemeData` 配置项。

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
