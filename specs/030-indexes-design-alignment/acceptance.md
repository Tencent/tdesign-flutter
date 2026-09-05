# Indexes 验收记录

## 设计与交互证据

- Figma 组件集已读取并确认 8 个变体：number/a-z、normal/capsule、default/active。
- 已在小程序官网真实 WebView 点击“基础用法”：打开后默认定位 B，B 锚点和侧栏同时激活；源码确认点击与连续触摸选择、300ms 提示消退、页面级滚动约束。
- Flutter Demo 的基础示例以 initialIndex=B 同步激活态与滚动位置；自定义示例使用 1,3,5,7,8,10,# 和胶囊锚点。Flutter 保留内嵌 ScrollController 能力。

## 本地验证

- Flutter 3.32.0：组件与 sticky-header 共 62 项测试通过；Example 结构/交互 4 项、Golden 测试 6 项通过；组件与 Example 严格 analyze 零诊断。
- Flutter 3.47.0：相同 62 项组件测试和 4 项 Demo 测试通过；组件与 Example 严格 analyze 零诊断；Example Web release build 通过。
- 生产代码覆盖率 667/699 = 95.42%。
- API 文档与两份示例代码片段已由仓库脚本生成；旧胶囊片段已清理。
- 本机生成的 6 张 macOS 图片已人工检查：明暗整页、基础 B 打开态、自定义数字胶囊打开态均无缺字或裁切。城市字形使用独立 Noto Sans SC 测试子集，不进入产品包。
- 已增加真实 Example 路由的 Android 集成测试，覆盖进入页面、基础示例默认定位 B、点击 G 后滚动与激活同步、自定义胶囊索引选择 10、弹层返回及暗色主题重开，并在关键状态采集截图。

## 尚未完成

- macOS 图片不能作为权威基线。Flutter 3.32.0 Linux 容器因需要把当前工作树和 pub 缓存挂载给既有第三方镜像，被安全策略拦截，等待用户显式授权后再生成、无更新参数复跑并人工复核。
- Android 16 真机 `40302eeb` 已完成全新安装与完整集成测试：基础示例默认定位 B、点击 G 后滚动与激活同步、自定义胶囊索引选择 10、弹层返回及暗色主题重开均通过，最终输出 `All tests passed`。5 张设备截图已人工复核，无缺字、裁切或错误激活态。随后使用正常 `lib/main.dart` 构建 APK 并通过 ADB 持久安装，安装返回 `Success`，包路径、运行进程及普通 `MainActivity` 均已确认；应用在测试结束后仍保留在手机中，可供人工操作。iOS 真机未验证。
- 尚未提交、推送或创建 PR；远端 CI 尚无状态。
