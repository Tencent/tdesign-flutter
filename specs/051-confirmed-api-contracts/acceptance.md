# 当前验收记录

2026-10-05。基线 c37107882901646af41f84067d883901d56da5cd；本轮实现覆盖 8 个组件，全部 57 项重新运行登记回归。

## 版本与命令

- Flutter 3.32.0：`/Users/rs/fvm/versions/3.32.0/bin/flutter`，独立副本 `/private/tmp/api-confirmed-3.32/tdesign-component`。
- Flutter 3.47.6：`/private/tmp/tdesign-flutter-sdk-3.47.6/bin/flutter`，API worktree。
- 两份源码的 1,033 个 Dart 文件逐文件一致；当前源码指纹与逐项覆盖率见 `validation-results.json`。
- `flutter analyze --fatal-infos`：两版本均无诊断。
- 按当前 componentTestManifests 的 57 项、116 个唯一文件执行 `flutter test --no-pub --exclude-tags demo --coverage <登记文件>`：两版本均通过，输出统计各 2,745。
- `dart run tool/run_example_regression.dart`：双版本通过，输出统计各 275；不包含 Golden。
- `flutter test --no-pub test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart`：各 19 通过，CI 登记检查通过。
- 全部 57 项由 `check_component_coverage.run` 针对本轮全量 LCOV 校验：两版本最低 95.53%，全部 >=95%。
- `node tool/generate_api.mjs`：57 份 API 生成成功，新名称、BackTop 两阶段与 Refresh 单绑定说明已核对。
- `dart run tool/generate_example_code.dart` 后，两版本 `--check` 通过；旧明确迁移名称不再存在于现行 Dart/生成 API/示例。
- `git diff --check` 通过。

## 边界行为

BackTop 验证激活先于滚动、成功后才完成、重复点击不重复激活、无 Controller 不完成，以及中断、替换、解绑和卸载不误报。Refresh 验证重复绑定抛 StateError 并保留原绑定、非所有者解绑无效、Controller 替换与卸载释放对应绑定、释放后可复用。现有选择上限、TabBar 重选/事件顺序、Drawer 点击、Popover 长按、Popup 蒙层和 NoticeBar 父子交互用例随命名迁移通过。

## 57 项覆盖率

| 组件 | 3.32.0 LH/LF | 3.47.6 LH/LF |
| --- | --- | --- |
| avatar | 273/284 (96.13%) | 273/284 (96.13%) |
| action_sheet | 498/516 (96.51%) | 500/516 (96.9%) |
| badge | 279/280 (99.64%) | 279/280 (99.64%) |
| cell | 188/189 (99.47%) | 188/189 (99.47%) |
| backtop | 185/185 (100.0%) | 185/185 (100.0%) |
| button | 458/467 (98.07%) | 458/467 (98.07%) |
| cascader | 263/266 (98.87%) | 262/266 (98.5%) |
| picker | 382/388 (98.45%) | 382/388 (98.45%) |
| progress | 611/619 (98.71%) | 611/619 (98.71%) |
| date_time_picker | 688/708 (97.18%) | 687/708 (97.03%) |
| calendar | 622/630 (98.73%) | 622/630 (98.73%) |
| tag | 306/313 (97.76%) | 306/313 (97.76%) |
| popover | 622/632 (98.42%) | 622/632 (98.42%) |
| checkbox | 356/366 (97.27%) | 355/366 (96.99%) |
| collapse | 218/226 (96.46%) | 218/226 (96.46%) |
| divider | 104/104 (100.0%) | 104/104 (100.0%) |
| empty | 33/33 (100.0%) | 33/33 (100.0%) |
| image_viewer | 237/242 (97.93%) | 237/242 (97.93%) |
| dialog | 285/289 (98.62%) | 285/289 (98.62%) |
| dropdown_menu | 944/952 (99.16%) | 944/952 (99.16%) |
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
| swiper | 476/493 (96.55%) | 476/493 (96.55%) |
| skeleton | 140/141 (99.29%) | 138/141 (97.87%) |
| time_counter | 303/307 (98.7%) | 303/307 (98.7%) |
| icon | 17/17 (100.0%) | 17/17 (100.0%) |
| link | 113/115 (98.26%) | 113/115 (98.26%) |
| loading | 261/261 (100.0%) | 261/261 (100.0%) |
| message | 243/246 (98.78%) | 242/246 (98.37%) |
| notice_bar | 308/319 (96.55%) | 308/319 (96.55%) |
| popup | 498/509 (97.84%) | 496/509 (97.45%) |
| radio | 272/272 (100.0%) | 271/272 (99.63%) |
| table | 428/428 (100.0%) | 428/428 (100.0%) |
| text | 132/134 (98.51%) | 132/134 (98.51%) |
| search | 190/195 (97.44%) | 190/195 (97.44%) |
| steps | 247/248 (99.6%) | 247/248 (99.6%) |
| sidebar | 226/226 (100.0%) | 226/226 (100.0%) |
| slider | 360/363 (99.17%) | 360/363 (99.17%) |
| stepper | 353/358 (98.6%) | 353/358 (98.6%) |
| switch | 356/372 (95.7%) | 356/372 (95.7%) |
| tree_select | 305/307 (99.35%) | 304/307 (99.02%) |
| upload | 396/411 (96.35%) | 396/411 (96.35%) |
| form | 382/387 (98.71%) | 382/387 (98.71%) |
| input | 315/319 (98.75%) | 315/319 (98.75%) |
| textarea | 104/105 (99.05%) | 104/105 (99.05%) |
| theme | 307/315 (97.46%) | 307/315 (97.46%) |
| toast | 225/226 (99.56%) | 225/226 (99.56%) |
| swipe_cell | 300/312 (96.15%) | 300/312 (96.15%) |

## 迁移示例

```dart
TBackTop(
  controller: scrollController,
  onPressed: () => debugPrint('激活回顶'),
  onCompleted: () => debugPrint('成功回到顶部'),
)
```

原带 Controller 的 onPressed 完成业务改为 onCompleted；各旧名称按 spec.md 的映射直接替换。每个同时挂载的 Refresh 使用独立 Controller。

## 边界

只完成已确认契约。Button 启用规则、Radio 重选、Checkbox 三态、Steps 模型及未验证 Loading 风险没有改变。无视觉绘制或资源变化，本轮未运行/更新 Golden，不宣称视觉对齐。远端 CI 需针对推送后 head 独立确认，不能用旧 head 的 CI 代替。
