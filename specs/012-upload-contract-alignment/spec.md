# Upload 小程序视觉与布局契约对齐

## 背景

当前 Flutter Upload 只有宫格布局，禁用态已有文件没有小程序的遮罩，失败状态也无法区分失败与可重试状态；示例页面的分组和默认禁用说明与小程序官方 Demo 不一致。

## 目标

- 保留 Flutter 受控文件列表和原生文件选择能力。
- 补齐小程序 Demo 可见的宫格 / 列表布局、加载 / 重试 / 失败状态和禁用文件遮罩。
- Demo 使用与小程序一致的“组件类型 / 组件状态 / 组件风格”分组，隐私场景默认禁用。

## 非目标

- 不引入小程序的 requestMethod、slot、source、draggable 或平台文件选择 API。
- 不把上传请求生命周期放入组件；业务仍通过受控 files 和回调管理状态。

## 范围

### 涉及

- `TUpload.layout` 使用 `TUploadLayout.grid/list` 选择布局。
- `TUploadFileStatus.retryableError` 表达可重试失败；`error` 保持失败状态。
- 禁用时为已有图片显示主题遮罩；列表布局展示文件名和大小 / 状态辅助信息。
- Upload Demo 和组件测试。

### 不涉及

- 现有 `files`、`onChanged`、`picker`、预览、重试和校验回调的生命周期。

## 行为契约

- `onChanged == null` 表示组件禁用；新增按钮、删除、预览和重试均不可触发。
- `grid` 保持 80dp 文件项和 token 间距；`list` 使用 Flutter Column/Row 组成文件信息行。
- `uploading` 显示进度环；`retryableError` 在 `onRetry` 可用时显示刷新图标和“重新上传”，否则降级为普通失败视觉；`error` 显示错误图标和“上传失败”。
- 禁用态图片使用浅色 / 深色对应的禁用遮罩；主题可通过 `disabledMaskColor` 覆盖。
- 文件列表仍由调用方控制，组件只生成不可变的变化列表并触发回调。

## 验收标准

- [ ] 组件测试覆盖两种布局、状态区分、禁用遮罩和既有受控行为。
- [ ] Demo 具有三组官方分组和隐私禁用说明。
- [ ] API 文档和示例代码资产与源码同步。
- [ ] Flutter 3.32.0 分析、测试和 Web 构建通过。
