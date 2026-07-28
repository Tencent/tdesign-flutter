### 🤔 这个 PR 的性质是？
> 勾选规则:
> 1.只要有新增参数，就勾选”新特性提交“
> 2.只修改内部bug，未新增参数，才勾选”日常 bug 修复“
> 3.其他选项视具体改动判断

- [ ] 日常 bug 修复
- [x] 新特性提交
- [ ] 文档改进
- [x] 演示代码改进
- [x] 组件样式/交互改进
- [ ] CI/CD 改进
- [ ] 重构
- [ ] 代码风格优化
- [x] 测试用例
- [ ] 分支合并
- [ ] 其他

### 🔗 相关 Issue

需求来源：悬浮按钮需要长按扩展能力。

https://github.com/Tencent/tdesign-flutter/issues/924

### 💡 需求背景和解决方案

**问题**：`TFab` 仅支持单击 `onClick`，业务无法实现长按菜单等交互。

**方案**：

- 新增可选参数 `onLongPress`（`VoidCallback?`），并传给内部 `InkWell.onLongPress`。
- 将原先硬编码的反色与阴影改为 `TTheme` 中的 `textColorAnti` 与 `shadowsMiddle` / `shadowsBase`，满足主题规范与强制检查。

**用法示例**：

```dart
TFab(
  theme: TFabTheme.primary,
  text: '操作',
  onClick: () {},
  onLongPress: () {},
)
```

### 📝 更新日志

- feat(TFab): 新增 `onLongPress`，支持长按回调；图标反色与投影改为主题 token。

- [ ] 本条 PR 不需要纳入 Changelog

### ☑️ 请求合并前的自查清单

⚠️ 请自检并全部**勾选全部选项**。⚠️

- [x] pr目标分支为develop分支，请勿直接往main分支合并
- [x] 标题格式为：`组件类名`: 修改描述（示例：`TBottomTabBar`: 修复iconText模式，底部溢出2.5像素）
- [x] ”相关issue“处带上修复的issue链接
- [x] 相关文档已补充或无须补充
