> 最新处置（2026-10-15，Spec060）：已实修Ghost语义回退的2个观察项，8项由既有Flutter契约及运行断言支持；21项差异与1项平台几何已有具体方案，524项仍待补运行。当前代码为30767a55上的未提交工作区，本地新指纹验证见 [Spec060](../060-token-difference-resolution/acceptance.md)，不沿用旧远端CI作为本次修复通过证据。

# Token 审查现状（发布准备补核）

本轮复核了当前默认主题 JSON 与已冻结证据的 216 个全局键：计入 scrollbarHoverColor 的公开 getter 回退后，有效默认值与既有 Flutter 记录全部一致。该键暗色 JSON 缺省，但 getter 明确回退 Color(0x4D000000)，不能仅因 JSON 没有键就报缺陷。

对 804 项组件变量重新定位当前 Flutter 源码中的 getter/Theme 名称，保存 current-token-verification.json。定位仅用于更新审查入口，未取得新的冻结小程序源码/设计像素，因此不更改原有 reviewDecision 或 finalPaintVerified。

- 24 项原记录为默认 Widget 值验证；12 项为回退 Widget 已验证、视觉待核。
- 10 项冻结源码未找到消费者；81 项不属于当前 Flutter 组件表面。
- 677 项仍是待审队列，不是 677 个已复现缺陷。本轮不能用同名引用或 95% 行覆盖率把它们标为完成。

## 待审分批顺序

| 小程序组件 | 阶段性待审项 |
|---|---:|
| button | 86 |
| switch | 31 |
| step-item | 26 |
| input | 24 |
| cell | 23 |
| cascader | 19 |
| avatar | 18 |
| checkbox | 17 |
| radio | 17 |
| slider | 16 |
| link | 15 |
| search | 15 |
| tabs | 15 |
| badge | 14 |
| calendar | 13 |
| collapse-panel | 13 |
| navbar | 13 |
| popover | 13 |
| footer | 12 |
| tag | 12 |
| action-sheet | 11 |
| drawer | 11 |
| indexes | 11 |
| notice-bar | 11 |
| picker | 11 |
| swiper-nav | 11 |
| result | 10 |
| skeleton | 10 |
| table | 10 |
| indexes-anchor | 9 |
| message-item | 9 |
| progress | 9 |
| textarea | 9 |
| upload | 9 |
| dialog | 8 |
| divider | 8 |
| dropdown-menu | 8 |
| image-viewer | 8 |
| tree-select | 8 |
| rate | 7 |
| side-bar-item | 7 |
| tab-bar-item | 7 |
| back-top | 6 |
| cell-group | 6 |
| toast | 6 |
| avatar-group | 5 |
| empty | 5 |
| form-item | 5 |
| loading | 5 |
| popup | 5 |
| image | 4 |
| picker-item | 3 |
| side-bar | 3 |
| stepper | 3 |
| tab-bar | 3 |
| swiper | 2 |
| date-time-picker | 1 |
| paragraph | 1 |

先审涉及公开 API、默认状态、禁用/按压和 Theme 覆盖的项目；每项记录目标浅/暗最终值、当前 Widget/Painter 的实际来源以及运行断言。明确不属于本次1.0承诺的项目须有范围裁定，不能由自动脚本自行延期。

本轮没有擅自修改 Token、添加 Theme 字段、更新 Golden 或标记全量跨端像素完成。真实剩余验收见 manual-acceptance.md。
