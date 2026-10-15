# 0.2.7 → 1.0 文档核对结果

日期：2026-10-15。范围是从0.2.7发布包迁移到1.0候选，不核对alpha之间的迁移。

## 交付结论

2026-10-15，维护者确认本轮迁移文档、组件定位及发布说明核对结果可交付，进入PR合并审核。以下记录保留实际证据和未覆盖边界，不将维护者的交付确认写成浏览器、设备或视觉验证通过。

浏览器验收、4项历史修复的最终日志裁定和最终候选同步统一转入[后续发布验收清单](../074-release-readiness-closeout/readiness.md#文档交付后的发布验收)，不再作为本轮文档任务的未完成项。正式版本升级仍由独立PR1170完成，最终候选检查通过前保持草稿。

## 如何核对

先固定新旧来源，再分别检查声明覆盖、实际参数/能力、可运行用法和交付记录。每个结论都写明证明范围，不能用“名称存在”代替语义等价，用结构测试代替内容审核，或用编译通过代替设备/视觉验收。

- 旧来源：pub.dev缓存0.2.7与标签 `fa6544628bb2cbb8e1122aa79feca8043f9822d9` 的159个lib文件逐字节一致。
- 当前公开API：版本PR1170候选 `7d3cb3e26d3a83f4a1154061504d062fe7ac488e`。本轮未修改lib及生成API，与候选逐文件diff为空。
- 文档来源：本PR工作区的唯一迁移正文及共享fixture；对应内容哈希和新旧源文件哈希见 `migration-audit.json`。本轮文档修复尚未进入上述版本候选，合入后须同步版本PR并再次固定最终head。

具体链路为：**旧发布包声明/参数 → 指南的组件改法及删除边界 → 候选公开API/生成文档 → 源码示例与消费证据**。无法确认的旧行为明确列入剩余项，不标为通过。

## 五项检查结论

| 检查项 | 实际核对与结果 | 边界和剩余事项 |
| --- | --- | --- |
| 结构、入口、生成副本 | 57个组件路由、57个独立条目锚点及388条旧声明的目标检查通过；无缺项、额外项或重复。既有文档契约26项、主题桥接6项、6份文档同步检查及站点生产构建通过（保留既有大chunk警告） | 浏览器启动受当前环境限制失败，未取得桌面/375px下折叠分组深链接、刷新、返回和键盘访问证据，不能写成页面体验全通过 |
| 旧用法能否找到改法 | 对383项历史清单补核出3个Slider mixin及2个文字全局开关，实际388项；各自有明确处置及组件链接。57个组件条目重写为具体参数/职责迁移，不仅指向新API | 声明级定位完整不等于所有继承成员、业务子类和每个旧成员调用都运行验证；业务仍需按实际使用项编译和交互验收 |
| 删除能力及限制 | 修正图片业务弹窗、计时样式、Link维度等错配；补充徽标、跑马灯、文字开关、旧绘制继承点、图片透传及Steps完成态等限制。2114个旧图标常量中3个无同名新常量，已明确无等价承诺，all集合入口变化亦说明 | 明确“不保留/自行组合”不代表业务原能力自动恢复；不能宣称所有旧能力和像素一一等价 |
| 指南、示例、API与候选 | 当前369个自有公开声明API审计0问题；重新生成检查57份API均一致，370份Demo片段严格分析通过。指南共10组片段从共享fixture同步；本轮新增7个最小用法经双SDK分析/编译，既有独立消费21项交互测试两SDK通过 | 新增7个用法的分析通过不等于7组新增交互测试；最终release head尚未包含本次文档补丁，合入并冻结后要确认产物同步，发布后pub.dev消费另行执行 |
| 发布说明完整、去重、分组 | 对候选first-parent历史中的200个PR核对来源、正文标记和修改文件；生成草稿缺失的用户可见事项已补到版本PR候选稿，增加18条说明，合并5条重复主题文档记录，移除2条Spec元数据，纠正fix/breaking分组 | 4项旧实现修复仍须根据最终行为决定日志表述：#868滑块边界、#890固定列滚动、#880树形圆角、#903 Web文字居中；不能把旧补丁标题当成当前视觉通过声明。未确认机器人评论或写自动CHANGELOG |

## 本轮修复的具体错误

1. `BadgeConfig` 与 `MessageMarquee` 被笼统写为无对应声明，现改为具体配置及参数迁移。
2. `TDImageDialog` 错指全屏图片预览，现改为 `TDialog` 的图片/正文/操作组合。
3. `TDTimeCounterStyle` 错指形态枚举，现区分组件Theme有限字段与 `content` 自定义布局。
4. `TDLinkType` 表示结构，却错指配色枚举，现改为下划线、前/后图标参数组合。
5. 补充枚举成员差异，例如 `fill→filled`、loading独立布尔值、`middle→center`、`primary/danger→normal/error`；明确small徽标、filled按钮形状、Steps全局success等没有同名成员/直接开关。
6. 原清单漏5项自有导出；另核对外部图标包0.0.6，发现旧list、video_camera_3、video_camera_3_filled无同名常量，补充替代选择边界和字体身份变化。
7. 补齐主题复制/Map动态查询/JSON解析入口的迁移；明确Indexes初始索引不是受控值，Progress使用0到1比例及命名构造，TDMultiCascader表示多级单路径且新组件不替业务关闭浮层。

## 发布说明为何不能只信“不需要Changelog”

- PR1152标记无需日志，但实际调整了公开主题契约，应记录breaking变更。
- PR1142同样标记无需日志，实际增加了Calendar.weekdayNames。通过源码diff确认，并补入候选稿。
- PR1149虽然修改157个lib文件，但规范化AST完全一致，属于注释整理，可保留其不写组件行为日志的处置。
- 旧实现/中间版本的修复不自动变成最终API能力；200项处置、已补项和4项待确认记录见 `release-notes-audit.json`。只检查PR链接是否出现不能证明该PR全部子项都已收录。

## 可复查的工具与记录

- `tools/export_inventory.dart`：从主入口跟踪自有export/show/hide/part，记录声明位置和输入哈希。
- `tools/check_migration.mjs`：对旧导出清单、候选API清单和指南检查覆盖、路由、锚点、目标及限定成员名；输出 `migration-audit.json`，不作语义/运行通过声明。
- `tools/check_icon_names.dart`：比较旧自有TDIcons与实际依赖0.0.6的静态符号名；`icon-name-audit.json` 保留3个差异，不能推导图形相同。
- `tools/check_comment_only.dart`：比较规范化AST，保留语法与注解，排除格式和注释；`comment-only-audit.json` 区分PR1149纯文档与PR1142实际API增加。

这些是一次性发布审计工具与冻结证据，不新增CI入口，不作为另一份长期维护的用户迁移正文。

```sh
# 在组件包完成依赖解析后，从仓库根目录运行；替换 OLD_PACKAGE 为真实0.2.7缓存包目录。
dart --packages=tdesign-component/.dart_tool/package_config.json specs/076-migration-release-documentation-audit/tools/export_inventory.dart OLD_PACKAGE > /tmp/old-exports.json
dart --packages=tdesign-component/.dart_tool/package_config.json specs/076-migration-release-documentation-audit/tools/export_inventory.dart tdesign-component > /tmp/current-exports.json
(cd tdesign-component && dart run tool/audit_api_docs.dart --json) > /tmp/current-api.json
node specs/076-migration-release-documentation-audit/tools/check_migration.mjs /tmp/old-exports.json /tmp/current-exports.json /tmp/current-api.json /tmp/migration-audit.json
node scripts/sync-readme.mjs --check
(cd tdesign-component && node tool/generate_api.mjs --check && dart run tool/check_demo_snippets.dart && dart run tool/run_migration_consumer.dart)
node --test tdesign-site/site/flutter-example-docs/*.test.mjs
node tdesign-site/site/flutter-example-docs/check-docs.mjs
```

原Spec058的383项报告保留历史记录，本次388项结果不覆盖它。文档核对不替代Token消费、设备和设计验收，不据此合并版本PR或声明正式发布。
