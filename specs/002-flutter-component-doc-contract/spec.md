# Flutter 组件源码、Example 与文档契约

## 元信息

- 记录基线：develop
- 影响范围：tdesign-component、tdesign-site、仓库级 CI
- 状态：已完成

## 背景

Flutter 组件源码、Example 页面、API 文档、代码片段和 Web 站点文档分布在多个目录中。原有站点组件 Markdown 位于 `tdesign-site/src/<component>`，站点脚本位于 `site/plugin-tdoc`，而 Example App 还需要通过按钮生成 Web Markdown。

这种结构可以运行，但新增或重命名组件时需要同时维护组件源码、Example 注册、API 生成脚本、站点路由和文档路径，容易出现文档存在但没有路由、Example 没有注册或 API 文档缺失等不一致问题。

此外，Flutter design 文档原来通过 `tdesign-site/src/_common` submodule 读取，但站点实际只需要其中的 Flutter design Markdown，不需要整个小程序 common 源码树。

## 目标

- 将 Flutter 组件文档从小程序源码目录中分离到 `tdesign-site/docs/components`。
- 将 Flutter design 文档复制到仓库本地，并解除站点构建对 `_common/docs/mobile/flutter_design` 的运行时路径依赖。
- 将 `md-to-vue.ts` 放入站点脚本目录，明确其属于站点 Markdown 编译流程。
- 保留 Example App 内点击按钮生成 Web 文档的能力。
- 建立组件源码、Example、站点路由和文档之间的自动化契约检查。
- 以 API manifest 作为 API 文档生成和组件契约校验的共同来源。

## 非目标

- 本阶段不改变 Flutter 组件公共 API 或组件运行时行为。
- 不删除 Example App 的 API、代码片段等运行时 assets。
- 不将所有 Example 页面搬入组件源码目录。

## 范围

### 已实施

- `tdesign-site/src/<component>/README.md` 迁移至 `tdesign-site/docs/components/<component>/README.md`。
- `tdesign-site/src/_common/docs/mobile/flutter_design` 复制至 `tdesign-site/docs/design/flutter`。
- `tdesign-site/site/plugin-tdoc/md-to-vue.ts` 迁移至 `tdesign-site/site/scripts/md-to-vue.ts`。
- `md-to-vue.ts`、站点 alias、站点路由和 Example 文档输出路径同步更新。
- 新增 `scripts/check-flutter-component-contracts.mjs`，校验站点路由对应的组件源码、Example 注册和文档。
- 将契约检查接入 `test-build` 和 `preview-build`。

### 已完成清理

- API 生成配置已迁移到 `tdesign-component/tool/components.json`，`all_build.sh` 保留为兼容入口。
- 已删除 `tdesign-site/src/common`、旧小程序 Jest 配置和测试脚本。
- 已删除不再需要的 `_common` submodule 与 `.gitmodules`。

## 行为契约

### 目录职责

- `tdesign-component/lib/src/components` 是组件实现来源。
- `tdesign-component/example` 是真实 Flutter 运行示例和 App 内文档预览入口。
- `tdesign-component/example/assets/api` 和 `assets/code` 是 Example 运行时需要的生成资源。
- `tdesign-site/docs/components` 是 Flutter 组件 Web 文档来源。
- `tdesign-site/docs/design/flutter` 是 Flutter 设计指南来源。
- `tdesign-site/site/docs` 只放站点普通说明文档。
- `tdesign-site/site/scripts` 放站点 Markdown 编译和转换脚本。

### 文档生成

- Example App 可以继续通过 `WebMdTool` 读取 API 和代码片段并生成 Web Markdown。
- 生成的组件文档必须写入 `tdesign-site/docs/components/<component>/README.md`。
- API 生成脚本和代码片段生成脚本必须继续支持 CI 校验。

### 组件契约

每个站点组件路由必须同时满足：

- `tdesign-component/lib/src/components` 存在对应组件源码目录；
- `tdesign-component/example/lib/config.dart` 存在对应 Example 注册；
- `tdesign-site/docs/components/<component>/README.md` 存在；
- 站点路由不能重复；
- 命名差异必须通过明确 alias 表达，不能依赖隐式猜测。

## 验收标准

- [x] `md-to-vue.ts` 位于 `tdesign-site/site/scripts`，站点构建引用正常。
- [x] Flutter design 文档位于 `tdesign-site/docs/design/flutter`，站点构建不再从 `_common` 读取该路径。
- [x] 组件 Markdown 位于 `tdesign-site/docs/components`。
- [x] Example 文档生成路径与新的组件文档目录一致。
- [x] 组件契约检查覆盖当前 56 个站点路由。
- [x] 站点生产构建成功。
- [x] API 生成配置由 manifest 统一驱动。
- [x] `src/common` 和 `_common` 遗留内容已清理。
