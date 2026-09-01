# Dialog 官方基线对齐

## 背景

Dialog 的核心弹层能力已存在，但默认顶边距和关闭按钮位置与小程序官方实现各差 8px，居中 Popup 的 240×240 默认尺寸还会把 311dp Dialog 压窄并裁切输入框。Example 仅展示 7 个业务化场景，且 Dialog ThemeData 生产源码覆盖基线仅 78.16%。

## 目标

- 对齐小程序官方 Dialog 的默认顶边距和关闭按钮位置。
- 公开展示官方 base、confirm、status、with-image、with-input、command 和自定义按钮全部 22 个场景。
- 对齐 Figma Demo 的页面文案、状态分组说明和各类 Dialog 打开态。
- Dialog 生产源码 LCOV 达到 95% 以上。

## 非目标

- 不机械新增 Web/小程序的 `top`/`middle`、`cancelBtn`/`confirmBtn`、`buttonLayout` 或 plugin 形态 API。
- 不改变 Dialog 路由、动画、结果返回和遮罩默认语义。

## 范围

### 涉及

- `TDialog` 默认可见样式。
- Dialog ThemeData 与样式 Widget 测试。
- Dialog Example 页、Example 测试和自动生成代码片段。

### 最小配套

- Popup 只新增默认关闭的 center `shrinkWrap` 尺寸模式，Dialog 内部启用；普通 Popup 的 240×240 默认契约保持不变。
- Dialog 公开构造和展示 API 签名保持不变。

## 行为契约

- 默认 content padding 为 `EdgeInsets.fromLTRB(24, 24, 24, 0)`。
- Dialog 路由面板按内容自适应，默认宽度为 311dp，不再继承 Popup 的 240×240 固定尺寸。
- 关闭按钮距面板 top/end 均为 8px。
- 默认标题和正文样式保留应用 `TextTheme` 的主字体与 fallback，避免弹层丢失应用级字体覆盖。
- 带图片场景在 Example 层通过任意 `content` Widget 组合；垂直两按钮通过 `actionsWidget` 组合；不扩大基础 API。
- 带图片场景使用 160dp 设计高度；输入场景复用 `TInput`，保留灰色输入壳、16dp 顶间距和清除能力，不使用原生透明 `TextField` 近似。
- “文字按钮”使用 32dp 顶间距、56dp 高的贴边文字操作区和 0.5dp 分隔线；基础按钮继续使用 24dp 操作区内边距。
- 三个及以上操作按主操作优先从上到下展示；确认类纯标题场景使用浅色确认按钮。
- “组件状态”内逐项展示文字按钮、水平基础按钮、垂直基础按钮、多按钮和关闭按钮说明，不以一个笼统说明替代。
- 22 个官方场景均有独立可见触发入口；小程序 `openType` 通过 Flutter 既有 `TDialogAction` 自定义子项表达，不新增跨端专用 API。
- 公开页在“组件用法”后结束，不展示仅供内部验证的“单元测试”模块。

## 验收标准

- [x] 顶边距和关闭按钮偏移有 Widget 测试保护。
- [x] Example 测试证明 22 个入口公开可见，并覆盖图片、垂直按钮和自定义操作项交互。
- [x] Example 测试逐项打开并关闭 22 个入口，覆盖输入、文字按钮、图片、主操作顺序和返回结果。
- [x] Dialog 生产源码 LCOV `LH/LF >= 95%`。
- [x] Flutter 3.32.0 与 latest 的组件测试、Example 测试和严格 analyze 全部通过。
- [x] Flutter 3.32 Linux 亮暗主题 12 个 Golden 稳定复跑，真实 Web 运行时完成输入、图片、文字按钮、多按钮和关闭按钮人工对照。
