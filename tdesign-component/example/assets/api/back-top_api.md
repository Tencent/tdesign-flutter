## API
### TBackTop
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| controller | ScrollController? | - | 页面滚动的控制器 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 点击回调；`null` 表示禁用（A 类） |
| shape | TBackTopShape? | - | 形状（circle / halfCircle）；未传时取 Theme `shape` |
| showText | bool | false | 是否展示文案（i18n 走 `context.resource`） |
| tooltip | String? | - | 读屏 / `Tooltip` 提示；未传时可回退资源文案 |
| visibilityOffset | double? | - | 绑定 `controller` 时，偏移 ≥ 阈值才显示；未传时取 Theme `defaultVisibilityOffset`，Theme 也未配时始终可见 |
