# NavBar 实施方案

## 技术方案

1. 将默认返回、内容高度和边框模式收敛为实例非空状态；Theme 只保留可继承视觉值。
2. 以 Title Large 和 24px 返回图标对齐 Figma / 小程序 Token，保留 Material Theme 到 TDesign Token 的明确回退链。
3. 公开 Demo 采用新版 Figma 的 H5/Flutter 画板，不绘制微信宿主胶囊；小程序用于校验尺寸、顺序和交互语义。
4. 新增固定 `375 × 1318` 页面 Golden 和组件状态矩阵，并同步共享导航视觉基线。
5. 最终代码在 Android 真机明确 Hot Restart，执行安全操作项、搜索、滚动和主题切换，再安装普通 Launcher APK。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/navbar/` | 默认值、标题 Token、返回图标、Theme 状态所有权 |
| 测试 | `test/components/navbar/`、共享导航清单 | 行为、Theme、覆盖率与组件 Golden |
| 示例 | `example/lib/page/t_navbar_page.dart` | Figma H5/Flutter 示例顺序与尺寸 |
| Demo 测试 | `example/test/navbar_*` | 结构、交互与整页 light/dark Golden |
| 文档 | 本 Spec、生成 API 与示例片段 | breaking 迁移与验收证据 |

## API 变化

- `TNavBar.useDefaultBack` 默认 `false`。
- `TNavBar.height` 改为非空 `double`，默认 48。
- `TNavBar.useBorderStyle` 改为非空 `bool`，默认 `false`。
- 移除 `TNavBarThemeData.useBorderStyle`。

## 风险与取舍

- 默认返回变化会影响未显式传参的页面，必须在更新日志标为 breaking 并给出迁移方式。
- 微信宿主胶囊不属于 Flutter 组件所有权；伪造会制造错误的平台承诺，因此只记录视觉差异。
- 页面 Golden 固定 Figma 视口，但系统状态栏不属于 Flutter `RepaintBoundary`，由真机截图补证。

## 验证策略

- 单元测试：默认值、标题 Token、返回逻辑、边框所有权、Theme 优先级、`copyWith` / `lerp`、安全区。
- Demo 测试：示例顺序、87×24 图片、右侧操作、搜索输入、大标题与主题切换。
- Golden：组件状态矩阵、共享导航矩阵、`375 × 1318` Demo light/dark，更新后无更新参数严格复跑。
- 静态检查：两个 Flutter SDK 在组件包和 Example 全量 analyze。
- 构建：Web release、Android debug；生成 API 与示例代码并执行检查。
- 人工验收：Figma 逐项对照、Golden 逐张查看、Android 16 最终 Hot Restart 与普通安装操作。
