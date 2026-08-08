# 实施方案

## 技术方案

采用“运行时职责分离、关系集中校验”的方案：

1. 保持 Flutter package、Example App 和 Web site 为三个独立运行单元。
2. 将组件 Markdown 和 Flutter design Markdown 放到站点自有目录，减少对小程序源码目录的依赖。
3. 将 `md-to-vue.ts` 放到 `tdesign-site/site/scripts`，由 `plugin-tdoc/transforms.ts` 调用。
4. 保留 Example App 的运行时文档预览链路，继续使用 `example/assets/api` 和 `example/assets/code`。
5. 先通过无依赖 Node 脚本校验源码、Example、文档和路由的一致性，再逐步引入 manifest 驱动生成。
6. API 生成迁移采用兼容阶段：先保留现有 `all_build.sh` 的特殊参数行为，确认生成结果一致后再替换入口。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件源码 | `tdesign-component/lib/src/components` | 只作为契约校验来源，不改变实现 |
| Example | `tdesign-component/example` | 保留运行时 API/代码预览，更新 Web 文档输出路径 |
| API 生成 | `tdesign-component/demo_tool/all_build.sh`、`tool/generate_example_code.dart` | 当前保持兼容，后续迁移 manifest |
| 站点文档 | `tdesign-site/docs/components` | Flutter 组件 Markdown 新来源 |
| 设计文档 | `tdesign-site/docs/design/flutter` | 本地 Flutter design 文档来源 |
| 站点脚本 | `tdesign-site/site/scripts/md-to-vue.ts` | Markdown 到 Vue 文档转换 |
| CI | `.github/workflows/test-build.yml`、`preview-build.yml` | 新增组件契约检查 |
| 校验工具 | `scripts/check-flutter-component-contracts.mjs` | 校验路由、源码、Example 和文档关联 |

## API 变化

- Flutter 组件公共 API：无变化。
- Example App 公共使用方式：无变化。
- Web 文档内部路径：从 `tdesign-site/src/<component>` 调整为 `tdesign-site/docs/components/<component>`。
- 站点内部 alias：新增 `@component-docs`。

## 风险与取舍

- 文档迁移会影响旧脚本路径，因此需要同步更新站点路由、文档生成器和 coverage 脚本。
- 组件命名存在 `tree-select/tree`、`pull-down-refresh/refresh` 等差异，校验工具必须使用显式 alias。
- `_common` 仍包含旧小程序运行时代码，暂不直接删除，避免破坏遗留测试脚本。
- API 生成命令包含组件级特殊参数，未经结果对比不直接改写为通用命令。
- Example assets 同时承担运行时读取和生成产物存储，当前保留以满足 App 内点击预览需求。

## 验证策略

- 单元测试：保留现有 Example code generator 测试。
- 集成或 Widget 测试：验证 Example 内 API/代码预览和 Web Markdown 输出路径。
- 静态检查：执行 `node scripts/check-flutter-component-contracts.mjs`、`git diff --check`。
- 站点构建：在 `tdesign-site` 执行 `pnpm site`。
- Flutter 验证：在可写的 Flutter/FVM 环境执行 Example `pub get` 和构建；当前环境的 FVM cache 权限问题需单独处理。
