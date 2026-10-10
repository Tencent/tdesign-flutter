# Toast 时长、位置与背景交互契约

基线：develop e724cd0c4；本 PR 在原遮罩修复上调整公开契约。

## 行为契约

- 所有 show 方法默认 duration 为 2000ms。duration > 0 自动关闭；duration <= Duration.zero 保持显示直到主动关闭。不再公开 infiniteDuration。
- TOverlayConfig.preventTap 更名为 preventScrollThrough，默认 false；true 时全屏命中层阻止背景点击、触摸拖动和鼠标滚轮，关闭后恢复。Toast 自定义内容自身仍可交互。showOverlay 独立决定遮罩是否可见；false/true 四种组合均有效。
- Toast 中心相对 Overlay 高度：top=25%、middle=45%、bottom=75%；水平居中。按实际渲染坐标验证，不以 Align 参数代替。
- 同 ID 替换、不同 ID 并存及关闭 API 保持不变。

## Breaking 与迁移

| 旧契约 | 新契约 | 迁移 |
| --- | --- | --- |
| TToast.infiniteDuration | 移除 | duration: Duration.zero |
| duration <= 0 立即关闭 | 不自动关闭 | 立即关闭请调用 dismissToast / dismissAll |
| 加载默认无限 | 默认 2000ms | 长期加载显式 duration: Duration.zero |
| preventTap | preventScrollThrough | 更名参数；禁止背景点击和滚动 |
| middle 50% | middle 45% | 默认提示位置上移 |

## 验收

双 SDK 严格分析、组件回归和覆盖率 >=95%；零/负/正时长与两种加载默认值；四种遮罩组合的点击、拖动、滚轮与关闭恢复；自定义内容交互；不同内容高度下的实际中心位置；生成 API/示例和 Demo 功能回归；Linux Flutter 3.32.0 light/dark Toast 操作后 Golden。
