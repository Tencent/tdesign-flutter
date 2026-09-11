# 实施方案

## 技术方案

- 保留既有 `TImageViewer.show` 入口，避免为了跨端 API 对照扩张公共面。
- 移除全屏内容覆盖后无法生效的 `barrierDismissible` 与 `barrierColor`；预览区单击承担小程序 overlay 点击的等价关闭能力。
- 每个预览页内部使用 `InteractiveViewer` 管理缩放和平移，用 `TransformationController` 实现双击缩放。
- 预览层统一管理当前缩放状态、下拉位移和关闭通知；缩放大于 1 倍时锁定 `TSwiper`，避免平移与切页冲突。
- 路由进场使用 100ms `easeOutCubic`，退场使用 100ms `easeInCubic`；关闭时预览层在当前位置轻微缩小，下拉关闭还会同步将已产生的纵向位移继动画到屏幕底部，不增加公开动效配置。
- Demo 使用本地确定性图片和两个块级描边 `TButton`，基础示例展示页码，操作示例展示关闭与删除。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `image_viewer/` | 补齐缩放、下拉和统一关闭行为 |
| 测试 | 组件与 Example 测试 | 覆盖真实手势和操作后状态 |
| 示例 | `t_image_viewer_page.dart` | 对齐公开 Demo 矩阵与代码面板 |
| 文档 | dartdoc、生成 API/示例、Spec | 同步最终契约与验收证据 |

## API 变化

- 不新增参数；删除无实际效果的 `barrierDismissible`、重复关闭通知 `onClose` 和 `TImageViewerThemeData.barrierColor`。
- `onTap` 仍通知当前索引，但默认行为由“仅通知”调整为“通知后关闭”，属于默认交互变化。
- 所有关闭来源统一完成 `TImageViewer.show` 返回的 `Future<void>`，调用方通过 `await` 或 `then` 响应关闭。

## 风险与取舍

- 单击关闭是用户可感知的默认行为变化，按 breaking change 记录。
- 缩放和平移会与横向分页竞争手势；以当前缩放是否大于 1 倍作为分页物理效果的唯一开关。
- 缩放倍数保持内置，不为单一设计场景增加公共配置。

## 验证策略

- 单元测试：参数校验、Theme 插值。
- Widget 测试：真实点击、拖动、双击、缩放、切页、删除与回调次数。
- Demo 测试：结构、按钮参数、打开状态、代码入口。
- 静态检查：双版本 `flutter analyze --fatal-infos`。
- 人工验收：最后一步在运行中的 Demo 执行一次完整操作链并与设计稿比对。
