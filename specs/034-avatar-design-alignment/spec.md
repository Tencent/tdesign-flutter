# Avatar 设计对齐

## 背景

Avatar 公开 Demo 的字符样式、头像组数量、尺寸与操作示例和移动端设计稿存在差异；组件使用 `variant` 表达形状，语义不准确，字符内容也无法通过实例参数使用主题颜色。

## 目标

- 按移动端设计稿统一公开 Demo 的组件类型、特殊类型和尺寸结构。
- 为头像提供语义明确且兼容已有调用的形状、颜色和文字样式能力。
- 为头像组提供实例尺寸和层叠方向控制。
- 建立组件行为、Demo 结构和明暗主题 Golden 回归。

## 非目标

- 不内置网络请求、图片缓存或成员状态管理。
- 不机械复制其他端的图片加载、徽标或字符串 URL API。
- 不删除已有 `variant` 兼容入口。

## 范围

### 涉及

- `TAvatar`、`TAvatarGroup`、`TAvatarThemeData` 及类型定义。
- Avatar 公开 Demo、生成代码片段和 API 文档。
- 组件测试、Demo 测试、Golden 与集中回归登记。

### 不涉及

- Badge 组件内部实现。
- 全局主题 token 定义。

## 行为契约

- `shape` 控制头像形状，实例值优先于 Theme；旧 `variant` 保持可用但标记弃用，两者不得同时传入。
- `backgroundColor`、`foregroundColor`、`textStyle` 的实例值优先于组件 Theme；字符头像按大、中、小尺寸默认使用 20、16、14 字号和 Semibold 字重。
- `TAvatarGroup.dimension` 仅控制组成员外框尺寸，实例值优先于共享 Theme；`cascading` 明确左侧或右侧成员的绘制层级。
- 图片加载失败时保留自定义内容；无点击回调时不创建点击行为。
- Demo 展示两种基础形状、三种徽标、五头像加溢出、五头像加操作以及三档尺寸。

## 验收标准

- [ ] 组件和 Demo 功能测试通过，Avatar 手写生产代码行覆盖率不低于 95%。
- [ ] Flutter 3.32.0 与 latest 的测试和静态分析均通过且零告警。
- [ ] Flutter 3.32 Linux 明暗主题 Golden 与设计稿人工比对通过，无缺字方框。
- [ ] 示例代码片段与 API 文档由源码重新生成并通过检查。
- [ ] Avatar 已登记到集中组件、Demo 和视觉回归清单。
