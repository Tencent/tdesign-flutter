# 验收记录（2026-10-14）

基于develop 6ffbdd5fb；本分支不含日期时间修复289f98338（PR #1159）。

- Flutter3.32.0 / latest3.47.7：Tag、Badge、Text各195项功能测试通过，Tag/Badge公开Demo各8项通过；组件和Demo analyze均零问题。Tag生产覆盖率312/319=97.81%，满足95%门禁。代码片段generate/check通过，仅更新Badge自定义示例片段。
- 测试覆盖4档Tag、M2/M3、1×/1.5×缩放、显式TD leading/字体Token/字距、保留多行与普通Text、既有图标/关闭/状态/尺寸，以及Badge自定义内容。
- Linux3.32：先无更新比对，确认7张有意差异；4张Tag页面只移动文字，2张Badge页面仅NEW区域变化（22×12px），1张共享场景仅Tag文字。逐图审查后更新，再无更新复跑29项组件/Theme与6项Demo Golden全通过。图片尺寸一致，默认数字Badge基线不变。没有改变比较器或容差。
- 不宣称所有字体、所有字符串零像素光学偏差。TText全局默认、多行段落、原生基线/选择能力与调用方自定义内容未被强制改写。
- 修复前Android手机DPR3.25、font_scale1.0已复现；更新修复版时手机已断开，修复后真机视觉核验待补。不得将Linux审图当成修复后Android/iOS验收。
- 字形对比与逐图指标保存于本地text-centering-fix审图报告；可追溯仓库证据为更新的7张Golden及上述已登记测试。
