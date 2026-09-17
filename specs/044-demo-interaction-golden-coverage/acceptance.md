# 验收记录

## 验证环境

- 分支：`rss1102/test/demo-interaction-goldens`
- 基线提交：`0de62b9b93d9df76f51fb330217f326e7c265f90`
- 权威 Golden：Linux amd64、Flutter 3.32.0、Dart 3.8.0
- latest 兼容检查：macOS、Flutter 3.47.0

## 自动化验证

> 纠正记录：首轮验证仅覆盖 `componentTestManifests` 既有 54 项，遗漏
> `tool/components.json` 中的 Cell、Table、Theme。现已改为以公开 API 清单为独立
> 权威集合，严格核对 API、组件回归和 Golden 覆盖三份集合均为 57 项；首轮
> 54 项结果不作为最终验收结论。

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| 调度器与覆盖矩阵自测 | 通过，9 tests | `tool/components.json`、`componentTestManifests` 与覆盖矩阵均为 57 项且集合严格相等 |
| `dart run tool/run_example_regression.dart` | 通过，260 tests | 完整 Demo 功能与交互回归；覆盖点击、展开、选择、输入、滚动、按压及公开触发项 |
| Cell、Table、Theme 聚焦视觉测试 | 通过，26 tests | 补齐三项遗漏组件的初始态、操作后状态及 light/dark Golden |
| `dart run tool/run_visual_regression.dart` | 通过 | 57 个组件及共享视觉套件全部无更新参数通过 |
| Flutter 3.32.0 `flutter analyze --fatal-infos` | 通过 | 组件包与 example 均 0 issue |
| Flutter 3.47.0 `flutter analyze --fatal-infos --no-pub` | 通过 | 组件包与 example 均 0 issue |
| `dart format --output=none --set-exit-if-changed`、`git diff --check` | 通过 | 26 个 Dart 文件格式稳定，无空白错误 |
| Cell / Table / Theme 生产源码覆盖率 | 通过 | 分别为 190/199（95.48%）、248/248（100%）、454/475（95.58%） |

## 人工验收

- [x] 抽查 Button 按压、Collapse 展开、Toast 打开基线，无裁切、缺字或错误遮罩
- [x] 检查 Icon 与其他 TIcons 场景，图标字体直接从 `tdesign_flutter_icons` 依赖包加载，未复制字体、未升级依赖
- [x] 检查 Table 中文子集字体与 Theme 更新基线，无缺字方框；Theme 陈旧基线更新后立即无更新复跑
- [x] 核对新增交互使用 `tap`、`drag`、`enterText` 或 `startGesture`
- [x] Button 通过保持 pointer down 固定按压态；持续 loading 不保存任意中间帧

## 未覆盖项与后续工作

- 持续循环动画不保存逐帧 Golden；覆盖矩阵记录其确定配置态或功能测试边界。
- 仅产生回调且没有视觉变化的操作不复制相同快照。
