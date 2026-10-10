# 验收

2026-10-10，基线 develop e724cd0c4。源码/测试/Demo/Toast Golden/清单 diff 指纹（不含验收文本自身）：21e47eeeb1115ff62883c4e7322c1104ac1c4ac8790cb680e12976612a750ebc。

## 非视觉

- 本地 Flutter 3.32.0 / Dart 3.8.0 与 stable 3.47.6 / Dart 3.13.5：Toast 67 项组件测试 + 调度器 19 项，共 86 项均通过；组件及 Example 严格 analyze 无诊断；Toast Demo 两项功能测试均通过。
- 时长覆盖全部七个展示入口的零/负值持久显示与主动关闭、两个加载入口默认 2000ms、既有正时长与 ID 替换/并存。
- 四种 showOverlay/preventScrollThrough 组合均验证背景点击、触摸拖动、鼠标滚轮及关闭恢复；自定义 Toast 按钮仍可点击。
- top/middle/bottom 实际中心分别为 Overlay 高度 25%/45%/75%，覆盖 20/150 高度内容。
- Flutter 3.32.0 Toast 生产覆盖率 LH/LF=228/238=95.80%。
- 源码 dartdoc 生成 API 与例子同步；370 份独立代码片段编译分析通过，生成器 --check 通过；新名字和时长语义可从生成文档直接读取。Demo 功能测试补登记到 exampleTests，视觉测试保留原登记。

## Golden

Linux amd64 / Flutter 3.32.0 固定字体、viewport、light/dark；先无更新参数运行，20 张操作后截图仅 Toast 区域发生预期上移，像素差异 2.10%-4.97%，默认精确比较，无容差变更；页面初始截图无差异。检查实际图与旧基线后仅更新此 20 张 Toast Golden，再立即无更新参数复跑，26 项全部通过。

| 公开场景 | 操作后 light/dark Golden | 功能依据 |
| --- | --- | --- |
| 纯文本、多行、横向图标、竖向图标 | text / multiple_text / horizontal_icon / vertical_icon opened | 真实点击后可见，自动关闭后消失 |
| 加载、成功、警告、错误 | loading / success / warning / fail opened | 真实点击后可见，自动关闭后消失 |
| 遮罩 | cover opened | 实际展示遮罩，组件测试验证点击、拖动及滚轮阻断 |
| 手动关闭 | manual opened | 真实显示/关闭按钮验证；duration=0 |

全部十种公开操作后场景分别覆盖两种主题，不以页面初始图替代。

远端 5c66ed07 的完整视觉回归进一步检出六个实际消费 Toast 的页面：Popover、PullDownRefresh、TabBar、NavBar、Link、NoticeBar，共 26 张操作后截图。Linux 本地无更新参数复现后逐项核对差异边界，仅 Toast 的新旧位置区域变化，差异 2.14%-3.86%；仅同步这些预期基线，六个页面 99 项测试更新后立即精确复跑全部通过。这些组件的实现和示例代码均未修改。测试执行位置使用 Overlay 全高，不机械限定为手机屏幕高。

## 跨端参考及限制

小程序固定 c58511a0bc51d0ceb1d1f3d8565df5e2f7e75f49，Toast 模板中 middle top=45%；Toast.show 仅 duration>0 创建 Timer，默认值 2000ms；preventScrollThrough 声明阻止点击和滚动。Flutter 保留 showOverlay 与 preventScrollThrough 独立的配置契约。本次没有微信真机像素对比，也未宣称所有 Toast API 全面一致。

独立验证目录，主工作区已有修改未触碰。Linux 一次性容器通过 --no-hardlinks 修复缓存 Git 克隆故障；切换 Flutter SDK 后清理构建缓存，避免 shader 版本污染。远端最终提交 CI 等待推送后核对，不沿用旧 head 的通过结论。
