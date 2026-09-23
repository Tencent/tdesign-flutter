
## Flutter官网运行调试文档

- 在 `tdesign-site` 目录执行 `pnpm install --frozen-lockfile` 安装依赖
- 运行 `pnpm dev` 同时启动本地文档站点（19000）和右侧 Flutter Web 预览（19001）
- 仅调试文档、不需要 Flutter Web 预览时可运行 `pnpm dev:site`
- 运行 `pnpm site` 执行示例映射测试并构建生产站点

入门文档由仓库根目录的 `README_zh_CN.md` 同步生成，组件文档由组件 API 和示例构建流程生成。

每个组件 Markdown 使用组件级指令展示该组件的全部 Example App 生成代码：

```markdown
{{ flutter-example-group table }}
```

指令按组映射到 `tdesign-component/example/assets/code/<group>.<name>.txt`。单个片段仍可使用 `{{ flutter-example table.TableBasicExample }}` 调试，但组件正式文档必须使用组映射，确保该组件所有生成示例都被展示。

`pnpm test:example-code` 会验证全部 57 份组件文档、映射组和生成资产，并禁止重新加入手工维护的 `td-code-block` Dart 副本。资产键非法、文件不存在、组件缺少映射或仍有旧副本时，站点构建都会失败。
