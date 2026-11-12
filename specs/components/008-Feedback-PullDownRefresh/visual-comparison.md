# Issue #1027 视觉对比：PullDownRefresh

## 结论

- 问题归属：Demo。
- 组件实现无需修改；`TPullDownRefresh` 的刷新状态、下拉位移和尺寸契约保持不变。
- 基础 Demo 的双列骨架卡片此前先绘制文字占位、后绘制图片占位，与走查稿标注顺序相反；现已调整为图片占位在上、文字占位在下。

## Golden 对比

完整修改前、修改后与独立像素差异图保存在 GitHub PR #1130 描述的附件中，不作为 Spec 二进制文件提交。差异只涉及双列卡片内图片骨架与文字骨架的上下顺序。

- 代表性 light 页面 Golden：`25565 / 753000 = 3.40%` 像素发生变化。
- light / dark 两张页面 Golden 均按固定 Linux Flutter 3.32.0 环境更新，并在不带 `--update-goldens` 的情况下复跑通过。
