# Code Review Report — issue #924

## 审查结论：✅ 通过

## 修改范围

- `tdesign-component/lib/src/components/fab/t_fab.dart`
- `tdesign-component/example/lib/page/t_fab_page.dart`
- `tdesign-component/example/assets/code/fab._buildLongPressFab.txt`
- `tdesign-component/example/assets/api/fab_api.md`
- `tdesign-component/test/t_fab_test.dart`
- `tdesign-site/src/fab/README.md`

## 规范检查

### 1. 类声明与构造方法顺序 ✅

- `TFab` 的构造方法仍位于类声明后的第一段代码位置
- 成员字段全部位于构造方法之后
- 新增注释均使用 `///`

### 2. all_build 配置检查 ✅

- `tdesign-component/demo_tool/all_build.sh` 已包含 `fab` 的 API 生成配置
- 本次未新增组件类或新的 API 生成入口，因此无需修改该脚本

### 3. 主题字段使用检查 ✅ / 存量说明

- 本次新增逻辑未引入硬编码颜色
- `TFab` 的前景色已改为通过 `TTheme.of(context).whiteColor1` 获取
- `TFab` 的阴影改为使用 `TTheme.of(context).shadowsMiddle`

### 4. 文案资源检查 ✅

- `TFab` 组件内部未新增固定文案
- 本次新增字符串仅位于示例页与测试代码中，不属于组件内部资源

## 正确性评审

- `onLongPress` 作为新增公开参数，对原有 `onClick` 行为无破坏
- 内部实现只在 `InkWell` 上新增透传，改动面小且可控
- 已补充示例页测试入口与站点 API 文档，验收链路完整

## 风险评估

### API 兼容性

- 向后兼容：旧代码不传 `onLongPress` 时行为不变
- 新增参数属于能力扩展，符合贡献指南中的“新特性提交”

### 回归风险

- 低风险：仅影响 `TFab` 的手势监听能力
- 通过 widget test 覆盖了点击/长按/双回调共存三个核心场景

## 结论

本次修复满足 issue 诉求，代码与文档闭环完整，可以进入人工验收与 PR 提交流程。
