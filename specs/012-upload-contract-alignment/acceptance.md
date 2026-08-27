# 验收记录

## 验证环境

- 分支：`rss1102/style/upload-miniprogram-alignment`
- 提交：当前 PR 的 Upload 独立提交
- Flutter/Dart：Flutter 3.32.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze` | 通过 | 组件包 |
| `flutter test test/components/upload/t_upload_test.dart test/components/upload/t_upload_golden_test.dart` | 通过 | Upload 回归 |
| `flutter test test/upload_page_test.dart` | 通过 | Example Demo 分组与布局 |
| `flutter build web` | 通过 | Example Web 构建 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例资产 |
| `node scripts/check-flutter-component-contracts.mjs` | 通过 | 56 个站点路由 |

覆盖列表入口 button semantics、按钮顺序、文件行容器 token / 内边距、24dp 状态图标、18dp 删除图标、失败文字颜色、所有状态的统一文件点击、宫格 / 列表长按排序、禁用态拖拽拦截，以及成功态无大小文案。

Upload Widget 与 Golden 测试已接入 CNB、GitHub 的 Flutter 3.32.0 Linux 测试流水线，作为状态文案、拖拽行为和视觉基线的持续回归门禁。

## 人工验收

- [ ] 对照小程序 Upload 三组 Demo 截图检查布局、间距和状态

## 未覆盖项与后续工作

- 平台请求适配不在本次 Flutter 组件契约内。
- 小程序的拖拽振动和过渡配置属于平台细节，本次不复制。
