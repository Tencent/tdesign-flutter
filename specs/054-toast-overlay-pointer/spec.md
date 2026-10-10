# Toast 遮罩点击穿透修复

基线：origin/develop e724cd0c4。范围仅 Toast 实现与既有组件回归。

## 行为契约

遮罩可见性由 showOverlay 控制；背景点击是否拦截由 preventTap 控制，两者独立。Toast 自身区域正常命中。关闭后背景交互恢复。公开签名、默认值及实例替换/计时语义不变。

## 风险表

| 风险 | 基线触发/影响 | 修复 | 回归 |
| --- | --- | --- | --- |
| T1 / P2 | showOverlay=true、preventTap=false 时，有色全屏 Container 仍拦截背景点击 | 仅遮罩包裹 IgnorePointer，按 preventTap 决定命中 | 四种布尔组合及 dismissAll 后恢复 |

默认行为和 API 不变，无 breaking change。显式 preventTap=false 的使用方恢复背景交互；需要阻止背景操作时必须使用 preventTap=true。
