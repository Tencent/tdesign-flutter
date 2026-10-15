# Demo 内部区块与公开快照隔离

Debug 默认展示内部验证区块，Profile/Release 隐藏。公开功能与 Demo Golden 使用 TDESIGN_DEMO_TEST_MODULES=false；组件 Golden 不受影响。单独默认 Debug 进程验证开关。页面配置值与实际渲染策略分别断言。

仅更新因隐藏内部区块变化的48张既有 Demo PNG。保持精确比较。新增主题指南六张快照及字体验证在新增验证 PR；日期和取证路径修复在 Spec070。
