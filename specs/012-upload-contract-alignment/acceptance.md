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

覆盖列表入口 button semantics、图片/视频提示、失败态不回退预览，以及成功态无大小文案。

## 人工验收

- [ ] 对照小程序 Upload 三组 Demo 截图检查布局、间距和状态

## 未覆盖项与后续工作

- 拖拽排序和平台请求适配不在本次 Flutter 组件契约内。
