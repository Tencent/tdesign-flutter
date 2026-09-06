# 验收记录

## 验证环境

- 分支：`rss1102/feat/time-counter-design-alignment`
- Flutter 基线：`origin/develop@2ed620b9`
- 移动端设计：按组件顺序记录相邻节点候选 `24386:5275`，登录限制下不宣称读取内部标注
- 小程序参考：`Tencent/tdesign-miniprogram@cc2384cc`

## 基线

| 命令 | 结果 |
| --- | --- |
| `flutter test test/components/time_counter/t_time_counter_test.dart` | Flutter 3.32.0，30/30 通过 |
| Demo 专项测试 | 未登记 |
| Golden | 未登记 |

## 最终自动化与人工验收

| 门禁 | 结果 |
| --- | --- |
| Flutter 3.32.0 组件测试 | PASS，37/37 |
| Flutter 3.32.0 Demo 功能与代码资产测试 | PASS，4/4 |
| Flutter 3.32.0 component / example analyze | PASS，均 0 issue |
| Flutter 3.47.0 组件测试 | PASS，37/37 |
| Flutter 3.47.0 Demo 功能与代码资产测试 | PASS，4/4 |
| Flutter 3.47.0 component / example analyze | PASS，均 0 issue |
| 回归清单、视觉清单、覆盖率脚本、示例生成器自测 | PASS，17/17 |
| TimeCounter 生产代码覆盖率 | PASS，263/266，98.87% |
| 代码面板生成校验 | PASS，11 个资产无漂移 |
| Flutter 3.32.0 Linux Golden | PASS，light / dark 2/2；更新后无参数精确复跑 |
| Web 实际运行 | PASS，观察 `01:35:58` 继续变化到 `01:35:52`，毫秒场景同步变化；完整滚动至尺寸区和页面末尾 |
| iPhone 16 Pro 模拟器操作 | PASS，开启代码模式并实际打开“无底色带单位”和“三档时分秒尺寸”代码面板，内容完整可复制 |

Golden 初次生成时发现 Linux Skia 对包内 `TCloudNumber` 可变字体的测试栅格结果为实心方块，且通用 CJK 子集缺少 TimeCounter 文案。未接受错误基线；补充 TimeCounter 专用确定性字体子集，并按 package 字体命名空间覆盖测试字体后，明暗两张整页图的数字、中文均可读。比较器未配置容差，最终复跑为精确匹配。

## 歧义决策

- 小程序用于公开场景、尺寸、形态和计时结果参考，不机械复制字符串 `content`、结构化 change payload、external class 或 `selectComponent` 命令式 API。
- 保留 Flutter 已发布的 `direction`、Widget `content` builder 与 Controller；仅从公开 Demo 移除正向计时和控制入口，聚焦测试继续覆盖这些能力。
- 普通秒级展示仅跨秒重建，但保留既有 `onChanged` 按有效帧传递毫秒值的契约，避免默认回调频率发生 breaking change。
- `showMillisecond` 不再向已含 `S` 段的格式重复追加；无效格式和负时长此前无法可靠工作，本次明确抛出参数错误。
- `TTimeCounterThemeData` 中 `showMillisecond`、`splitWithUnit` 属于历史行为型 Theme 字段；本次不新增同类字段，也不在非 breaking PR 中迁移既有 API，后续需独立方案处理。
- 当前 Web 页面按仓库既有逻辑只提供 API 入口、不提供代码遮罩切换；因此 Web 验收真实倒计时和完整滚动，代码面板操作改在 iOS 模拟器完成，不把静态资产读取冒充实际打开。
- 用户未提供 TimeCounter 直接 Figma 链接；按相邻组件顺序记录 `24386:5275` 为候选节点，但登录限制下未读取内部标注，不宣称完成 Figma 像素标注级验证。实现以可验证的小程序公开 Demo、源码与 Flutter 运行结果为依据。
