### 🤔 这个 PR 的性质是？
> 勾选规则:
> 1.只要有新增参数，就勾选”新特性提交“
> 2.只修改内部bug，未新增参数，才勾选”日常 bug 修复“
> 3.其他选项视具体改动判断

- [ ] 日常 bug 修复
- [x] 新特性提交
- [ ] 文档改进
- [ ] 演示代码改进
- [x] 组件样式/交互改进
- [ ] CI/CD 改进
- [ ] 重构
- [ ] 代码风格优化
- [x] 测试用例
- [ ] 分支合并
- [ ] 其他

### 🔗 相关 Issue

https://github.com/Tencent/tdesign-flutter/issues/924

Fixes #924

### 💡 需求背景和解决方案

1. 业务需要在悬浮按钮上响应长按（快捷菜单、上下文操作等），而 `TFab` 此前未透出长按回调。
2. 为 `TFab` 增加可选参数 `onLongPress`（`VoidCallback?`），并传给根组件 `InkWell` 的 `onLongPress`。短按仍使用原有 `onClick` → `onTap`。
3. 同时将 FAB 图标反色与投影改为使用主题 token（`fontWhColor1`、`shadowsMiddle`），以满足仓库静态检查并与全局阴影样式对齐（视觉上可能与旧版手写投影略有差异）。
4. 用法示例：

```dart
TFab(
  onClick: () {},
  onLongPress: () {
    // 长按逻辑
  },
)
```

5. 投影与反色随主题 token，与手写投影相比可能有细微视觉差异；若无交互变更截图需求可省略。

### 📝 更新日志

- feat(TFab): 新增 `onLongPress` 可选回调；图标反色与投影改为主题 token（`fontWhColor1`、`shadowsMiddle`）

- [ ] 本条 PR 不需要纳入 Changelog

### ☑️ 请求合并前的自查清单

⚠️ 请自检并全部**勾选全部选项**。⚠️

- [x] pr目标分支为develop分支，请勿直接往main分支合并
- [x] 标题格式为：`组件类名`: 修改描述（示例：`TBottomTabBar`: 修复iconText模式，底部溢出2.5像素）
- [x] ”相关issue“处带上修复的issue链接
- [x] 相关文档已补充或无须补充
