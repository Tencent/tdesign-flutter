# 版本发布流程

## 发布流程

1. 从 `develop` 新建 `release/x.y.z` 分支，修改 `tdesign-component/pubspec.yaml` 中的版本号，并创建目标为 `develop` 的 Pull Request。
2. PR 打开或更新时，Auto Release workflow 会生成从上个版本到当前版本的 CHANGELOG 草稿，并评论到 release PR。
3. 发布人检查并整理 CHANGELOG；按 workflow 约定编辑对应评论，自动化会将确认后的内容写入 `tdesign-site/CHANGELOG.md`。
4. 确认无误后合并 release PR 到 `develop`。
5. release PR 合并后，Auto Release workflow 在 `develop` 上创建版本 tag。
6. tag 创建后，TAG_PUSH workflow 将 `develop` 合并到 `main` 并推送，随后触发站点和发布流程。

相关实现：

- `.github/workflows/auto-release.yml`
- `.github/workflows/tag-push.yml`
