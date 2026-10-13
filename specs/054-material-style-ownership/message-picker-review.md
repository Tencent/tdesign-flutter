# Message / Picker 修复验收

已修复两项，本记录为提交前本地验收。前后指同一 PR 本地修复前与修复后。

## Message

测量与绘制共享最终 TD 字体，并保留系统缩放、粗体、方向与 locale。没有恢复 Material 字体继承。Roboto、字距8的场景：实际宽408.42dp，结束位移由-280dp修正为-408.42dp；残留128.42dp降至0。截图取220ms，动画时长200ms。容器尺寸、字体没有变化。



## Picker

内置滚轮保持 TD FixedExtentScrollPhysics 与输入能力，viewport 以下恢复调用方 ScrollConfiguration。外部 NeverScrollable 下，拖动自定义内容的位移40dp降至0。星形图标原本在22dp窗口外，修复前错误滚动使其进入窗口；修复后保持初始画面，没有删除或改变自定义图标。内置滚轮仍能纵向拖动并触发选择回调。



## 验证

- Flutter 3.32.0 / latest 3.47.7 各241项组件测试、33项Demo功能测试通过；analyze零问题。
- 生产覆盖率（3.32）：Message260/264=98.48%；Picker380/386=98.45%；DateTimePicker687/707=97.17%。latest分别为259/264=98.11%、380/386=98.45%、686/707=97.03%，两版本均满足95%门禁。
- Linux3.32：58项既有Demo Golden与19项既有主题Golden精确匹配，无需更新；新增8项主题测试/16张基线，逐图核对后复跑27项主题Golden全部通过。
- 显式TD字距、1×/1.5×缩放、LTR/RTL、粗体、M2/M3、Android/macOS环境、自定义字体31/字距12/图标70、嵌套横向拖动、原生纵向选择有断言。既有受控值/禁用/键盘/关闭生命周期测试随完整套件通过。
- 只执行Linux自动截图，未声称真机验收；对比图原始像素最近邻2×放大，原图另存。场景外MaterialApp背景差异不属于TD视觉。
- 新测试沿用已登记的组件及主题Golden文件。逐图本地报告保存在 review-23-fixes；仓库可复现证据为 test/components/message/t_message_test.dart、test/components/picker/wheel_column_test.dart 和 test/components/theme/t_m3_isolation_golden_test.dart 及其 goldens/message_marquee_*、goldens/picker_custom_scroll_* 基线。
