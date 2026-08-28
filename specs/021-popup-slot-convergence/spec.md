# Popup 内容插槽收敛

## 背景

Popup 是承载任意内容的基础浮层。小程序基础 Popup 默认只渲染内容，不自动生成标题、取消、确定或关闭按钮。当前未发布实现同时暴露整行头部 builder 与标题、取消、确认子插槽，并通过 sentinel 区分省略和显式 null，存在多个内容来源和覆盖关系。

## 行为契约

- `TPopupOptions.bottom` 默认不显示头部。
- `TPopupOptions.center` 默认不显示关闭按钮。
- bottom 仅保留 `headerBuilder` 作为整块头部扩展点。
- center 仅保留 `closeBuilder` 作为面板外关闭区扩展点。
- builder 获得的 `close` 只执行关闭，不自动生成控件。`headerBuilder` 调用
  `close()` 时上报 `custom`，需要区分操作语义时可显式调用
  `close(TPopupTrigger.cancel)` 或 `close(TPopupTrigger.confirm)`。
- `TPopupHeader` 只负责 `cancelButton`、`title`、`confirmButton` 的标准布局；三个 Widget 均可为空，交互和语义由调用方提供。
- top、left、right 不增加方向专属内容插槽，标题等内容通过 `child` 组合。

## API 影响

移除未发布的 `titleWidget`、`cancelBuilder`、`confirmBuilder` 以及对应的默认 sentinel；`headerBuilder`、`closeBuilder` 默认值改为 null。该调整改变当前 PR 中尚未发布的 API 与默认行为，提交类型按 breaking 处理。
