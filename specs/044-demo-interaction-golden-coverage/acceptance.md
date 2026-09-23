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
>
> 字体纠正记录：后续逐张复核发现 Theme、Checkbox、Tag 等旧基线仍有中文缺字
> 方框，原“无缺字”人工结论无效。共享字体现按组件、公开 Example 与测试源码全集
> 重建；Material Icons、`tdesign_flutter_icons` 与 TCloudNumber 均由共享工具统一
> 加载，并新增源码字符清单与 OTF `cmap` 的自动完整性检查。

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/tool` | 通过，24 tests | 57 项集合严格相等；Demo / 组件 Golden 类型明确；每个组件都有 Demo 套件和成对 light/dark PNG；所有 Golden 文件已反向登记；禁止宽松比较器 |
| `dart run tool/run_example_regression.dart` | 通过，260 tests | 完整 Demo 功能与交互回归；覆盖点击、展开、选择、输入、滚动、按压及公开触发项 |
| Cell、Table、Theme 聚焦视觉测试 | 通过，26 tests | 补齐三项遗漏组件的初始态、操作后状态及 light/dark Golden |
| `flutter test --no-pub --tags golden test`（example） | 通过，499 tests | Linux Flutter 3.32.0；57 个组件的 Demo 初始态和已登记交互态全部以默认精确比较器通过 |
| 18 个 `test/components/**/*_golden_test.dart` 批量执行 | 通过，45 tests | Linux Flutter 3.32.0；包含此前未调度的 Base、Refresh、Popup/Progress、Upload；更新后已无更新参数全量复跑 |
| Flutter 3.32.0 `flutter analyze --fatal-infos` | 通过 | 组件包与 example 均 0 issue |
| Flutter 3.47.0 `flutter analyze --fatal-infos --no-pub` | 通过 | 组件包与 example 均 0 issue |
| `dart format --output=none --set-exit-if-changed`、`git diff --check` | 通过 | 本 PR Dart 文件格式稳定，无空白错误 |
| Cell / Table / Theme 生产源码覆盖率 | 通过 | 分别为 190/199（95.48%）、248/248（100%）、454/475（95.58%） |

## 人工验收

- [x] 重新抽查 Button 按压、Collapse 展开、Toast 打开基线，无裁切、缺字或错误遮罩
- [x] 检查 Icon 与其他 TIcons 场景，图标字体直接加载锁定的 `tdesign_flutter_icons 0.0.6`，未复制字体、未升级依赖
- [x] 检查 Theme、Checkbox、Tag、Toast、Stepper、Table 修复后基线；共 62 张图片内容更新并完成全量严格复跑
- [x] Cell、Radio 已移除 1.5% 像素容差；空格、标点或任意其他像素变化均会使默认比较器失败
- [x] 核对新增交互使用 `tap`、`drag`、`enterText` 或 `startGesture`
- [x] Button 通过保持 pointer down 固定按压态；持续 loading 不保存任意中间帧
- [x] Badge 已补独立公开 Demo light/dark 基线；57/57 组件均有 Demo 类型视觉套件
- [x] Base、Refresh、Popup/Progress、Upload 的既有组件 Golden 文件全部进入调度器；共享组件矩阵按执行键去重
- [x] Refresh 组件 Golden 载入确定性 CJK 字体，原缺字方框已替换为真实中文并完成精确复跑

## 未覆盖项与后续工作

- 持续循环动画不保存逐帧 Golden；覆盖矩阵记录其确定配置态或功能测试边界。
- 仅产生回调且没有视觉变化的操作不复制相同快照。
