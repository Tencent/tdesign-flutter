# 本地验收

- 已移除47个页面的 showTestModule:false，ExamplePage默认true；共享kDebugMode门禁保留，Profile/Release隐藏。
- Flutter 3.32.0：19个受影响测试文件中98项功能测试通过，排除golden标签与“视觉快照”用例。共享控件、全部页面及test目录分析无问题；git diff --check通过。
- 更新原有隐藏断言为Debug默认展示；Switch允许调试区块带来的滚动；Search测试通过TSearchBar定位子TextField（当前TextField.decoration为空，原定位过时），保留搜索结果交互验证。
- Flutter19003预览已热重启，页面需刷新。本轮没有构建Release产物，Release结论基于保留的kDebugMode构建常量门禁；未重新运行高版本Flutter或浏览器像素验收。
- 首轮误包含Cell文件中3项视觉快照，在macOS出现2.21%～2.65%差异。没有更新Golden基线；后续仅运行功能回归，Linux视觉验收仍未执行，不宣称视觉检查通过。
- 仅本地修改，未暂存、提交、推送或更新远端PR；未修改CI、版本、CHANGELOG。

## 交付状态更新

用户已授权将本地改动提交、推送到PR1163，并以推送后的提交进行全局Review；上文“仅本地/不推送”为此前实施阶段的历史记录，不再是本次交付限制。合并放行以当前提交的CI、Review及适用视觉验收为准。
