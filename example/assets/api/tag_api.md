## API

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | text | 标签内容 |
| textColor | Color? | - | 文字颜色, 优先级高于style的textColor |
| backgroundColor | Color? | - | 背景颜色, 优先级高于style的backgroundColor |
| font | Font? | - | 字体尺寸, 优先级高于style的font |
| fontWeight | FontWeight? | - | 字体粗细, 优先级高于style的fontWeight |
| style | TDTagStyle? | - | 标签样式 |
| size | TDTagSize | TDTagSize.middle | 标签大小 |
| padding | EdgeInsets? | - | 自定义模式下的间距 |
| forceVerticalCenter | bool | true | 是否强制中文文字居中 |
| needCloseIcon | bool | false | 关闭图标 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| overflow | TextOverflow? | - | 文字溢出处理 |
| key | Key | - |  |
