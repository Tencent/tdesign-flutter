# 验收记录

## 验证环境

- 基线：`origin/develop@bd3574220`
- 低版本：Flutter 3.32.0 / Dart 3.8.0
- 最新稳定版：Flutter 3.44.9 / Dart 3.12.2
- Golden：Linux amd64 / Flutter 3.32.0

## 自动化验证

- [x] Flutter 3.32.0 Form/Input 聚焦组件测试：84 tests
- [x] Flutter 3.32.0 Input Demo 非视觉测试：2 tests
- [x] Flutter 3.32.0 严格 analyze：0 issues
- [x] Flutter 3.44.9 Form/Input 聚焦组件测试：84 tests
- [x] Flutter 3.44.9 Input Demo 非视觉测试：2 tests
- [x] Flutter 3.44.9 严格 analyze：0 issues
- [x] Input 生产源码覆盖率：326/332（98.19%）
- [x] Form 生产源码覆盖率：361/367（98.37%）
- [x] 示例代码生成校验通过
- [x] Linux Light/Dark Golden 更新后无更新参数复跑：4 tests

## 人工验收

- [ ] Figma 目标节点与实际 Demo 同视口视觉复核

Figma 页面当前要求登录，本轮无法读取节点属性或完成像素叠图；自动化与
Linux Golden 已覆盖标签字号、前后插槽间距、目标表单垂直对齐及验证码
分割线契约，但不以此替代设计稿人工验收。
