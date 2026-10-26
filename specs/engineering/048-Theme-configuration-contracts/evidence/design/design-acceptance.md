# 设计依据复核验收（两处圆角裁定前）

本记录是两处圆角裁定前的检查点，当前增量验收见 [radius-decision-acceptance.md](radius-decision-acceptance.md)；其中源码指纹与388项统计仅对应当时版本。逐项决策见 [mapping-review.md](mapping-review.md)，原始设计变量与组件属性绑定快照已保存。未获得依据的映射恢复原组件默认，不宣称该属性在设计中永远没有 token。

## 结论与行为变化

- 设计真实绑定支持 Button 四档高度和水平padding、Avatar三档外框、BackTop主要外框及gap、TabBar高度、Drawer/Sidebar/Search/Toast等具体padding；保留基础size1..16及其CSS转换。设计的padding、margin可经真实alias使用size，不按名称机械否定。
- Avatar中/小字号与字重从同值Mark改为Title/Medium、Title/Small；大号文字未取得组件节点样式见证，恢复既有20/w600，单列等待确认。
- 删除Badge、Cell、Checkbox的凑数圆角比例及头像组阴影合成别名。已批准的专有几何与既有组件主题入口保留；与新版设计3px/6px等冲突单列。
- Stepper移除全局几何密度倍率；文字读取确证Body样式，真实gap4绑定size2。Switch只由高度绑定控制高度，宽度保持独立；底层轨道、圆形滑块和拖动按实际绘制坐标适配。默认三档仍沿既有FittedBox显示几何，无新增公开导出API。
- Toast文本/横排padding分别绑定左右size8、上下size6；默认22/14改为设计24/16，属于有意默认视觉变化，显式padding保持优先。
- 缺少绑定的图标、命中区域、其他几何恢复既有规格；保留命令式浮层实时继承、字体桥接及表格文字溢出修复。

## 最终检查

| 检查 | Flutter3.32.0 | Flutter3.47.7 |
| --- | --- | --- |
| 相关组件、主题及3个回归调度器自测 | 1796通过 | 1796通过 |
| 57页双模式及桥接/监听/Table页面 | 138通过 | 138通过 |
| 严格分析（--fatal-infos） | 无问题 | 无问题 |
| 28组生产覆盖率（既有门槛95%） | 全部通过 | 全部通过 |
| 独立css2token转换测试 | 30通过 | 30通过 |

57页检查含114组页面/模式，570个类别观测，其中388个适用正向变化断言（每模式194）；另有114组五类同时修改场景，逐适用类别检查。剩余类别不再强制联动，缺口、固有几何、显式约束分别由设计清单说明。链路变化不等于设计绑定证据，固定几何另有反向隔离Widget断言。

新增隔离断言覆盖：Avatar Title与Mark独立；Switch实际绘制高度变化而宽度不变、拖动与零高度；Stepper只有gap响应、无关刻度不缩放几何、组件Theme可覆盖；Toast横纵独立、已打开浮层更新及显式padding；Badge/Checkbox/Cell专有几何、Button/Avatar图标与头像组阴影不被无关全局token接管。新共享断言登记到theme componentTests；调度器自测实际执行。

附加门禁：站点桥接7项通过；57份API由生成器同步并通过--check；Flutter3.32 release Web构建通过；git diff --check通过。修正前的浏览器截图只作历史记录，本轮未将其作为新Toast默认值的视觉验收。

## 生产行覆盖率

| 模块 | 3.32.0 LH/LF | 3.47.7 LH/LF |
| --- | --- | --- |
| button | 473/478 (98.95%) | 473/478 (98.95%) |
| fab | 213/215 (99.07%) | 213/215 (99.07%) |
| avatar | 288/292 (98.63%) | 288/292 (98.63%) |
| search | 208/214 (97.20%) | 208/214 (97.20%) |
| backtop | 202/202 (100.00%) | 202/202 (100.00%) |
| switch | 417/434 (96.08%) | 417/434 (96.08%) |
| stepper | 370/375 (98.67%) | 370/375 (98.67%) |
| time_counter | 306/310 (98.71%) | 306/310 (98.71%) |
| tree_select | 315/317 (99.37%) | 314/317 (99.05%) |
| swiper | 532/549 (96.90%) | 532/549 (96.90%) |
| loading | 266/266 (100.00%) | 266/266 (100.00%) |
| steps | 264/266 (99.25%) | 264/266 (99.25%) |
| tag | 308/315 (97.78%) | 308/315 (97.78%) |
| tab_bar | 547/555 (98.56%) | 546/555 (98.38%) |
| tabs | 769/787 (97.71%) | 769/787 (97.71%) |
| popup | 498/509 (97.84%) | 496/509 (97.45%) |
| dialog | 303/304 (99.67%) | 303/304 (99.67%) |
| drawer | 212/213 (99.53%) | 211/213 (99.06%) |
| message | 269/272 (98.90%) | 268/272 (98.53%) |
| toast | 243/246 (98.78%) | 243/246 (98.78%) |
| sidebar | 239/240 (99.58%) | 239/240 (99.58%) |
| dropdown_menu | 954/962 (99.17%) | 954/962 (99.17%) |
| table | 428/428 (100.00%) | 428/428 (100.00%) |
| refresh | 206/215 (95.81%) | 206/215 (95.81%) |
| cell | 188/189 (99.47%) | 188/189 (99.47%) |
| checkbox | 360/370 (97.30%) | 359/370 (97.03%) |
| badge | 278/279 (99.64%) | 276/279 (98.92%) |
| theme | 832/852 (97.65%) | 830/852 (97.42%) |

## 可复现输入与命令

基线、二进制diff及新增文件指纹见 [design-source-fingerprint.json](design-source-fingerprint.json)。源码和测试范围与本轮改动一致；仅Avatar阴影dartdoc回到既有描述发生在3.32组件功能测试之后，不改变运行代码，按仓库文档变更规则复用功能结果。SDK为本机已安装3.32.0、3.47.7；macOS/DPR1/中文，使用仓库Demo字体。未修改Golden基线。

- 组件：对应SDK `flutter test`，包含27组件目录非golden文件、test/theme、test/components/theme、theme_acceptance_test，以及run_component_regression_test、run_visual_regression_test、check_component_coverage_test；参数 `--exclude-tags golden --coverage --reporter expanded`。工具自测仅校验清单/调度，不运行Golden。原始日志 `/tmp/tdesign-design-components-<version>.log`。
- Example：`TDESIGN_THEME_REPORT=<output> flutter test --dart-define=TDESIGN_DEMO_TEST_MODULES=false test/theme/all_component_web_theme_test.dart test/web_theme_message_test.dart test/web_theme_listener_lifecycle_test.dart test/table/table_page_test.dart --reporter expanded`。完整机器结果 [3.32.0](design-results-3.32.0.json)、[3.47.7](design-results-3.47.7.json)。
- 覆盖率：`dart tool/check_component_coverage.dart <component> --lcov <path>`；完整路径/分子分母见design-coverage-3.32.0.txt、design-coverage-3.47.7.txt。
- 分析：各SDK `flutter analyze --fatal-infos`；独立库 `dart test`；站点 `node --test utils/flutterThemeBridge.test.mjs`；生成器 `node tool/generate_api.mjs --check`；构建 `flutter build web --release --dart-define=TDESIGN_DEMO_TEST_MODULES=false`。

## 明确未完成的设计/视觉证据

Figma调用额度用尽的7页、Table缺少对应节点、未发现绑定的图标/几何和圆角版本冲突，已在mapping-review.md单列，当前均恢复原组件默认；无需为了数字或覆盖率制造映射。当前实现只承诺所读取alias链对应的基础size联动，不新增设计语义alias的独立覆盖API。

仓库 .agents/skills/tdesign-component-align-review/SKILL.md:284 规定“自动 Golden 与其他像素比较测试仅在 Flutter 3.32.0 Linux 执行和更新基线”。本机为macOS，Linux Docker daemon不可用，故未执行Linux像素门禁，也不宣称新Toast默认值和Switch自定义几何已完成像素验收。不存在未获确认的Golden更新。

无公开导出API删除或必填参数增加；Toast默认外观修正有意可见，需发布说明及Linux视觉验收。未提交、推送或部署。
