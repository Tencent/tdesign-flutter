# ImageViewer 设计与交互对齐

## 背景

当前 ImageViewer Demo 仍以缩略图触发“单张/多张”示例，和设计稿的两类按钮入口不一致；组件也只支持横向切图，缺少设计稿标注的单击关闭、下拉关闭、双击放大与双指缩放。

## 目标

- 公开 Demo 收敛为“基础图片预览”和“带操作图片预览”。
- 图片预览支持横向切图、单击关闭、下拉关闭、双击放大/还原和双指缩放。
- 操作栏按配置稳定展示关闭、页码与删除操作。
- 为组件、Demo 和操作后状态提供自动化及 Golden 证据。

## 非目标

- 不机械复制小程序的 props/events。
- 不引入图片下载、旋转、编辑或业务数据删除能力。
- 不改变 `onDelete` 仅通知当前索引、由调用方决定数据更新的契约。

## 小程序能力映射

Flutter 不机械复制小程序的属性名称和受控组件模型，但覆盖其公开用户能力：

| 小程序能力 | Flutter 等价表达 |
| --- | --- |
| `images`、`initial-index` | `images`、`initialIndex` |
| `visible`、`default-visible` | `TImageViewer.show` 打开 Route；调用方通过 `Navigator.pop` 主动关闭，返回的 `Future<void>` 通知关闭完成 |
| `show-index` | `showIndex` |
| `close-btn`、`delete-btn` 及对应插槽 | `showClose`、`showDelete`、`leadingBuilder`、`trailingBuilder` |
| `change`、`close`、`delete` | `onIndexChanged`、`TImageViewer.show` 返回的 `Future<void>`、`onDelete` |
| 点击遮罩/预览区关闭 | 全屏预览区单击关闭；不存在内容之外的可点击 Dialog 蒙层 |
| `background-color`、样式变量 | `TImageViewerThemeData` 的背景、导航栏、图标和文字样式字段 |
| `lazy` | `TSwiper` 基于 `PageView.builder` 按需构建当前及相邻页面 |
| `image-props` | 图片来源、缓存和解码由 `ImageProvider` 配置；预览组件固定使用适合全屏查看的 `BoxFit.contain`，长按业务由 `onLongPress` 承担 |
| `using-custom-navbar` | Flutter 通过 `SafeArea` 自动适配系统状态栏，无需业务开关 |

小程序 `close` 事件中的 trigger、`imageProps` 的逐字段透传，以及 `visible` 的受控/非受控双入口不作为 Flutter 公共 API 逐项复制：调用方通过 `TImageViewer.show` 打开 Route，需要外部主动关闭时使用所持有的 `NavigatorState.pop`，Route 关闭后由单一 `Future<void>` 通知完成；点击来源已有 `onTap`。图片预览保持统一的 `contain` 语义，来源、缓存和解码交给 `ImageProvider`。这样覆盖外部打开、外部关闭和关闭完成通知，同时避免再引入一套可与 Navigator 冲突的布尔状态源。

## 范围

### 涉及

- `TImageViewer.show` 的交互行为与文档。
- ImageViewer 公开 Demo、生成示例、组件/Demo 测试、Golden 和 CI 登记。

### 不涉及

- `TImage`、`TSwiper` 的公共 API。
- 网络图片缓存策略。

## 行为契约

- 单击当前图片时先通知 `onTap`，随后关闭预览并且展示 Future 只完成一次。
- 从 1 倍状态向下拖动超过阈值时关闭；未超过阈值时平滑回弹，不触发关闭。
- 双击在 1 倍与内置放大倍数之间平滑切换；双指缩放限制在 1～3 倍。
- 放大时允许平移，同时暂停手势切图和自动轮播；还原到 1 倍后恢复。
- 导航操作的颜色、禁用态、按压态和形状由 TDesign Theme/Token 明确控制，不继承 Material 2/3 默认状态。
- 关闭按钮、单击和下拉关闭共享同一关闭路径；系统返回也只完成一次展示 Future。
- 预览内容铺满路由，不暴露无实际命中区域的 Dialog 蒙层关闭参数；全屏空白区域与图片区域统一属于可点击关闭的预览区。
- 删除操作只回调当前索引，不直接修改传入列表。

## 验收标准

- [x] 两个公开 Demo 的标题、顺序、按钮样式和打开结果符合设计稿。
- [x] 组件 Widget 测试覆盖切图、单击/按钮/下拉关闭、双击/双指缩放、删除与边界。
- [x] Flutter 3.32.0 与 latest 的功能测试和严格 analyze 通过。
- [x] Flutter 3.32.0 Linux 的 light/dark Demo 及操作后 Golden 可复现。
- [x] 最终在浏览器执行一次“打开带操作预览 → 点击关闭 → 返回 Demo”的操作比对；其余手势由 Widget 测试验收。
