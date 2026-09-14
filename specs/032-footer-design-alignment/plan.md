# 方案

## 技术方案

根据 `logo`、`links`、`text` 的存在性决定渲染分支；资源加载、链接点击与导航由调用方 Widget 负责。

链接组布局的关键点：

- 外层 `Container(alignment: Alignment.center)` 是收缩包围盒（shrink-wrap），其水平约束为 `minWidth = maxWidth = 内容固有宽度`。因此链接行内不能再放依赖宽松约束做居中的收缩包围盒。
- 链接行使用 `Wrap(alignment: WrapAlignment.center)` 承载链接与分隔线；`Wrap` 先按宽松约束测量子项固有尺寸，再在行内定位，天然避免上述收缩包围盒导致的宽度压缩。
- 水平间距由 `Wrap.spacing`（12）提供，对应原先每个链接左右各 6 的 `Padding`；`crossAxisAlignment: WrapCrossAlignment.center` 让分隔线与链接垂直居中；`runSpacing` 保证链接组换行时的行间距。
- 链接不套 `IntrinsicWidth`：`TLink` 内部 `Row` + `Flexible` 在收缩的固有宽度约束下会压缩文字宽度，导致文本逐字换行；链接按固有宽度参与布局即可，`TLink` 在宽高两个方向仍为收缩包围盒，无需额外包裹。
- 版权文字直接在 `Column` 中居中：`Container` 的 `Alignment.center` 已提供水平定位，去掉原先由 `Row` + `Flexible` 提供的重复居中，避免在收缩包围盒内再次收缩文本。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `lib/src/components/footer/t_footer.dart` | 渲染分支简化为单子项；链接行改用 `Wrap` 承载间距与对齐 |
| 测试 | `test/components/footer/t_footer_test.dart` | 补充链接单行、水平居中、窄容器换行与固有宽度断言 |
| 示例 | Demo 源码与生成片段不变 | 无影响 |
| 文档 | 本 Spec | 补充链接布局契约 |

## API 变化

- 无：`TFooter` 公开构造参数、字段语义与 Theme 均未变化。

## 风险与取舍

- 链接行改为 `Wrap` 后，链接组可换行；此前 `IntrinsicWidth` + `Wrap` 的组合在收缩包围盒下会压缩文字。用 `runSpacing` 控制换行间距是新增的可见行为，仅在链接组超出可用宽度时出现。
- 分隔线用 `Wrap` 的子项表达，无法感知自身处于第几行，跨行时不会出现在行尾或行首，行为与 TDesign 移动端按行分隔一致。

## 验证策略

- 单元测试：`test/components/footer/t_footer_test.dart` 覆盖渲染分支、分隔线、固有宽度、单行居中、窄容器换行与文字省略。
- 集成或 Widget 测试：`example/test/footer_demo_test.dart` 覆盖公开 Demo 结构与链接可点击。
- 静态检查：`flutter analyze --fatal-infos`（组件库与 example）。
- 人工验收：Flutter 3.32.0 Linux light/dark Golden 更新后以无更新模式复验。
