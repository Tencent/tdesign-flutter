# 验收记录

## 验证环境

- 分支：`develop`
- 工作区状态：包含本 Spec 对应的未提交实现变更
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.x（预期环境）
- Node/pnpm：使用仓库现有 `tdesign-site/node_modules` 验证

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `git diff --check` | 通过 | 未发现空白错误 |
| `node scripts/check-flutter-component-contracts.mjs` | 通过 | 当前 56 个站点路由均对应源码、Example 和文档 |
| `cd tdesign-site && pnpm site` | 通过 | Vite production build 成功 |
| `bash tdesign-component/demo_tool/all_build.sh` | 通过 | manifest 驱动的 57 项 API 文档生成完成 |
| `flutter analyze`（Example） | 通过 | 无诊断问题 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例代码片段保持同步 |
| `flutter build web --release` | 通过 | Example Web release build 成功 |
| `flutter build apk --release` | 通过 | Example Android release APK 构建成功 |
| `flutter build ios --no-codesign --release` | 通过 | Example iOS release build 成功 |

## 人工验收

- [x] `md-to-vue.ts` 位于 `tdesign-site/site/scripts`。
- [x] 站点路由通过 `@component-docs` 指向 `docs/components`。
- [x] Flutter design 文档已存在于 `tdesign-site/docs/design/flutter`。

## 未覆盖项与后续工作

- Example 中未接入且已被上游删除的 `WebMdTool` 不再保留；站点构建覆盖组件文档读取链路。
