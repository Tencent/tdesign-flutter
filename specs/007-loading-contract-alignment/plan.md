# 实施方案

## 技术方案

### 1. `duration` 默认值 2000 → 800

`t_loading.dart` `_effectiveTheme` 内：

```dart
final effectiveDuration = theme.duration ?? 2000;
```
改为：
```dart
final effectiveDuration = theme.duration ?? 800;
```

同步 `t_loading_theme_data.dart` `duration` 字段 dartdoc 默认说明为 `800`。

### 2. `axis` 默认方向 vertical → horizontal

`t_loading.dart` `_contentWidget` 内：

```dart
final effectiveAxis = theme.axis ?? Axis.vertical;
```
改为：
```dart
final effectiveAxis = theme.axis ?? Axis.horizontal;
```

### 3. 尺寸 API 收敛

移除 `TLoadingSize`，声明式与命令式入口统一为：

```dart
double size = 20.0
```

`size` 只表示指示器外部尺寸：circle 使用 `size` 与 `size / 8` 描边，activity 使用 `size / 2` 半径，point 改为 `size × size` 容器。尺寸不进入 Theme，避免重复状态源。

### 4. Demo 公开矩阵收敛

- 纯图标用一个示例容器展示 circle / spinner / dots / custom，custom 复用现有 `customIcon`。
- 大、中、小三档尺寸合并在一个示例容器中。
- 公开页默认不显示调试模块。

### 5. 文档修正

修正 `tdesign-site/docs/components/loading/README.md` 与 `example/assets/api/loading_api.md`。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `t_loading.dart` | double size 默认、duration 默认、axis 默认、统一指示器尺寸 |
| 组件 | `t_point_indicator.dart` | point 使用方形外部尺寸契约 |
| 组件 | `t_loading_theme_data.dart` | `duration` dartdoc 默认说明 |
| 测试 | `t_loading_test.dart` | 补充 duration/axis/尺寸分支，提升覆盖率 |
| 示例 | `t_loading_page.dart` | 收敛小程序公开 Demo 分组，custom 不单独扩展 |
| 生成示例 | `example/assets/code/` | 随示例源码自动生成 |
| 文档 | `example/assets/api/loading_api.md` | 收敛与 README 一致 |
| 文档 | `tdesign-site/docs/components/loading/README.md` | 修正链接/API 表/示例代码 |

## API 变化

- **breaking change**：`size` 从 `TLoadingSize` 改为 `double` 并移除枚举；`duration` 默认 2000→800、`axis` 默认 vertical→horizontal（更新日志加 `⚠️`）。
- 不新增 Theme size 或 preset 别名；`TLoadingController.show` 保持命令式形态，仅同步 size 类型与默认值。

## 风险与取舍

- `duration`/`axis` 默认值变更属 breaking，需在 PR 更新日志加 `⚠️` 并给出迁移建议。
- 覆盖率基线 86.15%（LF=260, LH=224），需补充 `t_loading_theme_data.dart`（5.0%）、`t_activity_indicator.dart`（80.7%）等用例提升至 ≥95%。
- point 的内部参数原先代表高度且宽度为 3.5 倍；本次改为统一方形外部尺寸，需通过 Golden 核对公开 Demo。

## 验证策略

- Widget 测试覆盖：默认 size==20、非正数断言、默认 duration==800、默认 axis==horizontal、三种 indicator 的统一尺寸，以及 `TLoadingController.show/dismiss` 既有行为。
- 覆盖率：`flutter test --coverage` 统计 `lib/src/components/loading/` 行覆盖率 ≥95%。
- 静态检查：`flutter analyze --fatal-infos` 0 error / 0 warning。
- 示例生成：`dart run tool/generate_example_code.dart --check` 保持 up-to-date。
- 双版本：Flutter 3.32.0 与 latest focused tests 通过。
