# Radio Golden 测试字体修复（2026-10-13）

仅本地处理，HEAD 保持 `93c1d7479586017618f2e3b0d21818b6cae1a632`，未提交或推送。此前逐图 Review 发现的 Radio 缺字阻断以本记录的修复与最终验收为准。

- 专用 Golden fixture 改为复用 `withDemoGoldenFonts`，将确定性 CJK 字体注册到 TD Token；不恢复 Material 字体继承，不改生产源码、公开 API 或用户 Demo。
- 默认与选择后的四个明暗场景均断言实际 Radio 文案的字体回退包含专用 CJK 字体，防止更新错误基线掩盖配置遗漏。
- Flutter 3.32.0 / 3.47.7 各通过 56 项 Radio 与共享主题边界回归、7 项 Demo/字体配置回归；Demo analyze --fatal-infos 均零诊断。示例片段 --check 通过。
- Linux Flutter 3.32.0 首次无更新参数比较确认四张图片恢复中文字形和正确排版；有意更新一次后立即无更新参数复跑，四项全部通过，未调整容差。
- 四图逐项复审：标题、说明、选项、副标题与卡片文案均无缺字或意外裁切；真实点击后受控值为 3，选择标记对应最后一项；明暗状态和禁用语义色正确。
- 哈希确认：613 张运行基线中仅四张 Radio 变化，其余 609 张不变。其余已登记视觉套件沿用相同源码、环境及命令下的既有成功结果，未重复执行全量 Golden。
- TD 显式样式/customIconBuilder、普通自定义内容字体/图标主题、选择、Tooltip、反馈的相关回归通过。生产 lib 指纹仍为 `bd1ed0db713833c49201d8dbde70b32a0bba3ea5078828f6375196688707a59d`。

日志：`/private/tmp/td1157-radio-{components,demo,analyze}-{332,latest}.log`、`/private/tmp/td1157-radio-snippets.log`、`/private/tmp/td-style-ownership-linux/linux-radio-{before,update,verify}.log`。范围核对：`/private/tmp/td1157-radio-golden-changes.json`。

最终 Review：本次 Radio 字体与四张基线修复通过；无新增 breaking change，测试修复不写用户更新日志。Linux Golden 字形证据不外推为所有设备与设计稿逐像素一致。
