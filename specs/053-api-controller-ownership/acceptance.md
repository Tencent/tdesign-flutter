# Acceptance

## 当前修复批次

基线：186541d456b96955d037376012111965f2d17d9d。修复再次整体 review 确认的 Message、SwipeCell、Swiper、Popup 问题，并补齐 Loading/Toast 的首次绘制前卸载清理及 Theme extension 文档。历史审查表 api-review.md 保留原审查时间；当前逐项结论见 api-review-current.md。

- Flutter 3.32.0 / 3.47.6：全 57 项、116 个唯一登记组件测试文件，各 2766 passed。
- 双版本 Demo 各 275 passed，调度器自测各 20 passed，示例片段 --check 通过；flutter analyze --fatal-infos 均零诊断。
- 57 项生产源码覆盖率均 >=95%，最低 95.53%；逐项 LH/LF 见下表。
- 新测试位于已经登记的组件测试文件，覆盖失败替换、相同无效配置重试、原绑定存活、未绘制 Overlay 卸载、关闭通知幂等以及路由被完全遮挡和关闭后重新打开。Theme 文档测试位于已经登记的 runner 自测文件。
- 57 份 API 文档重新生成；282 项直接组件声明与 12 项直接 Theme 基础类型的范围保持，另验证 12 个公开 Theme extension 均有章节。生成成员签名与 dartdoc，过滤私有成员及根出口 show/hide。不承诺第三方或传递 export 整个依赖图的文档完整性。
- 所有当前源码、测试与工具 Dart 文件和 3.32 独立副本对应文件一致。
- 本批次没有视觉源码变化，不在 macOS 运行或更新 Golden；当前 head 的远端 Linux Golden 等待推送后验证。

## 契约与迁移

SwipeCell 失败替换保留旧绑定，卸载清理实际 owner；Swiper 相同无效配置重试仍拒绝，旧 Controller 继续有效。Message 关闭句柄和 onDismissed 最多一次；Loading/Toast 所属 Overlay 卸载清理，普通页面离开但所属 Overlay 仍存在时不关闭有效全局浮层。Popup/PickerPopup/Drawer 使用 maintainState，默认 true 保持原路由能力；旧 destroyOnClose 值迁移时取反，无兼容别名。maintainState 控制不可见路由的 State 保留，不承诺关闭后保留；两个取值关闭再打开都重建 State。Radio 重选、Checkbox 聚合半选和 Input/Textarea 各自边框职责保持。

## 执行方式

3.32 SDK：/Users/rs/fvm/versions/3.32.0，独立副本 /private/tmp/api-foundation-3.32/tdesign-component。最新版 SDK：/private/tmp/tdesign-flutter-sdk-3.47.6，当前工作树 tdesign-component。

严格分析使用 flutter analyze --fatal-infos；组件使用 flutter test --no-pub --exclude-tags demo --coverage，参数为 componentTestManifests 去重后的 116 个登记文件；使用 check_component_coverage.run 对全部 57 项检查 >=95%。Demo 使用 dart run tool/run_example_regression.dart；runner 自测为 check_component_coverage_test.dart、run_component_regression_test.dart、run_visual_regression_test.dart；示例使用 dart run tool/generate_example_code.dart --check；API 使用 node tool/generate_api.mjs。完整日志位于 /private/tmp/api-lifecycle-{analyze,components,coverage,demo,runners,snippets}-{3.32.0,3.47.6}.log 和 /private/tmp/api-lifecycle-generate-final.log。

生产源码 SHA256：5cc9d77a78edc78b7883a0bdbcf4d8d473082ea227cc5bc651ccda33d48f5551。源码及测试工具指纹：8d8d65d663f1836cd510b9227970e44126578f5ffb5740b1b6cf92a5250aece8。结构化证据见 validation-results.json。

## 全 57 项覆盖率

| 组件 | Flutter 3.32.0 | Flutter 3.47.6 |
|---|---|---|
| avatar | 273/284 (96.13%) | 273/284 (96.13%) |
| action_sheet | 498/516 (96.51%) | 500/516 (96.9%) |
| badge | 279/280 (99.64%) | 279/280 (99.64%) |
| cell | 188/189 (99.47%) | 188/189 (99.47%) |
| backtop | 185/185 (100.0%) | 185/185 (100.0%) |
| button | 459/468 (98.08%) | 459/468 (98.08%) |
| cascader | 263/266 (98.87%) | 262/266 (98.5%) |
| picker | 382/388 (98.45%) | 382/388 (98.45%) |
| progress | 611/619 (98.71%) | 611/619 (98.71%) |
| date_time_picker | 688/708 (97.18%) | 687/708 (97.03%) |
| calendar | 622/630 (98.73%) | 622/630 (98.73%) |
| tag | 306/313 (97.76%) | 306/313 (97.76%) |
| popover | 629/639 (98.44%) | 629/639 (98.44%) |
| checkbox | 356/366 (97.27%) | 355/366 (96.99%) |
| collapse | 218/226 (96.46%) | 218/226 (96.46%) |
| divider | 104/104 (100.0%) | 104/104 (100.0%) |
| empty | 33/33 (100.0%) | 33/33 (100.0%) |
| image_viewer | 237/242 (97.93%) | 237/242 (97.93%) |
| dialog | 285/289 (98.62%) | 285/289 (98.62%) |
| dropdown_menu | 957/965 (99.17%) | 957/965 (99.17%) |
| drawer | 202/203 (99.51%) | 201/203 (99.01%) |
| fab | 210/212 (99.06%) | 210/212 (99.06%) |
| footer | 51/51 (100.0%) | 51/51 (100.0%) |
| indexes | 706/739 (95.53%) | 706/739 (95.53%) |
| image | 131/131 (100.0%) | 131/131 (100.0%) |
| refresh | 195/201 (97.01%) | 195/201 (97.01%) |
| rate | 355/361 (98.34%) | 355/361 (98.34%) |
| result | 66/67 (98.51%) | 65/67 (97.01%) |
| tab_bar | 500/509 (98.23%) | 499/509 (98.04%) |
| navbar | 160/160 (100.0%) | 160/160 (100.0%) |
| tabs | 765/783 (97.7%) | 765/783 (97.7%) |
| swiper | 477/493 (96.75%) | 477/493 (96.75%) |
| skeleton | 140/141 (99.29%) | 138/141 (97.87%) |
| time_counter | 303/307 (98.7%) | 303/307 (98.7%) |
| icon | 17/17 (100.0%) | 17/17 (100.0%) |
| link | 113/115 (98.26%) | 113/115 (98.26%) |
| loading | 274/278 (98.56%) | 274/278 (98.56%) |
| message | 248/251 (98.8%) | 247/251 (98.41%) |
| notice_bar | 308/319 (96.55%) | 308/319 (96.55%) |
| popup | 498/509 (97.84%) | 496/509 (97.45%) |
| radio | 272/272 (100.0%) | 271/272 (99.63%) |
| table | 428/428 (100.0%) | 428/428 (100.0%) |
| text | 132/134 (98.51%) | 132/134 (98.51%) |
| search | 190/195 (97.44%) | 190/195 (97.44%) |
| steps | 248/249 (99.6%) | 248/249 (99.6%) |
| sidebar | 226/226 (100.0%) | 226/226 (100.0%) |
| slider | 360/363 (99.17%) | 360/363 (99.17%) |
| stepper | 353/358 (98.6%) | 353/358 (98.6%) |
| switch | 356/372 (95.7%) | 356/372 (95.7%) |
| tree_select | 305/307 (99.35%) | 304/307 (99.02%) |
| upload | 396/411 (96.35%) | 396/411 (96.35%) |
| form | 385/390 (98.72%) | 385/390 (98.72%) |
| input | 315/319 (98.75%) | 315/319 (98.75%) |
| textarea | 104/105 (99.05%) | 104/105 (99.05%) |
| theme | 307/315 (97.46%) | 307/315 (97.46%) |
| toast | 236/237 (99.58%) | 236/237 (99.58%) |
| swipe_cell | 303/314 (96.5%) | 303/314 (96.5%) |
