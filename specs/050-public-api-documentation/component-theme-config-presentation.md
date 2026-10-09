# 全组件 Theme 配置表验收（2026-10-09）

## 结果

Input 方案已推广至 51 个独立组件 Theme，重新生成全部 57 页 API。功能声明保持原有相对顺序，Theme 放在最后；每个组件 Theme 只显示一张配置项表。默认构造及实例 copyWith、lerp、merge 的重复表格省略，共用能力集中在全局 Theme 页说明；专有方法、静态方法、命名构造及特殊语义保留。

全局 TThemeData 保留 Token、资源及构建等能力；3 个复用 Theme、2 个无独立 Theme 的组件保留原有归属说明。NavBar、Stepper、Form 的特殊复制或插值规则单独说明。Badge、Image、TimeCounter 的分类标记置于 @immutable 之前，避免丢失原类说明，并有回归检查。

## 当前证据

- 57 页保留 369 个公开声明、438 个 Theme 配置字段和 6 个专有可调用项；字段类型、默认值、必填及描述与推广前一致，原 Theme 类说明完整保留。逐页证据见 component-theme-config-evidence.json。
- Flutter 3.32.0 与本地 stable 3.47.6 生成的 57 页及工作区资产逐字节一致；两版独立 AST 审计均 369 声明、0 issue，生成器 validate 均 ERROR 0、WARN 0。
- 候选工具通过仓库 generate_api.mjs --check，检查 57 页。该检查使用本地候选生成器，不代表正式 ref: main 已验证。
- 两版文档专项各 124 项通过。最终类说明修复及强化断言后，3.32.0 全部 124 项再次通过，latest 受影响的全 57 页展示测试再次通过。
- 两版真实 API 页面测试各 70 项通过；最终三处类说明修复后，3.32.0 全部 70 项通过，latest 受影响页面 4 项再次通过。
- 独立生成器两版完整测试各 84 项通过；最后强化 @immutable 类说明断言后，两版相关展示测试各 12 项通过。两版生成器和组件严格分析均无问题。
- 103 个生产 Dart 文件与 HEAD 比较，非注释 token 无变化；两仓库 git diff --check 通过。
- 本地官网实际抽查 Form、Table、Calendar：Theme 均置后且只有一张配置表，分别 16、8、14 个配置字段；全局 Theme 页共用操作说明可见。

## 交付范围

本轮只改变文档、注释、生成与审计规则，没有改变公开签名、默认行为或运行实现；未重跑 Golden、设备或全部业务场景。本地预览位于 http://127.0.0.1:19000/flutter/components/form?tab=api 。

本轮修改尚未提交或推送。生成器位于独立工作区 /tmp/tdesign-flutter-tools-docs，需要与消费仓库分别交付；消费依赖仍保持正式 ref: main。正式依赖解析、远端 CI、autofix 及合并状态尚未在本轮复验，不据本地候选结果声明正式链路完成。
