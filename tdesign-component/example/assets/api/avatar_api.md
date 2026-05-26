## API
### TAvatar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| avatarDisplayBorder | double | 2 | 带操作展示的头像描边宽度 |
| avatarDisplayList | List<String>? | - | 带操作展示的头像列表 |
| avatarDisplayListAsset | List<String>? | - | 带操作展示的头像列表（本地资源） |
| avatarDisplayWidget | Widget? | - | 带操作头像自定义操作Widget |
| avatarSize | double? | - | 自定义头像大小 |
| avatarUrl | String? | - | 头像地址 |
| backgroundColor | Color? | - | 自定义文案时背景色 |
| defaultUrl | String | '' | 默认图片（本地） |
| displayText | String? | - | 纯展示类型末尾文字 |
| fit | BoxFit? | - | 自定义图片对齐方式 |
| icon | IconData? | - | 自定义图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onTap | Function()? | - | 操作点击事件 |
| radius | double? | - | 自定义圆角 |
| shape | TAvatarShape | TAvatarShape.circle | 头像形状 |
| size | TAvatarSize | TAvatarSize.medium | 头像尺寸 |
| text | String? | - | 自定义文字 |
| type | TAvatarType | TAvatarType.normal | 头像类型 |


### TAvatarSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | - |
| medium | - |
| small | - |


### TAvatarType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| icon | - |
| normal | - |
| customText | - |
| display | - |
| operation | - |


### TAvatarShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | - |
| square | - |
