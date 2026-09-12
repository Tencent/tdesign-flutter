# 方案

将旧 `variant` 映射为 `fit` 和 `shape`，仓库内依赖旧圆角/裁切默认的调用点显式声明新参数；按 Figma 的 72/89/134 宽度、24 间距和两组公开内容重组 Demo。将小程序内部强制 loading 的演示手段改写为 Flutter 声明式空来源语义，空字符串统一走失败构建器；保留 Flutter builder 扩展点并限定其仅负责渲染，以每个来源生命周期只通知一次的 `onLoad`/`onError` 补齐小程序事件能力，不复制平台专属参数。补 API 正交组合、来源状态、事件次数、三种状态点击、Demo 几何位置和明暗 Golden 测试，并在 Chrome 实际点击公开 Demo。
