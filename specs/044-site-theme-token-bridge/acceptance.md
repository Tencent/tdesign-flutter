# 验收记录

## 默认值来源收敛验收（2026-10-07）

- 删除 JS 的 76 项手写默认值表，构建期从控制器 1.2.6 的 web extra 提取补齐声明；逐声明检查 web 缺失值可补齐、mobile 已有值不覆盖。移除无 Flutter 消费者的 body-extraLarge 行高及另外三个手写扩展默认值，缺失字体维度由 Flutter 侧补齐。
- 删除纯 Dart 字体映射中的默认字号、行高和字重；只保留 CSS/Flutter 名称与派生偏移。font / fontMetric 仅输出实际提供且相对基线变化的维度。Example 读取各模式默认 fontMap 构造完整 Font，直接保留默认 FontWeight 对象、小数尺寸与行高。旧 Token JSON 协议仍拒绝不完整字体。
- 独立包输出契约调整：font 不再包含默认 fontWeight 或补齐未修改维度。包未发布（0.0.0 / publish_to: none），组件公开 API 无 breaking change；独立包调用方须按 README 使用接收端默认字体补齐，不能直接交给要求完整字段的 Font.fromJson。
- Node 适配测试 6 项通过，含安装依赖的所有 extra 声明及默认值变化后无本地旧副本；官网生产构建通过，文档适配 10 项及 57 份文档检查通过。
- Flutter 3.32.0 / 3.47.0 对应 Dart 独立测试各 27 项与严格 analyze 通过；Example 消息测试各 11 项与严格 analyze 通过。逐声明分别检查全部显式映射，避免别名/回退被优先级掩盖；字体覆盖 20 个层级和 40 个指标，含稀疏输入、基线中 99px 未修改维度、实际 Flutter 默认值、字重、小数和旧协议校验。既有 sharedExampleTests 与双版本 css2token CI 入口继续执行这些测试；调度器自测 19 项通过。
- Flutter 3.47.0 release Web 子路径构建通过。首次 no-pub 误用了 3.32 的 package_config 导致引擎与 Flutter 源码不匹配，使用对应 SDK offline pub get 后重跑通过，该环境失败不归为源码缺陷。
- 浏览器执行当前 Dart 编译产物，25 个案例 × light/dark = 50/50 通过，涵盖所有转换分组、稀疏字体和单维基线变更；Light/Dark 展示均检查。
- 本机官网 127.0.0.1:19000 与当前 Flutter Web 构建联调：Light/Dark 小号/大号按钮语义宽度分别 100 / 107.9921875；固定模式与递增模式切换产生 body-medium 22.5px 小数行高，随后字号仍可更新。两模式尺寸编辑入口分别将实际 size-6 调整为 Dark 20px / Light 24px。Light 往返 Divider/Button 后新 iframe 保留 107.9921875。浏览器截图已在本次交互中展示。
- 此次浏览器验收为转换契约及上述受影响官网路径，不等于全部组件逐像素验收；上游预设刷新恢复及面板初次数值显示问题沿用历史限制。没有修改组件默认 Token 或 Golden，也未发布独立包或推送远端。

以下保留历史验收过程；当前实现及验证以本页「默认值来源收敛验收」为准，历史 JS 转换测试不代表当前包。

## 验证环境

- 分支：`rss1102/fix/site-theme-all-tokens`
- 基线：`origin/develop` (`a0b0d0fec`)
- Flutter/Dart：Flutter 3.32.0 与 3.47.0
- Node/pnpm：Node 24.15.0 / pnpm 11.20.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `corepack pnpm test:theme` | 通过 | 4 个转换契约测试 |
| `corepack pnpm site` | 通过 | Vite 生产构建；仅有既有资源路径和 chunk 大小警告 |
| `flutter test --no-pub test/web_theme_message_test.dart` | 通过 | Flutter 3.32.0，3 个测试 |
| `flutter analyze --fatal-infos` | 通过 | Flutter 3.32.0，0 issues |
| Flutter 3.47.0 聚焦测试与严格 analyze | 通过 | 双版本兼容，0 issues |
| `flutter build web --no-pub --base-href /flutter/example/` | 通过 | Flutter 3.32.0 官网子路径构建 |
| 三个调度器自测 | 通过 | 13 个测试，含 Example 测试清单登记 |
| `git diff --check` | 通过 | 无空白错误 |

## 人工验收

- [x] 官网生产构建中显示色彩、字体、圆角、阴影、尺寸五个面板
- [x] 暗色 Button Demo 加载后，字体从小号切到大号会触发 Flutter 语义树重建；标题宽度由 124.48 变为 129.67，按钮宽度由 104 变为 107.99
- [ ] 整页刷新恢复自定义参数（2026-10-06 逐项复测推翻此前判断：选项标签保留，但实际 CSS 重置）

## 未覆盖项与后续工作

- 浏览器人工验收选择字体作为端到端代表项；其余面板由同一 MutationObserver/消息链路承载，并由纯转换单测逐组覆盖。
- 未改组件默认 Theme 或 Golden 基线；未操作远端分支或 PR。

## develop 同步验证（2026-10-06）

- Node 主题转换 5 项、文档适配 10 项通过，57 份组件文档映射检查通过。
- Flutter 3.32.0 / 3.47.0 消息解析各 3 项、回归调度器自测 19 项通过；两版本 Example 严格 analyze 无诊断，3.32.0 组件工程严格 analyze 无诊断。
- 站点生产构建通过；本轮未重新执行浏览器人工验收及 Golden。远端 CI 以同步后新提交为准。

## 当前 Token 重整验证（2026-10-06）

- Node 主题回归 10 项，文档适配 10 项；测试检查控制器包实际默认 CSS 的输出键均有当前 Flutter getter。
- Flutter 3.32.0 / 3.47.0 主题消息解析各 3 项与 Example 严格 analyze 通过。新增 fontMetric / insetShadow 解析及默认值保留断言。
- Example 生成片段 --check 通过；站点生产构建与 Flutter 3.47.0 Web 子路径发布构建通过。
- 浏览器同源开发入口下，Button 从大号切换小号，语义节点宽度由 107.99 变为 100；切回大号后往返 Divider/Button，重新加载的 Demo 保留 107.99。
- 本轮不修改组件默认 Theme 和 Golden，未更新 Golden 基线。远端 CI 以推送后 head 为准。
- 上游控制器限制：整页重载保留字号选项标签，但实际 CSS 回到默认；曾观察 Button 恢复 104。该现象不能当作桥接恢复成功，亦不由 iframe ready 握手修复。

## Light / Dark 浏览器逐项复测（2026-10-06）

代码 head：`27d3e67956f2e053c5fe1cc73f878fc70028e66c`。站点同源入口
`http://127.0.0.1:19000/flutter/components/button`，Flutter 使用该 head 的
3.47.0 release Web 构建。初段开发服务未重新编译 ready 握手，发现页面往返
失去参数后已替换为当前 release 构建；最终初始化判断以替换后的实测为准。

| 功能 | Light | Dark | 证据与限制 |
| --- | --- | --- | --- |
| 主题色预设 / 保留输入 / 智能推荐 | 已操作 | 已操作 | 蓝色、黄色预设；当前 release Button 显示黄色主题，切换页面后保持 |
| 中性色关联主题色 | 已操作 | 已操作 | 操作关联开关；未对每个灰阶逐一做 Flutter 像素断言 |
| 成功 / 错误 / 警告色编辑 | 已操作 | 已操作 | HEX 输入生成双模式色板；当前 release Message 三种通知均实际触发并截图 |
| 字号与阶梯 / Token 展示 | 已操作 | 已操作 | Button 小号宽度 100，大号约 107.99；两种展示模式可切换 |
| 固定 / 递增行高 | 已操作 | 已操作 | 固定预设 +8 / +16 与递增 *1.5；Flutter 文本换行、布局随调节变化 |
| 字体颜色 | 仅检查默认展示 | 展示有缺陷 | 面板仅默认选项；Dark 面板仍显示黑色 primary/secondary 的 Light 说明，Flutter 实际文字为白色；未逐项编辑字体颜色 |
| 圆角 | 全直角已操作 | 超大已操作 | 面板数值 0 与 small=4/default=6/large=18；当前 release Button 显示对应矩形圆角变化 |
| 外阴影 | 超轻已操作 | 超深已操作 | 当前 release TabBar 悬浮胶囊实际消费 shadow3，双模式截图；未逐一证明 shadow1/2/4 的可见变化 |
| 组件大小 / 上下边距 / 左右边距 / 弹出层边距 / 组件间距 | 初次显示为空 | 初次显示为空 | 后续确认点击 Token 可弹出编辑器，不能据此判断没有入口，详见独立库验收 |
| 页面往返 / iframe 初始化 | 已检查 | 当前 release 已检查 | 自定义颜色、字号、圆角在新 iframe 中恢复；旧开发服务的失败不计为当前代码结果 |
| 整页刷新 | 失败 | 失败 | Light 小号标签保留但 CSS 变成16px；Dark 大号17px刷新后变成16px，标签仍大号 |
| 恢复默认 | 已操作 | 已操作 | 确认恢复后字号选项、列表回到默认 |

### 结论与覆盖边界

- 五个面板及上表子功能均进行了浏览器检查，但不能认定“所有 Token 的双模式端到端验收通过”。
- Dark 字体颜色说明、整页刷新恢复属于控制器上游问题；功能色初始 HEX 为空，编辑后才显示。尺寸入口的此前判断已纠正，后续实测可用。
- `shadow4`、四方向 insetShadow、所有 fontMetric、每个 spacer 和颜色 Token 的独立可见效果没有全部浏览器覆盖；转换/解析单测不能替代这部分证据。
- 截图保存在本次任务 `/tmp/pr1132-release-{light,dark}*.jpg`，不提交显示图片到仓库；不更新 Golden。
- 该轮检查不能替代所有 Flutter Token 的视觉覆盖。控制器预设与持久化属于上游；后续独立库以实际 CSS 转换契约验收，PR 仍保持 Draft。

## 独立 css2token 库验收（2026-10-06）

- `packages/css2token` 整体复制到不含站点及 node_modules 的临时目录，22 项独立 Node 测试通过。无 Vue、DOM、Node 内置模块或控制器运行时依赖。
- 站点原 Theme Bridge 仅保留 CSS 补齐与消息适配，转换调用独立库。库不读取控制器预设、持久化或文件系统。
- `pnpm site` 通过：32 项主题测试（22 独立 + 10 适配）、TypeScript strict 声明消费检查、10 项文档适配测试、57 份组件文档检查与生产构建。既有资源路径与大 chunk 警告保留。
- `npm pack --dry-run` 通过：包清单仅入口、声明、README、LICENSE、package.json；private=true，未发布，未添加新运行时依赖。
- 独立浏览器页面 `test/browser.html` 在临时目录静态服务中运行：Light / Dark 共 40/40 断言通过，包括稀疏输入、语义引用、嵌套 fallback、循环、20 个字体层级及 40 个指标、6 圆角、4 外阴影、4 内阴影、清除阴影、7 spacers、优先级、基线增量与双模式分离。截图 `/tmp/pr1132-css2token-{light,dark}.jpg`。这是浏览器转换 JSON 验收，不等价于所有 Flutter 组件逐像素验收。
- 站点集成：Light 与 Dark 均实际操作小号/大号，Flutter Button 语义宽度 100 / 107.9921875；往返 Divider/Button 后新 iframe 保留 Dark 大号宽度 107.9921875。
- 尺寸入口纠正：点击 comp-size-xxxs 打开数值输入器；Light 通过键盘替换把实际 `--td-size-6` 从16px改为24px，Dark 从24px改为20px。应输入数值，由控件格式化 px；此前“没有编辑入口”的判断错误。面板初次数值为空时打开编辑器后刷新显示。
- 未修改 Flutter 源码、组件公开 API、默认主题或 Golden；本轮无 breaking change。Flutter 双版本的既有解析协议保持不变；最终远端 CI 以新 head 为准。
- 上游控制器整页刷新预设恢复、Dark 字体颜色面板说明仍不在本库职责内，不宣称已修复。

## 纯 Dart 迁移验收（2026-10-06）

- 代码基于已 rebase 的 `f346023f`，新增纯 Dart `packages/css2token`，删除 JS 转换实现及 npm 元数据。版本 0.0.0、`publish_to: none`，零运行时依赖；未发布。
- 官网发送 `flutter-css-theme-update`：完整 light/dark/extra CSS、控制器原始基线和 themeMode。Example path 依赖调用 Dart 库，旧 `flutter-theme-update` JSON 消息继续兼容；来源校验和 ready 握手保持。
- Flutter 3.32.0 / 3.47.0 对应 Dart 独立测试各 23 项通过，独立包 strict analyze 无诊断；Example 消息测试各 8 项通过，strict analyze 无诊断。
- 整包复制到不含官网或 Flutter 目录的 `/tmp/pr1132-css2token-standalone-dart`，offline pub get、23 项测试、strict analyze 均通过。包的 lib 不依赖 Flutter、DOM、文件系统或控制器。
- `pnpm site` 通过：4 项 JS 控制器消息适配测试、10 项文档适配测试、57 份组件文档检查以及 Vite 生产构建；既有 chunk/资源警告保留。Flutter 3.47.0 Web 子路径构建通过；未更新 Golden。
- 纯 Dart 测试程序 `test/browser_probe.dart` 编译成 JS 后，浏览器实际执行双模式转换 42/42 通过。涵盖所有转换分组、字体层级、引用/fallback/循环、清除、基线及模式分离；页面 Light/Dark 均检查。截图 `/tmp/pr1132-dart-{light,dark}.jpg`。
- 官网本机联调 `127.0.0.1:19000` 使用本轮 3.47.0 release 构建：Light/Dark 均操作字体，Button 小号宽度 100、大号 107.9921875；主题色蓝/黄、圆角全直角/超大、尺寸 size-6 24/20px、阴影超轻/超深均实际操作，TabBar 悬浮胶囊阴影已双模式截图。
- 浏览器发现递增行高产生 22.5px 等小数，现有 Font JSON 的 int 参数会使整条主题消息失效。已在 Example 字体适配层保留 double size 与精确 lineHeight/size；8 项消息测试含 15.5px/23.25px、双模式及其余字段保留断言。最终构建的 Light/Dark 均重新应用递增模式、检查真实 22.5px CSS，再操作字号仍能更新 Flutter。
- 转换的 42 项浏览器契约验收不等价于所有组件 Token 逐像素验收。历史记录中上游整页刷新恢复和 Dark 字体颜色面板说明问题仍保留；本轮不修改控制器上游或组件公开 API。Light 往返 Divider/Button 后新 iframe 的按钮宽度仍为 107.9921875。GitHub/CNB 双版本 CI 已登记独立 Dart 测试，远端结果以推送后 head 为准。

## Web 监听器生命周期优化（2026-10-07）

- 验证基线：`26f6278b`；七个实现/测试/清单文件合并 SHA-256：`d399710c9b01ea069382f76c5383e28e4271cc545f2050b0e52b90cda06548cd`。
- Flutter 3.32.0 / 3.47.0 的消息、生命周期及 Example smoke 测试各 26/26 通过；Example 全量 `flutter analyze --no-pub --fatal-infos` 均无诊断。生命周期测试已登记 GitHub/CNB 共用的 sharedExampleTests。
- 调度器自测 19/19、示例生成器 `--check` 及 Flutter 3.47.0 Web release 构建通过。
- Chrome 直接运行生产监听器：父窗口消息、来源过滤、非法消息、CSS Light/Dark、释放和重新注册 10/10，独立窗口及重复释放 2/2 通过；两次注册均收到 ready。
- 本机官网与最终 Example 联调：Light/Dark 小号与大号字体（15px/17px）、刷新及 Button→Divider→Button 后的模式与主题色同步通过。浏览器证据覆盖受影响通信链路，不代表所有组件逐像素验收或远端 CI 浏览器验收。
