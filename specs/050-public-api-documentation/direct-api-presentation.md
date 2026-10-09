# 全组件直接 API 展示验收

57/57 页按 Input 方案逐组件处理：主组件不再显示类简介与开场说明，直接展示构造或静态方法。辅助类型、枚举、回调和 Theme 的实际语义保留；Theme 配置表位于最后。逐组件记录见 direct-api-evidence.json。

必要条件归入对应条目：Fab 的 Stack 与默认动作层约束、Radio 的 RadioGroup 归属、Dialog 的 title/content 条件、Divider 的竖向限制及 Message 的父级移除职责。其余已在参数或方法表描述的约束不重复展开。

两 SDK（3.32.0、3.47.6）各 57 项展示和 70 项真实 API 页面测试通过；57 份生成资产字节一致，独立 AST 审计 369 个公开声明、0 issue，严格 analyze 零问题。全部声明名与表格行数保持；157 个生产 Dart 文件与已合入 #1152 的 develop 非注释 Token 等价。字体覆盖检查、官网测试与构建通过。

新展示门禁已对全部页强制检查主入口直接进入 API；故意给 Input 插入入口简介后，测试按预期失败，随后恢复资产。浏览器抽查 Calendar、Form、Popup：入口无简介，Theme 是最后一个类型。

正式工具 #29 尚未合入 main，远端 autofix 仍可能使用旧渲染器重写资产。已保留自动提交历史并按当前源码生成结果解决冲突；正式 ref 解析、生成及最终 CI/autofix 复验仍待工具交付。上述验收不覆盖全部业务、Golden 或设备效果。
