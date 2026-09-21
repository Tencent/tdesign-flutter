# 组件 Demo 二次设计复核与收敛

## 背景

二次走查覆盖 28 个公开 Demo。仅依据修改日志或组件测试无法证明问题已经修复，必须把设计稿、`origin/develop` 和当前实现置于同一裁切边界下复核，并区分 Demo 组装、组件默认行为、共享 Token 与测试基线的所有权。

## 目标

- 逐一复核 Button、Indexes、Navbar、SideBar、TabBar、Tabs、Cascader、Checkbox、DateTimePicker、Input、Slider、Stepper、Textarea、TreeSelect、Avatar、Badge、Collapse、Empty、Footer、Image、ImageViewer、Progress、Swiper、Table、Tag、TimeCounter、DropdownMenu、Popover。
- Demo 只负责公开示例的状态与外部排列，不通过特殊样式掩盖组件缺陷。
- 组件默认视觉、交互与 API 在组件层收敛；共享色值由 Token 统一提供。
- 为设计稿提供可分别定位 develop/current 差异且区分配准视图与真实页面流的五栏证据，并为全部变更 Golden 提供可审计的三栏像素证据。

## 非目标

- 不要求 Flutter 与 Figma 使用同一字体栅格器，也不把合理的平台字体差异当作组件缺陷。
- 不机械复制小程序 props/events；小程序仅用于确认视觉语义和 Token 设计。
- 不在 Demo 中添加只为截图对齐的装饰、位移、裁剪或局部主题覆盖。
- 不修改 `tdesign-component/CHANGELOG.md`。

## 行为契约

- 页面截图从第一个公开标题开始，移除设备状态栏、Figma 头部与底部测试区域，五列使用一致的内容边界。
- 设计比较图固定为：Figma 原图、配准后的 `develop × Figma` 差异、配准后的 `current × Figma` 差异、当前分段配准渲染、当前原始渲染。配准只允许平移分段，禁止缩放组件；原始渲染必须保留累计纵向偏移，避免配准过程掩盖 Demo 行盒或间距问题。
- Golden 比较图固定为：`origin/develop` 基线、逐像素精确差异、当前基线；任一 RGBA 通道不同即在中栏标红。
- Golden 新增项以空白 develop 基线表示，删除项以空白当前基线表示，不能从证据清单中省略。
- `TProgress` 使用六个命名构造函数表达形态；形态无效参数不进入对应构造函数，`status` 是任务状态的唯一入口。
- `TCheckbox` 单行内容垂直居中，多行内容顶部对齐；方形指示器使用 1.5px 圆角。
- `TFooter` 的品牌内容允许与说明文案组合；链接分隔间距与颜色来自语义 Token。
- `TSwiper` 的卡片间距、缩放与淡化由组件实现，Demo 不补绘卡片效果。
- `TCell.note` 在有主内容时采用受约束的自然宽度，避免固定等分导致 Cascader 等页面错位。
- Popover 角落 placement 的气泡边缘与触发按钮边缘对齐，箭头保持 12px 内边距。
- Popover 点击另一触发器时，单次点击同时关闭旧气泡并打开新气泡；再次点击当前触发器仅关闭当前气泡。
- 灰阶 Token 与移动端设计值一致；所有消费页面的预期 Golden 变化必须一起审查。

## 验收标准

- [x] 28 个 Demo 都有设计稿／develop 差异／current 差异／current 配准渲染／current 原始渲染五栏证据。
- [x] 全部变更 Golden 都有 develop／精确差异／当前三栏证据与逐文件统计。
- [x] Flutter 3.32.0 与 latest 严格 analyze、组件回归和 Example 回归通过。
- [x] Linux amd64 Flutter 3.32.0 全量 Golden 更新后，无更新参数精确复跑通过。
- [x] 受影响组件生产源码覆盖率满足仓库 95% 门禁。
- [x] 生成 API、示例代码与公开 Demo 源码同步。
- [x] 模拟器验证关键弹层、安全区、轮播控制、进度交互和图片预览路径。
