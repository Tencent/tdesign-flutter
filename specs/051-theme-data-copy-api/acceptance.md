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

无界面布局、样式或尺寸默认值变更，不更新 Golden。后续按用户要求在本 PR 修复 lerp，最终行为及验证见下方补充。API 删除、参数重命名、具体返回类型以及复制保留名称属于 breaking，迁移方式见 spec.md。

本地日志：/tmp/theme-convergence-all-{latest,332}.log、/tmp/theme-convergence-analyze-{latest,332}.log、/tmp/theme-convergence-consumer-{latest,332}.log、/tmp/theme-convergence-example-{latest,332}.log、/tmp/theme-convergence-coverage-{latest,332}.log、/tmp/theme-convergence-mutations.log、/tmp/theme-convergence-api-generate-final.log。

远端 CI/autofix 和 review 待提交 PR 后检查，不以本地通过推定远端状态。原文档工作区保留其未提交修改。

移除 ofExtra，Demo 直接读取 extraThemeData 并判断类型。lerp 现已实现有效 Token 插值及业务扩展切换。

## 最终 lerp 修复验收

- Flutter 3.32.0 与 stable 3.47.6：各 2736 项 manifest 组件功能测试通过；其中扩展执行的 Theme 相关测试各 156 项通过。
- 两版 Theme 生产覆盖率均 342/349 = 97.99%，严格 analyze 零问题。
- 实际 AnimatedTheme 中间帧验证 Token 插值与业务扩展保留；端点、全部九类 Map、单侧值、字体小数精度、引用改向/显式覆盖、默认回退与复制后的别名覆盖均验证。
- 忽略数值进度、丢失 extraThemeData、遗漏默认/引用键三项故障注入均被新测试检出，源码已恢复；随后完整最新版本回归通过。
- 文档工作区 57 项呈现测试通过，正式生成工具的全局主题 API 仍为四项。
- 日志：/tmp/theme-lerp-{all,theme,coverage,analyze}-{332,latest}.log；低版最终 analyze 日志为 /tmp/theme-lerp-analyze-332-final.log；故障注入日志 /tmp/theme-lerp-mutation-*.log。

- 最终两版独立消费者各 11 项、Theme Demo/示例基础设施各 10 项通过。latest 示例首轮遇到 3.32 着色器产物被新引擎读取的缓存格式错误；flutter clean 后全部通过，未改测试或界面。
- 接续远端 2466b104 的 autofix（仅 Theme API 产物）后，按最终源码重新生成产物解决冲突，生产代码保持已验证实现。
