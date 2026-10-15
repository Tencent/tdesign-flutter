# 本地验收

- 根因：TMap.entries/keys仅枚举本地值，按键访问才解析引用与factory默认值。Web消息合并保留这种增量结构。仅覆盖grayColor1的主题原来只能列出一项灰阶和额外bgColorContainer。
- 修复：灰阶键来自默认与当前主题的并集，值从当前主题按键解析；生成theme.ThemeOtherColorExample.txt，无手改产物。
- Flutter3.32.0：Theme和Web主题消息19项非Golden测试通过；新增回归确认当前映射确实只有一个显式灰阶，浅深色均列出14项，当前覆盖值及继承值正确，红蓝主题切换后更新。
- 修改相关目录静态分析无问题；生成片段--check通过，git diff --check通过。不改变组件API或TMap枚举语义。
- 原预览会话热重启被自动权限审核拒绝，未请求提权；另启正常本地预览，Flutter19005和站点19004均启动。Theme路由、示例代理、Flutter main.dart.js均HTTP200。未执行浏览器像素验收、Linux Golden、高版本或Release构建。
- 仅本地修改，未暂存/提交/推送，未修改CI/版本/CHANGELOG。

## 交付状态更新

用户已授权将本地改动提交、推送到PR1163，并以推送后的提交进行全局Review；上文“仅本地/不推送”为此前实施阶段的历史记录，不再是本次交付限制。合并放行以当前提交的CI、Review及适用视觉验收为准。
