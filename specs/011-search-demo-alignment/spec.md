# Search 搜索框契约对齐

## 背景

Flutter `TSearchBar` 将小程序 Demo 的 16dp 水平、8dp 垂直留白和页面背景写入了组件，
导致组件默认高度为 56dp，而小程序 Search 组件本体为 40dp。旧实现还公开原始
`InputDecoration`，同时由 `needCancel` 在组件内部管理焦点、取消按钮、清空和失焦，
形成 TDesign 视觉壳与 Material 装饰、业务交互状态并存的多条控制路径。

对照基线：

- Flutter：本分支基于创建时的 `origin/develop`
- TDesign 小程序：2026-08-24 核对的远端 `develop`

## 目标

- Search 组件本体固定遵循 40dp 高度、12dp 内边距、24dp 图标和 Token 字体/颜色。
- Demo 外层单独承担 16dp 水平、8dp 垂直留白及页面背景。
- 右侧操作改为受控插槽语义，组件不隐式清空文本或释放焦点。
- 使用 Flutter 原生 `TextField` 的 controller、focus、formatter、maxlength 和键盘能力。
- Demo 分组、文案、顺序和场景完整覆盖小程序 Search 官方页面。

## 非目标

- 不复制小程序的 `alwaysEmbed`、`cursorSpacing` 等平台参数。
- 不增加 `resultList` 业务数据 API；搜索结果由调用方在 Search 下方组合。
- 不增加结果列表和小程序键盘、光标等平台专属 API。
- 不允许调用方以公开 `InputDecoration` 绕过 TDesign 搜索框视觉契约。

## 行为契约

- 默认组件高度为 40dp，组件不包含页面级外边距、背景或外层 padding。
- 默认方形使用 `radiusDefault`；圆形使用高度的一半作为圆角。
- 搜索与清除图标为 24dp，搜索图标和文本间距为 5dp。
- 输入文字使用 `fontBodyLarge/textColorPrimary`，提示文字使用
  `fontBodyLarge/textColorPlaceholder`，禁用态使用禁用色 Token。
- `controller` 与 `initialValue` 互斥；后者只初始化内部 controller 一次。
- `actionText` 为空时不占空间；点击只调用 `onActionPressed`，不会清空、失焦或改文案。
- 清除图标在 enabled、非 readOnly、clearable 且文本非空时出现。
- `maxLength` 使用 Flutter 原生计数；`maxCharacter` 按 ASCII=1、非 ASCII=2 计数，二者互斥。
- `variant` 可由组件实例覆盖 Theme；`textAlignment` 仅由组件实例控制，默认左对齐。
- Search 结果列表由 Demo 在组件外组合；焦点后显示取消通过受控 action 组合完成。

## Breaking change

- 删除 `needCancel`、`cancelText`、`onCancelPressed`，迁移到
  `actionText/onActionPressed/onFocusChanged` 的受控组合。
- `autoFocus` 更名为 Flutter 原生命名 `autofocus`。
- 删除公开 `decoration`；自定义默认视觉使用 `TSearchBarThemeData`。
- Theme 删除页面级 `backgroundColor/padding/autoHeight`，改为组件级
  `height/inputBackgroundColor/contentPadding` 等字段。
- 默认总高度由 56dp 收敛为组件源码定义的 40dp；页面留白由调用方容器负责。

## 验收标准

- [ ] 组件、Theme、Demo 和测试职责与本契约一致。
- [ ] 官方 Demo 的基础、结果预览、字数限制、取消按钮、形状和居中场景完整。
- [ ] 删除的 API 在全仓库无调用，组件与 Example analyze 零问题。
- [ ] Flutter 3.32.0 与 latest 的 Search 测试通过。
- [ ] Web/手机尺寸截图与小程序源码规格逐项复查。
