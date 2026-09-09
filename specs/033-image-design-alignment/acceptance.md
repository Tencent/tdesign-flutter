# 验收记录

- 基线：Flutter PR #1087 head `b7cc527512ba`；Figma `28600:38299`；小程序 `cc2384cc5`。
- Chrome 实看 Figma：首行实例宽度 72/89/134、高 72、横向间距 24；第二行三张 72 × 72、总宽 264；标签与图片间距 16。公开页面只有组件类型与组件状态两组。
- 小程序源码比对：默认 `mode=scaleToFill`、`shape=square`；空 `src` 进入失败。公开 Demo 的两个加载实例在 `pageLifetimes.show` 中直接覆写内部 `onLoaded/onLoadError` 并设置 `isLoading=true`，不是公开 API。
- Flutter 3.32.0：组件测试 12 项、Demo 测试 2 项、工具清单测试 13 项通过；组件生产代码覆盖率 `96/96 = 100%`；组件库和 Example 严格静态分析均无问题。
- Flutter 3.47.0：clean 后重新获取依赖；组件测试 12 项、Demo 测试 2 项通过；组件库和 Example 严格静态分析均无问题。
- 独立分支编译发现并修复 Footer、Empty Demo 两处遗留 `TImageVariant.fitWidth` 调用，统一迁移为 `BoxFit.fitWidth`。
- Linux Flutter 3.32.0：明暗 Demo 与组件状态 Golden 均先生成、人工检查，再以无更新模式复验，各 2 项通过；中文无缺字方框，状态行左对齐，TDesign 默认图标正确。仓库文件与容器输出 SHA-256 一致。
- 生成物：示例代码与 API 文档已重新生成，示例代码 `--check` 通过。
- Chrome Flutter Web：实际进入 `#image?showAction=1`，逐一点击六个类型和四个状态实例；页面无状态跳变、无导航、无点击错误，符合小程序公开 Demo 的纯展示交互。Widget 测试进一步模拟加载、失败、成功各点击一次，`onTap` 恰好触发 3 次；未传回调时无手势节点。

## 小程序 API / Flutter API 对照

| 小程序能力 | Flutter 表达 | 结论 |
| --- | --- | --- |
| `mode` | `BoxFit fit` + `AlignmentGeometry alignment` + `ImageRepeat repeat` | 等价组合，不保留重复枚举 |
| `shape` | `TImageShape shape` | 一致，`round` 使用 Flutter 命名 `roundedSquare` |
| `src` | `String? src` / `File? imageFile` | Flutter 扩展 asset、本地文件；二者互斥 |
| `loading` / loading slot | `loadingWidget` / `loadingBuilder` | Widget 是快捷内容，builder 是动态渲染入口 |
| `error` / error slot | `errorWidget` / `errorBuilder` | Widget 是快捷内容，builder 优先且接收错误对象 |
| `load` / `error` event | `frameBuilder` / `errorBuilder` | 遵循 Flutter `Image` 生命周期，不新增重复通知源 |
| `width` / `height` | `double? width` / `double? height` | Flutter 使用逻辑像素，默认展示为 72 × 72 |
| `lazy` | 由 Flutter Widget 构建时机和滚动列表负责 | 平台专属，不映射 |
| `webp` | 由 Flutter 图片解码器自动识别 | 无需布尔开关 |
| `showMenuByLongpress` | 业务层 `GestureDetector`/菜单组合 | 微信平台能力，不映射 |
| `t-id` | `Key` | 使用 Flutter 身份机制 |
| ARIA | `semanticLabel` / `excludeFromSemantics` | 使用 Flutter Semantics |
| 点击 | `GestureTapCallback? onTap` | Flutter 可选扩展；三种内容状态共用唯一入口 |
