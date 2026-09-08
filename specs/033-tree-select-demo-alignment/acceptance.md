# 验收记录

- Flutter 原 PR 基线：`6a69569c104f6576fd6b39253eedbe48faa2b75c`
- 当前 `develop` 基线：`origin/develop`（合并时领先原 PR 23 个提交）
- 小程序基线：`b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`
- 公开运行页：`https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/tree-select/tree-select.html`
- Figma 文件：`TDesign for mobile`，页面 `TreeSelect 树形选择器`。
- Figma Demo 节点：`28591:40742`，尺寸 `378 x 1510`。
- Figma 两列组件变体：`27387:23982`，尺寸 `375 x 336`。
- Figma 一级列变体：`27449:25981`，宽度 `103`。
- API Review：完整路径值、`value + onChanged` 受控模式和数据深度驱动列数已收敛；
  不增加公开参数。

## 验证结果

- 本地 merge commit：`bad8fea4`，完成目标分支与 `origin/develop` 的冲突整合。
- Flutter 3.32.0：TreeSelect 组件测试 13 项、Demo 测试 6 项、集中测试清单工具
  13 项全部通过；`flutter analyze` 为 `No issues found`。
- Flutter 3.47.0（latest）：TreeSelect 组件测试 13 项、Demo 测试 6 项全部通过；
  `flutter analyze` 为 `No issues found`。
- 组件生产代码覆盖率：`286/288 = 99.31%`，高于 95% 门槛。
- `dart run tool/generate_example_code.dart --check` 通过。
- Linux `amd64` + Flutter 3.32.0 重新生成明暗两张 Demo Golden，并在同一容器
  去掉 `--update-goldens` 复跑，2 项全部通过。
- TreeSelect 专用字体子集已覆盖页面可见文案，人工查看明暗 Golden 无缺字符号；
  子集 SHA-256 为
  `1cbb5418c4cd91a103deb2a28f68dacb1e895a6efcb8f2f5e8198d67d38ac7ca`。
- 原 PR 在 2026-09-01 的 CI 结果不代表当前合并与修改后的结果；推送后的远端 CI
  与 CodeBuddy Review 须以新 head 的实际结果为准。

## 未验证项

- Android/iOS 系统字体逐像素差异不由 Linux Golden 证明。
- 小程序只作为交互流程参考，Flutter 不引入小程序的 `keys` 映射或非受控默认值 API。
