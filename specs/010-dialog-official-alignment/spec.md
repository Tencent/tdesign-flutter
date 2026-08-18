# Dialog 官方基线对齐

## 背景

Dialog 的核心弹层能力已存在，但默认顶边距和关闭按钮位置与小程序官方实现各差 8px，Example 仅展示 7 个业务化场景，且 Dialog ThemeData 生产源码覆盖基线仅 78.16%。

## 目标

- 对齐小程序官方 Dialog 的默认顶边距和关闭按钮位置。
- 公开展示官方 base、confirm、status、with-image、with-input 和 command 全部 21 个场景。
- Dialog 生产源码 LCOV 达到 95% 以上。

## 非目标

- 不机械新增 Web/小程序的 `top`/`middle`、`cancelBtn`/`confirmBtn`、`buttonLayout` 或 plugin 形态 API。
- 不改变 Dialog 路由、动画、结果返回和遮罩默认语义。

## 范围

### 涉及

- `TDialog` 默认可见样式。
- Dialog ThemeData 与样式 Widget 测试。
- Dialog Example 页、Example 测试和自动生成代码片段。

### 不涉及

- Popup 底层能力和其他组件。
- Dialog 公开 API 签名。

## 行为契约

- 默认 content padding 为 `EdgeInsets.fromLTRB(24, 24, 24, 0)`。
- 关闭按钮距面板 top/end 均为 8px。
- 带图片场景在 Example 层通过任意 `content` Widget 组合；垂直两按钮通过 `actionsWidget` 组合；不扩大基础 API。
- 21 个官方场景均有独立可见触发入口。

## 验收标准

- [x] 顶边距和关闭按钮偏移有 Widget 测试保护。
- [x] Example 测试证明 21 个入口公开可见，并覆盖图片和垂直按钮交互。
- [x] Dialog 生产源码 LCOV `LH/LF >= 95%`。
- [x] Flutter 3.32.0 与 latest 的组件测试、Example 测试和严格 analyze 全部通过。
- [ ] 真实运行时与小程序完成像素对照。
