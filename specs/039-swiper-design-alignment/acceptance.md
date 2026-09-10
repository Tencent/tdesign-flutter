# 验收记录

## 验证环境

- 分支：`rss1102/feat/swiper-design-alignment`
- Flutter 基线：已合入 `origin/develop@0f1e9b62`
- 移动端设计：Figma `24386:5274`，使用已登录的 Google Chrome 核对页面结构与视觉
- 小程序参考：`Tencent/tdesign-miniprogram@cc2384cc`

## 基线

| 命令 | 结果 |
| --- | --- |
| `flutter test test/components/swiper/t_swiper_test.dart` | Flutter 3.32.0，38/38 通过 |
| `flutter test test/swiper_page_test.dart` | Flutter 3.32.0，4/4 通过 |

## 最终自动化与人工验收

| 门禁 | 结果 |
| --- | --- |
| Flutter 3.32.0 组件测试 | 38/38 通过，含 controls 深浅主题默认对比色回归 |
| Flutter 3.32.0 Demo 测试 | 4/4 通过，含横向 fling、controls、卡片和垂直参数交互 |
| Flutter 3.32.0 analyze | 组件与 example 均 0 error / 0 warning |
| Flutter latest 3.47.0 | clean + pub get 后组件 38/38、Demo 4/4、两工程 analyze 通过 |
| 生产代码覆盖率 | `427/441 = 96.83%` |
| 回归清单自检 | component / Demo / visual 三组清单测试 13/13 通过 |
| Linux Golden | `linux/amd64`、Flutter 3.32.0，浅色/深色 2/2 无更新复跑通过 |
| Golden 人工检查 | 补齐 Material Icons 与专用 CJK 字体后重新生成；两张全页图的 controls 为真实箭头，深色页面也保持灰底白箭头可见，“画”字正常，无缺字、溢出或异常裁剪 |
| Web 操作验收 | controls 上一页实际切换；垂直 autoplay 开关由“开”切为“关”；interval 与 duration 滑块均实际拖动并更新位置 |

浏览器自动化使用桌面鼠标，Flutter Web 默认 ScrollBehavior 不把鼠标拖拽当作移动端触控拖拽，因此横向 touch 手势以 widget 的真实 fling 测试验收；Web 端仍以 controls 完成真实页面切换，不把鼠标拖拽失败记作组件缺陷。

## 歧义决策

- Figma 页面按 `24386:5274` 核对；组件结构、同源图片、卡片露出比例与反色导航由组件实现。垂直 Demo 的 `SizedBox(height: 192)` 是纵向 `PageView` 所需的有界内容视口，尺寸与图片展示比例一致；其余参数区域采用自然布局，未叠加装饰模拟组件效果。
- 小程序 `current` 没有映射为第二份状态；Flutter 使用 `TSwiperController.initialIndex/index` 管理受控状态，避免 Widget 参数和 Controller 竞争。
- 小程序字符串 easing 没有照搬；公开 API 使用 Flutter `Curve`，`animationDuration` 与 `animationCurve` 同时供 autoplay、内置 controls 和 Controller 默认继承。
- 小程序图片 `load` / 点击事件没有上移到 Swiper；Flutter 子 Widget 自己持有图片加载与点击语义。
- cards 的 `126/192` 邻项高度比例实现为交叉轴 scale，不缩放滚动主轴，避免改变 PageView 布局和手势命中区。
- 保持既有 `autoplay=false`、`loop=false` 默认值，只在公开场景显式启用，避免设计对齐造成默认行为 breaking change。
- `pagination`、`paginationPlacement`、`pageEffect` 仅由 `TSwiper` 实例 API 持有；`TSwiperThemeData` 只保留颜色、尺寸、间距、圆角和文字/按钮样式等视觉字段，不保留历史行为字段。
- 删除 Theme 中上述三个已发布行为字段属于 breaking change；调用方迁移到 `TSwiper` 的同名实例参数，不保留兼容别名。
- controls 的圆形背景 32dp、图标 18dp 是 Flutter 工程默认视觉值，`IconButton` 实际触控区域保持 48dp；该值不作为 Figma 精确标注，可由 `TSwiperThemeData.controlStyle/controlIconSize` 覆盖。
