# 历史验收记录（设计复核前）

以下是上一检查点的联动结果，不能证明映射设计归属正确；本轮以 [逐项设计复核](mapping-review.md) 和 [修正后验收](design-acceptance.md) 为准。旧源码指纹、418项数字和浏览器截图不作为新源码的通过证据。

## 基线与改动

基线 develop `3774df7de9647cf261fb0ec63062e0b363b23bcd`，继承并保留 044 的未提交修复。本次补齐剩余组件消费并新增 [57 页矩阵](matrix.md)。未提交、推送、创建 PR 或部署线上。

- 尺寸消费覆盖头像、徽标、回顶、搜索框、开关、步进器、步骤、侧栏、树形选择、轮播、标签栏、选项卡、标签、倒计时、加载、Toast、刷新头、抽屉、下拉菜单、表格和卡片单元格等；非刻度默认值按其设计比例保留，显式配置优先。
- 字体：头像采用语义 title/mark 字号、字重，Stepper 采用 body 字号；大字号超出默认档位时增高；倒计时大字号读取对应标题字体指标，数字专用字体保留。
- 圆角：补齐侧栏、树形反向圆角、卡片单元格、紧凑复选框及徽标本体，保持原默认外观。
- AvatarGroup 增加真实组件使用的可选语义投影 shadowAvatarGroup；控制器自定义 shadow-1 时同步输出，未配置时保留原生默认阴影，组件 groupShadow 优先。
- 弹层捕获保留局部主题，并持续继承宿主全局 Theme；清除全局扩展可恢复默认，局部显式扩展不丢失。Drawer 不再固定打开时的 ThemeData。
- 表格示例操作文字允许收缩省略，避免增大字体后溢出；代码片段已由生成器同步。

没有删除能力、增加必填参数或改变默认数值；新增可选 Token/内部解析参数兼容既有调用。自定义全局 Token 后的联动行为属于有意修复，无需迁移。

## 验证环境与范围

- Flutter 3.32.0、3.47.7；macOS；DPR 1；中文；加载仓库实际中文/图标字体。
- 页面视口 600×12000，BackTop 使用 600×812 并滚动；长页每次变更前后遍历真实终点再复位。
- 真实 CSS baseline → css2token → Web 消息解析 → TThemeBuilder → 实际 Example 页面/组件，逐类别更新，不以站点壳变化作为证据。
- 418 个适用类别单元（209×两种模式）有变化断言，152 个不适用/显式约束单元单列说明；57 个页面、114 个页面/模式组合、570 个类别检查。
- 额外执行 114 组五类同时修改场景，共 418 个适用类别变化断言。
- 回归登记：sharedExampleTests 新增全组件审计；theme componentTests 新增 overlay_themes_test；尺寸、语义投影与弹层主题源码列入现有覆盖率门禁；站点新增 baseline fixture 同步校验。

## 稳定检查点

最终源码功能门禁（像素测试按文件名和标签排除）：

| 检查 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 27 组件及主题/验收功能测试 | 1766 通过 | 1766 通过 |
| 57 页、消息桥接、监听生命周期、Table 页面 | 138 通过 | 138 通过 |
| 严格分析 `flutter analyze --fatal-infos` | 无问题 | 无问题 |
| 28 个生产覆盖率门禁 | 全部 ≥95% | 全部 ≥95% |

命令：`python3 /tmp/tdesign_validate_components.py <version>`（清单为 button、fab、avatar、search、backtop、switch、stepper、time_counter、tree、swiper、loading、steps、tag、tabbar、tabs、popup、dialog、drawer、message、toast、sidebar、dropdown_menu、table、refresh、cell、checkbox、badge；包含 test/theme、test/components/theme 及 theme_acceptance_test，排除 golden 文件/标签）。

Example 命令：`flutter test --dart-define=TDESIGN_DEMO_TEST_MODULES=false test/theme/all_component_web_theme_test.dart test/web_theme_message_test.dart test/web_theme_listener_lifecycle_test.dart test/table/table_page_test.dart --reporter expanded`，通过 `TDESIGN_THEME_REPORT` 输出逐页结果。最终运行显式关闭调试模块；滚动断言允许新版框架在内容高度缩短后先回到真实终点，不跳过页尾。

生产覆盖率按仓库 `tool/check_component_coverage.dart <component> --lcov <path>` 的 LH/LF 计算：

| 模块 | 3.32.0 LH/LF | 3.47.7 LH/LF |
| --- | --- | --- |
| button | 473/478 (98.95%) | 473/478 (98.95%) |
| fab | 213/215 (99.07%) | 213/215 (99.07%) |
| avatar | 290/294 (98.64%) | 290/294 (98.64%) |
| search | 215/221 (97.29%) | 215/221 (97.29%) |
| backtop | 202/202 (100.00%) | 202/202 (100.00%) |
| switch | 391/407 (96.07%) | 391/407 (96.07%) |
| stepper | 376/381 (98.69%) | 376/381 (98.69%) |
| time_counter | 311/315 (98.73%) | 311/315 (98.73%) |
| tree_select | 320/322 (99.38%) | 319/322 (99.07%) |
| swiper | 534/551 (96.91%) | 534/551 (96.91%) |
| loading | 267/267 (100.00%) | 267/267 (100.00%) |
| steps | 267/269 (99.26%) | 267/269 (99.26%) |
| tag | 312/319 (97.81%) | 312/319 (97.81%) |
| tab_bar | 547/555 (98.56%) | 546/555 (98.38%) |
| tabs | 772/790 (97.72%) | 772/790 (97.72%) |
| popup | 498/509 (97.84%) | 496/509 (97.45%) |
| dialog | 303/304 (99.67%) | 303/304 (99.67%) |
| drawer | 212/213 (99.53%) | 211/213 (99.06%) |
| message | 270/273 (98.90%) | 269/273 (98.53%) |
| toast | 239/242 (98.76%) | 239/242 (98.76%) |
| sidebar | 242/243 (99.59%) | 242/243 (99.59%) |
| dropdown_menu | 956/964 (99.17%) | 956/964 (99.17%) |
| table | 432/432 (100.00%) | 432/432 (100.00%) |
| refresh | 206/215 (95.81%) | 206/215 (95.81%) |
| cell | 188/191 (98.43%) | 188/191 (98.43%) |
| checkbox | 361/371 (97.30%) | 360/371 (97.04%) |
| badge | 286/287 (99.65%) | 284/287 (98.95%) |
| theme | 833/853 (97.66%) | 831/853 (97.42%) |

附加检查：css2token 30 项通过；站点桥接 7 项通过；57 份 API 文档已由生成器同步并通过 --check；站点构建通过。Flutter 3.32.0 release Web 构建通过（`--dart-define=TDESIGN_DEMO_TEST_MODULES=false`）。

逐页机器结果：[3.32.0](results-3.32.0.json)、[3.47.7](results-3.47.7.json)。源码指纹：[source-fingerprint.txt](source-fingerprint.txt)，对列出的已修改/新增源码和测试按路径排序，以路径、NUL、文件内容、NUL 拼接后计算 SHA256。覆盖率明细同时保存为 coverage-3.32.0.txt、coverage-3.47.7.txt。原始最终日志保存在本机 `/tmp/tdesign-stable-*`。


## 浏览器证据

本地站点与 release Flutter Web 联调，读取真实 iframe 可访问节点布局：

- 控制器 size-13：48→64，中号头像从 48×48 立即变为 64×64；刷新后仍为 64×64。
- 抽屉保持打开，字号设为大号、行高设为特大后，“菜单一”行高从 56.5→65.5，宽度仍为实例约束的 280，无需关闭重开。
- 证据：[头像](evidence/avatar-size64-web.png)、[已打开抽屉](evidence/drawer-live-font-web.png)。浏览器为补充抽查，57 页全量依据上述自动化矩阵。

## 尚需 CI 的像素层证据

仓库 skill 规定：“自动 Golden 与其他像素比较测试仅在 Flutter 3.32.0 Linux 执行和更新基线”。本机 macOS，Docker 指向未运行的 OrbStack，Linux daemon socket 不存在，故未把本机截图或配置断言当作 Linux Golden 通过。本次不更新 Golden 基线；默认值与显式覆盖已有 Widget 断言，既有默认视觉仍需 Linux CI 比较确认。

早期按标签排除 Golden 时，少量旧文件未标注标签而被误执行，其 macOS 差异不作为验收依据，产物已移出工作区；稳定功能门禁按文件名与标签双重排除像素测试。
