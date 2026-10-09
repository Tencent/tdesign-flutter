# 验收记录

基线 develop：dacc279ec96c601c8ba690b3baee2c7f6bdadab8。隔离分支 rss1102/breaking/theme-data-copy-api。

- Flutter 3.32.0 与本地 stable 3.47.6 各 2733 项 CI manifest 登记的组件功能测试通过（--exclude-tags demo），包含全部 Theme 专项与已迁移消费者。
- 已登记 Theme 专项 91 项通过，生产覆盖率两版均 296/304 = 97.37%，超过 95% 门禁。
- 两版独立包配置的公开消费测试各 11 项通过；具体返回类型通过函数返回签名编译验证。
- 两版 Theme Demo 与示例页面基础设施非 Golden 测试各 10 项通过。
- 两版组件包 flutter analyze --fatal-infos 无问题；git diff --check 通过。
- 名称重置、忽略 spacerMap、copyWith 返回宽泛类型三项故障注入均被测试检出，注入后原文件完整恢复。
- Theme API 使用正式 ref: main（本地 resolved-ref 96f1c693a2d61ae6c135db4d52530bb28dfc2462）生成，公开操作为 defaultData/fromJson/copyWith/lerp 四项；未使用候选文档工具或临时依赖覆盖。
- 示例代码生成无额外片段变化；仓库不再调用删除的入口，内部解析只有私有声明/调用。

无界面布局、样式或尺寸默认值变更，不更新 Golden。本轮未改变 lerp 忽略 t 或不保留 extraThemeData 的既有行为；这些是后续独立主题实现议题。API 删除、参数重命名、具体返回类型以及复制保留名称属于 breaking，迁移方式见 spec.md。

本地日志：/tmp/theme-convergence-all-{latest,332}.log、/tmp/theme-convergence-analyze-{latest,332}.log、/tmp/theme-convergence-consumer-{latest,332}.log、/tmp/theme-convergence-example-{latest,332}.log、/tmp/theme-convergence-coverage-{latest,332}.log、/tmp/theme-convergence-mutations.log、/tmp/theme-convergence-api-generate-final.log。

远端 CI/autofix 和 review 待提交 PR 后检查，不以本地通过推定远端状态。原文档工作区保留其未提交修改。

移除 ofExtra，Demo 直接读取 extraThemeData 并判断类型。lerp 行为修复尚未实施。
