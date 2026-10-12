# TD 组件隔离 Material 视觉密度

## 背景与目标

Button 的普通与渐变分支对 Material 密度的默认处理不同；桌面 Web 大按钮实际高度从 48 降为 40。Input 的内置编辑器继承宽松密度后增高，内置操作图标也会被 IconButtonTheme 密度挤压。TD 没有设计独立的密度体系，默认和显式 Material 密度均不应参与这些组件的内部布局。

## 范围与非目标

- 修改 Button、Input 的内置密度消费；清理 Table 无效的 CheckboxTheme 包装。
- Checkbox、Radio 实现保持现状。
- 不修改 Demo 排列、文案、加载图标尺寸、字体、字号、父约束和点击热区策略。
- 不新增公开密度 API，不重置调用方 prefix、suffix、child、builder 内容的 Theme。

## 行为契约

- Button 最终布局使用标准密度；全局、Material 按钮主题和实例 ButtonStyle.visualDensity 均不能改变组件内置布局。普通和渐变分支一致。
- Button 实例 style 的其他字段继续生效，调用方 child 和 icon 保留原主题上下文；字体缩放仍可撑高内容，tapTargetSize 保留原契约。
- Input 仅对内置 TextField 和清除、密码操作按钮隔离密度。内置装饰沿用既有专属 API 所有权，不继承 Material InputDecorationTheme；外层错误文字仍读取原 errorStyle。原主题其他字段继续继承，prefix、suffix 保留调用方上下文。
- Input 的尺寸不受 ThemeData.visualDensity 或内置操作按钮的 IconButtonTheme 密度影响；编辑、清除、密码切换、disabled/readOnly 行为不变。
- Table 选择框继续依赖 TCheckbox 自身规则与表格约束，移除其不消费的 Material CheckboxTheme。

## API 与迁移

不改变构造签名，但忽略 Button 显式密度和 Input Material 密度属于公开行为收敛。需要定制尺寸的调用方继续使用支持的 size、Theme、padding、minimumSize 等入口，不能再用 visualDensity 调整 TD 内置布局。用户可感知变更以 breaking 类型记录；不手工修改 CHANGELOG。

## 验收标准

- 密度 -4/0/+4 下 Button 四档、纯图标形状和普通/渐变布局一致，显式其他样式仍生效。
- Input 密度隔离、操作图标实际尺寸、编辑/清除/密码交互与自定义内容主题均有回归。
- Table 选择尺寸、渲染和回调不变；Checkbox、Radio 现有隔离测试通过。
- Flutter 3.32.0 与 latest 的 analyze 和受影响功能回归通过；视觉比对遵循 Linux 3.32.0 门禁，记录实际执行边界。
