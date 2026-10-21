# 干净独立分支验收

2026-10-21。分支 rss1102/breaking/button-navbar-text-defaults，独立副本 button-navbar-text-slots-clean，从原验证基线 d0de29e8 提取。21个变更文件（含4张PR审查证据图）只涉及两组件实现、原登记测试与两份必要测试辅助、文字dartdoc/生成API、站点主题说明及Spec082；无Spec081、其他组件修复、CI或工具链改动。本段记录发布前完成的本地验证；远端CI结果需以PR当前head为准。

Flutter3.32.0与3.47.7各通过：Button245、NavBar73、Dialog32、DropdownMenu95、Fab72、Upload50，合计567项组件；30项Demo非视觉；34项既有文字契约；17项调度；从migration.md直接提取的两段Dart核心片段1项验证（含旧正文外观显式恢复）。严格分析0诊断，57份API检查一致，文档同步6项无陈旧。Button行覆盖99.27%，NavBar100%。

两SDK正式生成button/navbar/text/theme一致，实际变更产物为button_api.md、navbar_api.md、text_api.md；TTextThemeData说明也在text_api.md中。源码注释与站点说明解释正文默认、组件默认、显式覆盖、外层/内层主题及inherit:false例外。

Linux3.32原Button视觉入口10项、NavBar组件2项/Demo14项共26项通过（含结构/交互），无更新参数。1052个已跟踪PNG保持不变。此分支未运行依赖此前Dialog修复的视觉场景，不把混合分支的108项结论移用。

Dart解析器token核对确认：全局TText及TTextThemeData仅有注释变化；Button/NavBar可执行代码与已完成前后截图版本相同。原Scope/Resolve、默认主题、字体及Linux包配置不变，复用此前固定环境截图；没有重新生成或更新图片。52组原生Text/52组完整显式TText像素不变、52组默认TText按预期变化，属于已确认默认行为breaking。兼容性及迁移详见migration.md。

完整命令、源码指纹、文件白名单与日志在本地 artifacts/button-navbar-clean-split-20261021/REPORT.md、boundary.json、token-comparison.json、source-hashes.json。双版本验证入口 validate.py / validate-consumers.py / verify-migration.py；API正式入口tool/generate_api.mjs；文档入口scripts/sync-readme.mjs --check；Linux入口run-linux.py。不将本地证据视为远端CI或设备验证。

## PR 审查截图

以下为同一 Linux Flutter3.32.0 固定环境的原始单元格截图，左侧前后顺序由表头标识；不是Golden基线，不参与比较器或更新。完整渲染对比沿用上述已核对证据。

| 场景 | 修改前 | 修改后 |
| --- | --- | --- |
| 中号primary按钮 | ![修改前](evidence/button-before.png) | ![修改后](evidence/button-after.png) |
| 配置紫色标题的NavBar | ![修改前](evidence/navbar-before.png) | ![修改后](evidence/navbar-after.png) |

本次发布只新增这四张审查证据图，不修改任何已有Golden。按钮14/22、w400主文字色变为16/24、w600白色；导航标题14/22、w400变为18/26、w600并接受场景配置的紫色。无样式文字的宽度/省略位置也可能变化；显式样式优先和全局隔离保持。
