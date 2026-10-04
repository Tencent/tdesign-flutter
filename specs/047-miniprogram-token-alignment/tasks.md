# 实施任务

- [ ] DOING 已按用户指定的全局 Radius 规范恢复 `radiusSmall/default/large/extraLarge/round = 3/6/9/12/999dp`，移除独有的 `radiusMedium`；受影响组件与 Linux 3.32.0 Golden 的最终验证待完成。

- [x] DONE 固定小程序 `develop` 源码提交并检查 Flutter 工作区。
- [x] DONE 建立全局 216 项与组件 804 项的静态清单、来源和差异分类；全局两模式的标量及复合结构均已逐键比较，组件小程序侧明暗默认值和冲突候选已逐项提取。
- [ ] DOING 核对组件变量的真实消费链，按需要开放 Theme 字段，不机械暴露全部变量；BackTop、Indexes、TabBar 的圆角来源已核实并修正，TabBar 胶囊阴影改用小程序的 `shadow-3`；Tag 四种语义色的深浅色回退链已补运行时测试。
- [x] DONE 全局 Token 216 个小程序同名键、明暗引用链和同名 getter 齐备；两端独有键均为 0。未批准静态值差、引用链差异和缺失 getter 均为 0；已批准例外仅有 `radiusCircle` 及浅色 `grayColor3`（连带 4 个引用项），视觉仍待验。
- [ ] TODO 固定设计与 Flutter 的实际字体后，直接核对 Tag 文字排版宽度；确认组件是否应显式解析全局字体族，再判定 38px 设计实例的剩余宽差。不通过增大 Padding 或固定宽度凑单个文案。
- [ ] TODO 继续逐组件核实 Flutter 的最终消费值与必要的 Theme 覆盖；804 项默认值提取与静态映射不是逐项运行验证。优先处理 2 个回退冲突、1 个未解析暗色值、3 个无回退变量。
- [x] DONE 补充全局 Token 测试、文档与 Flutter 3.32.0 / 3.47.0 静态检查和完整组件回归。
- [ ] DOING 已在 Flutter 3.32.0 Linux 复跑受影响组件及 Demo 的无更新 Golden；固定半径与默认字体缺字已修复，仍有 35 张旧基线差异，需对正确 Token 值、TabBar 设计布局和阴影继续做设计裁定，不直接更新。
- [ ] TODO 对需设计稿裁定的歧义进行后续比对。
- [x] DONE 按已裁定设计稿修正 Avatar 默认背景/方角、Slider 普通与胶囊未选中轨道、Tag 四档方角及 Cell Demo 页面底色；组件/页面聚焦测试和双版本严格分析已通过。旧 Linux Golden 仍有混合差异，未更新基线，不能据此宣称整页视觉验收完成。
- [x] DONE Tag 方角按用户重新裁定为组件 Theme 显式值优先、否则全局 `radiusSmall = 3dp`；文字行盒与对应字体行高一致，显式组件 Theme 字体同时决定单行外盒高度。
