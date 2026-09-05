# 验收记录

## 设计核对

- Figma 固定节点：`28591:35219`。
- 小程序公开参考：`components/tab-bar?tab=demo` 与
  `Tencent/tdesign-miniprogram/packages/components/tab-bar`。
- 新 Figma 相比小程序明确新增 Horizontal/Vertical 展示轴；记录该差异并由
  Flutter 独立 `layout` 参数表达。
- 公开 Demo 以节点内 `TabBar 底部标签栏 移动端展示` 画板为准，而不是右侧组件
  资产展板：3 个分组、9 个示例、固定首页/应用/聊天/我的四项。

## 实际验证

- Android 16 真机构建并安装 debug APK，Flutter attach 后大写 `R` 在 1.533s
  完成；随后按用户要求改用桌面可见的 iPhone 16 Pro Simulator 继续逐轮验证。
- 最终 Demo 在 Simulator 大写 `R`（588ms、527ms）后打开页面，实际点击纯文本第二项、
  打开并选择双层级菜单、滚动检查弱选中三行/悬浮胶囊/自定义，并切换真实暗色主题。
- Figma 人工对照确认顶部 `TabBar`、正文标题与说明、3 个分组、9 个示例、四项文案、
  徽标类型、胶囊和自定义行一致；组件资产中的 Horizontal/Vertical 由独立组件测试覆盖。
- Flutter 3.32.0 Linux 离线固定环境：组件明暗 Golden 14/14、Demo 整页明暗
  Golden 2/2，更新后立即去掉 `--update-goldens` 精确复跑 16/16；人工看片发现并
  修复中文子集缺字后再次生成、复跑和检查，无方框、裁切、溢出或暗色残留。
- Flutter 3.32.0：严格 analyze 零问题，组件 16/16、Demo 1/1；生产源码覆盖率
  `496/511 = 97.06%`。Flutter 3.47.0：严格 analyze 零问题，同组测试 17/17。
- Flutter 3.32.0 与 3.47.0 的 Example Web release build 均成功；3.47.0 仅输出
  既有 `synthetic-package` 废弃提示及 Wasm dry-run 建议，不是构建失败。

## 未覆盖项

- 维护者已确认当前可先以 Simulator 证据推送并发起 CNB Review；Android 真机重新
  连接后再补最终版本逐项操作，Simulator 证据不冒充真机证据。
- GitHub/CNB 独立 PR、#1027 精确条目关联和 CodeBuddy Review 在提交后完成。
