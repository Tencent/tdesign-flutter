# Plan

1. 固定 Flutter develop、小程序公开页面与 Figma 组件属性矩阵。
2. Review TCascader API、默认值、状态与 Theme 所有权。
3. 仅增加组件内部活动层级所必需的 subtitles 内容配置，保持 value 单一受控状态源。
4. 使用 Flutter 组合修正末级自动完成、任意层提交、搜索和关闭语义。
5. 去除 Demo 与 Popup 的 Material 补丁，由 TSearchBar 自身提供 TextField 所需渲染上下文。
6. 补齐 Demo 功能、组件回归、覆盖率和打开/关闭状态 light/dark Golden。
7. 运行 Flutter 3.32.0 与 latest 验证并更新独立 PR。
