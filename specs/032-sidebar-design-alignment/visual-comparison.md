# 三方视觉与交互对照

## 参考

- 新版 Figma：页面节点 `24787:18812`；移动端画板节点 `28591:34071`，尺寸 375×667。
- 小程序 develop：`packages/components/side-bar/`、`side-bar-item/` 与 `_example/`。
- Flutter：`lib/src/components/sidebar/` 与 `example/lib/page/sidebar/`。

## 差异

| 项目 | 新版 Figma | 小程序 develop | 修改前 Flutter | 收敛目标 |
| --- | --- | --- | --- | --- |
| 公开入口 | 组件移动端展示 | 锚点、切页、带图标、自定义 | 额外包含非通栏、debug loading/颜色 | 保留四项可操作入口，主详情视觉对齐 Figma |
| 数据 | 约 10 项占位数据，默认第二项 | 5 项中文序号，默认第二项 | 20 项数字或 6 项业务分类，默认第一项 | 10 项，默认第二项；记录跨端数量差异 |
| Badge | 第二项圆点、第三项数字 8 | 第二项圆点、第四项数字 6/8 | 第三项数字 8 | 对齐 Figma 的第二/第三项位置 |
| disabled | 画板未体现 | 切页第五项禁用 | 未体现 | 切页保留第五项禁用以验证操作模式 |
| 宽度 | 103dp | 206rpx=103dp | 组件最小 106，Demo 106/116 | 默认 103dp |
| 内容 | 标题 + 48dp 圆角方图/文字纵向列表，行高 80dp | 标题一～五、64dp 圆图三列宫格、12/9/9/6/3 | 长列表或业务商品分类 | 公开详情优先采用 Figma 纵向列表；宫格差异明确记录 |
| 状态所有权 | 结构由实例控制 | 结构由 props/data 控制 | Theme 同时持有 style/height | Theme 只保留视觉值 |

## 已记录的平台差异

- 小程序用 `defaultValue` 支持非受控模式；Flutter 保持受控 `value/onChanged`，不复制双状态源。
- 小程序 `change` 事件返回 `{value, label}`；Flutter 回调保持强类型 `ValueChanged<int>`，不复制动态事件对象。
- 小程序公开 Demo 使用 5 项 + 三列圆图宫格；新版 Figma 使用约 10 项 + 48dp 圆角方图纵向列表。该差异较大，Flutter 公开详情按 Figma 收敛，仅保留小程序的受控切换、锚点同步和禁用项操作模式。
- Figma 当前只有浅色画板；深色使用 TDesign 语义 Token 独立验证。
