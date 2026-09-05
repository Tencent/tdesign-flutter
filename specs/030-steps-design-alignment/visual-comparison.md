# 三方视觉与交互对照

## 参考

- 新版 Figma：页面节点 `24386:5241`；移动端画板 `28591:34552`；组件类型 `28591:34556`、错误状态 `28591:34615`、特殊类型 `28591:34637`。
- 小程序公开 Demo：TDesign 小程序 Steps 页面。
- Flutter：`lib/src/components/steps/` 与 `example/lib/page/t_steps_page.dart`。

## 差异

| 项目 | 新版 Figma | 小程序公开 Demo | 修改前 Flutter | 收敛目标 |
| --- | --- | --- | --- | --- |
| 分组 | 组件类型、组件状态、特殊类型 | 基础、布局、类型、状态、只读、自定义 | 六个模块 | 三组及 Figma 顺序 |
| 组件类型 | 水平/垂直默认、图标、点状及自定义内容 | 水平/垂直、默认/点状、自定义内容 | 缺完整垂直图标 | 补齐七个例子 |
| 错误状态 | 默认、图标、点状 | 错误态示例 | 仅图标错误态 | 同屏三种错误态 |
| 垂直可选择 | 已完成实心、当前空心、右箭头 | 点击事件更新 current | 独立 `verticalSelect` 状态 | `onChange` 驱动可选择与箭头，节点视觉对齐 Figma |
| 纯展示 | 四个蓝色实心节点与连线 | readonly 禁止点击 | `readOnly` 与 Theme 重复持有 | `variant.display` + 无回调 |
| 状态所有权 | 结构与交互分离 | props/event | Theme 与实例重复持有业务状态 | `value/status/variant/onChange` 单一职责 |

## 已记录的平台差异

- 小程序支持 `defaultCurrent` 非受控模式；Flutter 保持受控 `value/onChange`，避免双状态源。
- 小程序 change 事件是动态事件对象；Flutter 保持 `ValueChanged<int>` 强类型回调。
- 小程序公开分组和新版 Figma 三组布局差异较大；Flutter 视觉与 Demo 顺序优先新版 Figma，操作模式参考小程序。
- 新版 Figma 仅提供浅色画板；深色由 TDesign 语义 Token 和严格 Golden 独立验证。
