# 验收记录

- Flutter 原 PR 基线：`6a69569c104f6576fd6b39253eedbe48faa2b75c`
- 当前 `develop` 基线：`6433854a142a5ca7ee528aba9a1a8e7d72bea3ca`
- 小程序基线：`b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`
- 公开运行页：`https://tdesign.tencent.com/miniprogram/live/m2w/program/miniprogram/#!pages/tree-select/tree-select.html`
- Figma 文件：`TDesign for mobile`，页面 `TreeSelect 树形选择器`。
- Figma Demo 节点：`28591:40742`，尺寸 `378 x 1510`。
- Figma 两列组件变体：`27387:23982`，尺寸 `375 x 336`。
- Figma 一级列变体：`27449:25981`，宽度 `103`。
- API Review：完整路径值、`value + onChanged` 受控模式和数据深度驱动列数已收敛；
  不增加公开参数。

## 验证结果

- 最新本地 merge commit：`c9beb6f3`，完成目标分支与 `origin/develop` 的冲突整合；
  字体说明同时保留 TreeSelect 与 Stepper，并补齐 TreeSelect 上游来源与子集工具版本。
- 三个场景已改为页面真实使用的独立示例 Widget；生成片段包含 imports、完整 options、
  受控 value 与 `onChanged/setState`，不再依赖页面私有成员。
- Flutter 3.32.0：TreeSelect 组件与生成器测试 18 项、Demo 测试 7 项全部通过；
  组件包和 example 包 `flutter analyze` 均为 `No issues found`。
- Flutter 3.47.0（latest）：TreeSelect 组件与生成器测试 18 项、Demo 测试 7 项全部通过；
  组件包和 example 包 `flutter analyze` 均为 `No issues found`。
- 组件生产代码覆盖率：`286/288 = 99.31%`，高于 95% 门槛。
- 路径契约收敛后，Flutter 3.32.0 与 Flutter 3.47.0 的 TreeSelect 组件测试
  19 项全部通过；覆盖单选数量、重复路径、同级字符串/null/嵌套值重复，以及
  `==` 相等但 `hashCode` 不同的自定义值。
- Flutter 3.32.0 的组件包与 example 包完整 `flutter analyze --fatal-infos`、
  Flutter 3.47.0 的 TreeSelect 实现与测试静态分析均为 `No issues found`；
  组件生产代码覆盖率为 `311/313 = 99.36%`。
- Flutter 3.32.0 与 Flutter 3.47.0 的 example release Web 构建均通过；
  debug 唯一性校验不进入 release 执行路径。
- iPhone 16（iOS 18.2 模拟器）真实点击通过：单选切换分支并选择叶子、多选新增
  与取消叶子均正确更新；本轮仅增加契约文档和 debug 校验，不涉及视觉变化，未更新 Golden。
- API 生成配置已登记真实公开类型 `TTreeSelectOption`，生成文档同时包含选项值唯一性、
  完整路径、单选数量和重复路径约束。
- 同级选项唯一性改用与路径解析一致的 `==` 线性比较；自定义值在 `==` 相等但
  `hashCode` 不同的情况下仍会被 debug 校验拒绝，不依赖业务类型的哈希实现。
- `dart run tool/generate_example_code.dart --check` 通过。
- Linux `amd64` + Flutter 3.32.0 重新生成明暗两张 Demo Golden，并在同一容器
  去掉 `--update-goldens` 复跑，2 项全部通过。
- 合并最新 develop 后再次在固定 Linux `amd64` + Flutter 3.32.0 容器中仅比较
  明暗 Golden，2 项全部通过，未更新基线。
- 本地 Flutter Web 页面真实点击通过：单选切换到 `广东省 / 云浮市`、多选新增
  `广东省 / 深圳市`、三列切换到 `广东省 / 深圳市 / 盐田区`，服务端无异常输出。
- “查看代码”仅在非 Web 端展示；Widget 级真实入口点击已逐个打开三个底部面板，
  并核对面板内容与对应生成片段完全一致。
- TreeSelect 专用字体子集已覆盖页面可见文案，人工查看明暗 Golden 无缺字符号；
  子集 SHA-256 为
  `1cbb5418c4cd91a103deb2a28f68dacb1e895a6efcb8f2f5e8198d67d38ac7ca`。
- 原 PR 在 2026-09-01 的 CI 结果不代表当前合并与修改后的结果；推送后的远端 CI
  与 CodeBuddy Review 须以新 head 的实际结果为准。

## 未验证项

- Android/iOS 系统字体逐像素差异不由 Linux Golden 证明。
- 小程序只作为交互流程参考，Flutter 不引入小程序的 `keys` 映射或非受控默认值 API。
