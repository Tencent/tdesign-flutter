# Upload 设计说明

<a id="record-012-contract-alignment"></a>
<a id="record-053-async-picker-state"></a>

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

布局对齐和异步选择期间的状态变更容易导致旧结果写回。

当前 Flutter Upload 只有宫格布局，禁用态已有文件没有小程序的遮罩，失败状态也无法区分失败与可重试状态；示例页面的分组和交互状态与小程序官方 Demo 不一致。

## 范围与非目标

### 目标

- 保留 Flutter 受控文件列表和原生文件选择能力。
- 补齐小程序 Demo 可见的宫格 / 列表布局、加载 / 重试 / 失败状态和禁用文件遮罩。
- Demo 使用与小程序一致的“组件类型 / 组件状态 / 组件风格”分组，各示例均可操作。

### 涉及

- `TUpload.layout` 使用 `TUploadLayout.grid/list` 选择布局。
- `TUploadFileStatus.retryableError` 表达可重试失败；`error` 保持失败状态。
- `TUpload.onFileTap` 统一通知已有文件点击，调用方根据文件状态决定预览、重试或忽略。
- `TUpload.draggable` 控制是否允许长按文件排序，排序结果通过现有 `onChanged` 回传。
- 禁用时为已有图片显示主题遮罩；列表布局展示文件名和大小 / 状态辅助信息。
- Upload Demo 和组件测试。

### 不涉及

- 不引入小程序的 requestMethod、slot、source 或平台文件选择 API。
- 不把上传请求生命周期放入组件；业务仍通过受控 files 和回调管理状态。

- 现有 `files`、`onChanged`、`picker` 和校验回调的生命周期。

## 最终方案与行为契约

- `onChanged == null` 表示组件禁用；新增、删除、文件点击和拖拽排序均不可触发。
- `draggable` 默认为 `false`；为 `true` 且组件启用时，宫格和列表文件均可长按拖拽，添加入口不参与排序。
- 拖拽落下后组件生成不可变的新文件列表并触发一次 `onChanged`；组件自身不持有排序状态。
- `grid` 保持 80dp 文件项和 8dp 间距；非图片文件按扩展名显示语义图标与文件名。
- `list` 的 Upload 按钮位于文件列表之前；文件行间距为 12dp，内边距为竖向 8dp / 水平 12dp，使用次级容器背景和默认圆角。
- `list` 缩略图和状态图标为 24dp，删除图标为 18dp；启用态失败文件名使用 error token，禁用态统一使用 disabled token。
- `uploading` 显示进度环；`retryableError` 显示刷新图标和“重新上传”；`error` 显示错误图标和“上传失败”。
- 所有状态的已有文件点击均只触发 `onFileTap`；组件不自动预览、重试或改变文件状态，调用方根据 `file.status` 决定后续行为。
- 列表新增入口复用中型主题 `TButton`，显示上传图标和 `Upload`；`success` 文件缺少大小时显示“上传成功”，不显示“待上传”。
- Demo 提供与小程序相同的分组、文案和文件数据，并通过受控文件列表让各示例均可操作。按钮顺序、行背景 / 圆角 / 间距、图标尺寸与失败颜色属于组件默认样式。
- 禁用态图片使用浅色 / 深色对应的禁用遮罩；主题可通过 `disabledMaskColor` 覆盖。
- 文件列表仍由调用方控制，组件只生成不可变的变化列表并触发回调。

- 同一实例只允许一个 picker 在途；重复点击不启动新请求，完成/取消/失败后可以重试。
- 完成时使用最新受控 files、onChanged、maxFiles、maxFileSize；新增批次超限时整批拒绝。
- 禁用只阻止新的交互，不取消已经开始的选择；在途请求完成后仍按最新受控列表与限制校验并交付结果、校验错误或选择器错误。
- 完成时优先使用当前回调；当前回调为空时回退到请求开始时的回调。卸载后不再通知；布局切换时在途状态保留。
- 仅 picker/读取文件异常进入 onError。业务回调异常继续向外传播。
- 保留公开 TUpload 的 StatelessWidget 基类、构造签名和默认值；不增加网络上传能力。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 异步结果读取最新受控列表与限制；禁用只暂停新交互，不取消在途请求。当前回调缺失时回退到开始时回调，卸载后不通知。 |
| 保留的边界与代价 | 上传项的展示与选择器生命周期分开，使用现有公开能力完成演示，不新增重复状态 API。 |

### 设计演变中的关键理由

| 风险 | 基线触发/影响 | 修复 | 回归 |
| --- | --- | --- | --- |
| U1 / P1 | 等待期间父级替换文件，完成后旧快照覆盖新文件 | 持久私有状态读取最新受控列表 | latest parent files + immutable list |
| U2 / P1 | 两次选择同时开始，后完成的请求覆盖先前文件 | 同实例拒绝重入，完成后可再选择 | reentry + next request keeps both files |
| U3 / P2 | 等待期间父级更新配置，旧回调/限制继续生效 | 完成时读取最新配置；临时禁用不取消在途请求，缺失回调回退到请求开始时的回调；卸载后不通知 | disabled/re-enabled result + validation/error delivery + updated limits/layout + unmount |

正常使用不要求迁移。依赖同一实例并发调用 picker 的代码现在只启动一次选择，这是修复数据丢失所需的行为边界，已在 dartdoc 说明。

- 拖拽使用 Flutter 原生手势并保持受控状态，不复制小程序振动和过渡配置。
- `onPreview` / `onRetry` 收敛为 `onFileTap`，调用方需迁移为基于 `file.status` 的业务分发。

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- 组件测试覆盖两种布局、状态区分、禁用遮罩、拖拽排序和既有受控行为。
- Demo 具有三组官方分组、可操作的受控示例和官方文件状态数据。
- API 文档和示例代码资产与源码同步。
- Flutter 3.32.0 分析、测试和 Web 构建通过。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。
