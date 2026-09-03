# 实施方案

## 技术方案

复用现有 `TDropdownMenu`、单选/多选面板与 `TDropdownThemeData`。默认值按 `组件 Theme > Flutter Theme > TDesign 语义 Token > 单一设计常量` 解析：字体、颜色、间距和圆角使用现有 Token；24px 图标容器、56px 单选行和 40px 多选项保留在现有 Theme 字段或单一内置默认中，不增加同义 API。Demo 启用 `compactDemo`，三列展开态按 Figma 构造 15 个选项并移除人为 280px 上限。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 示例 | `example/lib/page/t_dropdown_menu_page.dart` | 官方 Demo 矩阵 |
| 组件 | `lib/src/components/dropdown_menu/` | Figma 默认视觉与 Token 回退 |
| 测试 | `example/test/dropdown_menu_page_test.dart` | 入口与交互证据 |
| 生成文档 | `example/assets/code/dropdown_menu.*.txt` | 代码查看器片段 |

## API 变化

- 无新增、删除或签名变更。
- `TDropdownMenuController` 继续只负责跨树打开/关闭命令；选中值由声明式 `value(s) + callback` 持有，PanelController 只关闭当前局部面板，三者没有第二完成源。
- `placement`、`scrollable`、overlay 行为和 Theme 字段保留独立职责，不把 Figma 的 `active/disabled/checked` 组件属性新增为 Flutter 公共枚举。

## 风险与取舍

- 默认视觉变化会更新 DropdownMenu Golden，但不改变公开 API 签名、选中状态所有权或事件时序，因此不属于 breaking change。
- Flutter 扩展能力不进入公开 Demo，避免被误解为官方一对一场景。

## 验证策略

- 组件测试：全部 `test/components/dropdown_menu/`。
- Example 测试：官方入口矩阵、单选展开、三列 348px 展开态与禁用。
- 静态检查：Flutter 3.32.0 和 latest 严格 analyze。
- Golden：固定 Flutter 3.32.0 Linux 更新明暗整页、单选与三列展开态，并不带更新参数复跑。
- 人工验收：与 Figma `24386:5279` 和公开 Demo 的真实运行截图逐项对照。

### 滚动锚定容差复核

- 几何定位使用逻辑像素，贴边断言采用 `0.001` 浮点容差，不以抗锯齿或“整数像素舍入”为由放宽到 `1`。
- 同一次手势切换上下展开方向的用例须在滚动范围内跨越空间阈值，并断言没有越界；不把平台 overscroll 拉伸效果混入方向选择测试，也不全局关闭滚动效果。
- 固定 800×600 逻辑视口，在 DPR 1、2、3、3.25 下使用小数滚动位置和手势位移；每帧检查菜单、面板和遮罩的贴边关系，手势结束后继续严格检查。
- Flutter 默认边界拉伸的仿射滤镜路径会使祖先变换未完整传递给跨 Overlay 的 Follower；按下节修复，不通过新增 API、扩大容差、禁用生产滚动效果或修改既有 Golden 基线规避。

### 边界拉伸定位修复

- 在 DropdownMenu 私有 CompositedTransformTarget / LeaderLayer 中比较 RenderObject 的完整变换与图层链变换，为标准 Follower 提供缺失的仿射变换；不替换 Flutter 的 Follower、命中测试或生命周期。
- 仅菜单打开时每次合成重新解析，不添加持续 ticker，不依赖 scroll offset 变化，因此拉伸回弹且 scroll offset 已稳定时仍能跟随；关闭菜单不启用额外的祖先遍历。
- 保持菜单打开、页面滚动与拉伸反馈；不新增实例或 Theme API。奇异变换安全回退，普通变换不重复应用。
- 越界与范围内拖动都以 0.001 几何容差逐帧验证，覆盖四种 DPR、上下翻转、回弹与点击；补充普通/滤镜变换对照。Linux 原有 6 张 Golden 保持不变，独立组件场景新增明暗两张正在拉伸的展开态基线。非仿射 shader 路径需独立像素证据，不从仿射测试推断通过。
