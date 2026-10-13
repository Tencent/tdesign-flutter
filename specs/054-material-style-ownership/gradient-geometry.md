# 渐变按钮尺寸修复：本地验收

状态：实现、双版本、Golden 与最终 Review 均完成。仅本地处理，HEAD 保持 93c1d747，未提交或推送。

## 实际尺寸与根因

修复前的 Flutter 3.32 实际运行矩阵覆盖 M2/M3、全部四个 size 和四个 variant。outline 与 ghost 都存在同一问题，宽高各多 2dp；fill 与 text 无此差异。

| size | 普通高度 | 修复前渐变高度 | 修复后两分支高度 |
| --- | --- | --- | --- |
| large | 48 | 50 | 48 |
| medium | 40 | 42 | 40 |
| small | 32 | 34 | 32 |
| extraSmall | 28 | 30 | 28 |

Container 自动将 ShapeDecoration.padding（ShapeBorder.dimensions）加入内容布局；默认 1dp 描边因此额外占用两边。原先 ShapeDecoration 与透明 Material 还分别绘制描边。该问题与 Material 密度无关。

## 最小修复与保留边界

- 使用 DecoratedBox 绘制，背景与透明 Material 使用无描边形状；前景单独绘制有效描边。装饰不产生隐式 padding，边框只绘制一次。
- 继续使用已解析的 padding、minimumSize、fixedSize、maximumSize，不给 size Token 加硬高度。
- 保留实例尺寸/style、状态边框与形状、RTL、48dp 点击区、字体缩放以及大内容按约束展开。
- 保留调用方原始主题、自定义内容尺寸/位置、反馈、指针、焦点、回调和已有内容裁剪语义。
- 不改公开 API；恢复已定义的尺寸契约。原 PR 的 Material 主题迁移 breaking 说明仍有效。尺寸修复更新日志草稿见 spec.md，不改远端 PR 或自动生成 CHANGELOG。

## 双版本验证

新增 38 项几何测试：M2/M3 × 四个 size × 四个 variant，并遍历四种 shape、文案/纯图标；补测 LTR/RTL、五种显式尺寸/style、原始 Theme、状态描边、字体缩放。断言实际 RenderBox 宽高、内容宽高与相对位置，不仅检查 ButtonStyle 字段。

| 门禁 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 完整组件回归 | 57 组 / 2,876 项通过 | 57 组 / 2,876 项通过 |
| 最低生产源码覆盖率 | 95.55% | 95.55% |
| Button 覆盖率 | 472 / 474 = 99.58% | 472 / 474 = 99.58% |
| 调度器 / 覆盖率工具自测 | 19 项通过 | 19 项通过 |
| 完整 Demo 非视觉回归 | 365 项通过 | 365 项通过 |
| Button Demo / Layout 非视觉补充 | 4 项通过 | 4 项通过 |
| 组件与 Demo analyze --fatal-infos | 零诊断 | 零诊断 |
| 独立运行值复测 | 32 对宽高均相同 | 32 对宽高均相同 |

工具/API/示例生成器源码、公开 dartdoc、示例和 CI 清单未改变，不重新生成 API 或扩展无关工具测试。新增测试继续由现有 Button 与 Theme 登记文件执行；调度器自测核对登记和文件存在性。

## Golden

Linux Flutter 3.32.0 首轮完整无更新参数比较：现有 609 张运行基线全部通过，只有新增尺寸场景缺基线。旧截图未修改、容差未调整。

新增四张明暗/默认/按下截图：

- [亮色默认](../../tdesign-component/test/components/theme/goldens/button_gradient_geometry_light.png)
- [亮色按下](../../tdesign-component/test/components/theme/goldens/button_gradient_geometry_pressed_light.png)
- [暗色默认](../../tdesign-component/test/components/theme/goldens/button_gradient_geometry_dark.png)
- [暗色按下](../../tdesign-component/test/components/theme/goldens/button_gradient_geometry_pressed_dark.png)

每张按 M2 普通、M2 渐变、M3 普通、M3 渐变四列排列，覆盖四个 size、超小圆形图标、半透明描边、外侧描边、显式固定尺寸及紫色 24dp 自定义主题文字。真实按下后边框从 1dp 变为 6dp，按钮不改变大小；松开/退出焦点后再次比较默认图。

逐图验收：没有缺字或意外裁切。普通/渐变对应的半透明与外侧描边区域像素完全一致；圆角边缘存在少量抗锯齿舍入差异，不改变几何或内容位置，不据此宣称两类底层绘制器逐像素完全相同。所有基线比较仍使用仓库原有精确比较器。

- [x] 最终无更新参数全量复跑
- [x] 最终源码、图片哈希与再次 Review

## 日志与证据

- /private/tmp/td1157-geometry-before.log
- /private/tmp/td1157-geometry-after-{332,latest}.log
- /private/tmp/td1157-geometry-components-{332,latest}.log
- /private/tmp/td1157-geometry-manifest-{332,latest}.log
- /private/tmp/td1157-geometry-demo-{332,latest}.log
- /private/tmp/td1157-geometry-button-demo-{332,latest}.log
- /private/tmp/td1157-geometry-analyze-{332,latest}.log
- /private/tmp/td1157-geometry-demo-analyze-{332,latest}.log
- /private/tmp/td-style-ownership-linux/linux-geometry-visual-compare.log
- /private/tmp/td-style-ownership-linux/linux-geometry-theme-update.log
- /private/tmp/td-style-ownership-linux/linux-geometry-visual-verify.log
- /private/tmp/td1157-geometry-pixel-review.png

本轮 lib Dart 源码指纹：bd1ed0db713833c49201d8dbde70b32a0bba3ea5078828f6375196688707a59d；本地、latest、Linux 副本一致。覆盖率产物已归档到 /private/tmp/td1157-geometry-coverage-332；临时运行值探针测试后删除。

## 最终验收与再次 Review

- [x] 无更新参数全量 Golden 复跑：75 个登记入口，74 组实际执行，672 项通过；明暗默认/按下/松开恢复均通过。
- [x] 图片范围核对：609 张旧基线哈希不变，仅新增 4 张；本地图片与 Linux 验证副本相同。
- [x] 最终源码复审：未发现新增阻断问题。所有 size 的 outline/ghost 宽高差异已消除；显式约束、状态边框、内容位置/主题、RTL、点击区和字体缩放保留，原生反馈/指针/焦点路径未被修改。
- [x] 本地、latest、Linux lib Dart 指纹一致，git diff --check 通过；临时测量文件与覆盖率产物已清理/归档。

运行值结论：默认 large / medium / small / extraSmall 高度分别 48 / 40 / 32 / 28dp，所有 variant 在每个 SDK 的 M2/M3 下共有 32 对实际宽高比较均一致。自定义字体和内容仍可按原生最小尺寸语义扩张，不宣称所有定制按钮固定于默认高度。

相对 HEAD 93c1d747、受影响 Button 实现/测试与 Theme Golden 测试的 binary diff 指纹：65528572515949435f8a34c5d8f81b06e3e8bcff082fd01262f160a40356ad6f。4 张新增 PNG 单独按文件哈希核对，不依赖 git diff 对未跟踪图片的覆盖。

交付：所有修复、测试、4 张新基线和本记录均为本地未提交改动。HEAD 未改变，没有推送、修改远端 PR 或新增远端 CI 结论。
