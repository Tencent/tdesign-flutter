# TText DefaultTextStyle 解析修复

## 背景

当调用方提供显式 Material TextTheme 时，MaterialApp 仍会自动向子树注入
DefaultTextStyle。现有 tExplicitDefaultTextStyle 因检测到显式 TextTheme 就直接返回
该继承样式，导致 TTextResolve 先采用 bodyLarge 后又被自动注入的 bodyMedium
覆盖。组件声明的正文层级因此可能被意外压小。

## 目标

- 区分 Material 自动注入的 DefaultTextStyle 与调用方显式创建的局部样式。
- 保持 TText 的既有主题优先级和公开 API 不变。
- 完整扫描组件功能测试与全部 Flutter 3.32 Linux Golden，确认共享修复没有遗漏影响。

## 非目标

- 不新增或调整 TText 公共参数。
- 不改变 TextTheme、TTextThemeData 和实例 style 的既有优先级。
- 不借此调整无关组件的字体设计。

## 范围

### 涉及

- TThemeContextExtension.tExplicitDefaultTextStyle 的隐式样式过滤。
- TTextResolve 的回归测试。
- 全组件功能回归、覆盖率和全量 Golden 扫描。

### 不涉及

- 组件 Demo 结构和公开 API。
- 与本次样式解析无关的 Theme 字段。

## 行为契约

- Material 自动注入且与当前 ThemeData.textTheme 成员一致的 DefaultTextStyle 不进入
  显式覆盖链。
- 缺少 Material 宿主时的 Flutter 诊断 fallback 样式不进入显式覆盖链。
- 调用方通过 DefaultTextStyle Widget 设置的局部样式继续覆盖 Material TextTheme
  与 TDesign Token。
- 最终优先级保持：实例配置 > TTextThemeData > 局部显式 DefaultTextStyle >
  显式 Material TextTheme > TDesign Token。

## 验收标准

- [ ] 显式 TextTheme.bodyLarge 不再被自动 bodyMedium 覆盖。
- [ ] 局部显式 DefaultTextStyle 仍可覆盖文字字号和颜色。
- [ ] Flutter 3.32.0 与 latest 的严格 analyze 和全组件功能回归通过。
- [ ] Flutter 3.32.0 Linux 的全部 Golden 完整扫描并记录所有预期变化。
- [ ] 无公共 API 和生成文档漂移。
