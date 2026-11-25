# TabBar 菜单回调路由独立修复验收

基线 develop `3704434fd2adfb6988110bc760aaaa52a814581c`，分支 `rss1102/fix/tabbar-menu-route-reentrancy`。不依赖 #1196 的 API 改名或 Popup final。

## 修改前后

旧实现回调后无条件 pop：回调 push 新页会误关新页；回调已 pop 菜单会再返回宿主。当前先保存原菜单 Route/Navigator，保持旧 onChanged 的同步通知时机，再只清理原菜单。已关闭、移除或替换则停止；仍当前则 pop；被新页覆盖则 removeRoute。

普通关闭顺序、返回动画、payload、通知一次、重复选择、异常传播及 Controller 绑定规则保持。不新增或弃用公开 API，不调整默认值。新页覆盖时 Observer 收到原菜单 didRemove，且该菜单不播放返回动画，这是故障路径的可观察变化。

## 双版本验证

Flutter 3.32.0 / 3.47.7 各通过 123 项 TabBar 组件测试，其中 48 项菜单矩阵覆盖两种菜单、根/嵌套 Navigator 与 12 类操作，包括先关闭再导航、清栈、直接替换、卸载和异常。按 CI 清单执行 --exclude-tags demo --coverage，生产 LH/LF 均为 672/679（98.97%）。

两版各 25 项字体/回归清单工具测试通过；严格 analyze 零诊断；57 份生成 API --check 通过。四份关键输入双版本逐字节一致。原始日志及哈希保存在工作区 artifacts/api-split-delivery/01-tabbar。

原命名迁移分支的 96/286 项不作为本候选验收；当前只使用旧入口。未运行全包、真机或 Web release，未更新 Golden。远端检查以提交后的精确 head 为准，暂不合并。

## 本地 Review

实现、Spec、生成文档及测试登记一致；普通和自定义菜单共享处理，回调后不读 context。已保留并披露 Observer/动画差异，当前范围未发现新的阻塞问题。
