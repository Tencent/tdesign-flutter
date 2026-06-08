## API
### TPicker
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| disabled | bool | false | 是否禁用整个选择器（禁止滚动和操作），默认 false |
| height | double | 200 | 视窗高度，默认 200 |
| initialValue | List<dynamic>? | - | 初始选中值列表（按 value 匹配各列） **严格 initState-only 语义**：仅在组件首次构建时生效，决定各列初始滚动 位置。父级后续重建传入不同的 `initialValue` 会被忽略——TPicker 内部 `FixedExtentScrollController` 拥有滚动位置的所有权，频繁回灌会触发 `dispose+reinit`，破坏惯性滚动（典型症状：滚轮"每次只能滚 1 项"）。 正确做法： - 选中态展示用 `onChange` 维护 draft，不要回灌 - 需要"重置"时配合 `Key` 强制重建本组件 - 数据源整体变更时修改 `items`，会触发整组重置 |
| itemBuilder | ItemBuilderType? | - | 自定义子项构建器（disabled 项仍由内部统一渲染，不会走此 builder） |
| itemCount | int | 5 | 每屏显示 item 数，默认 5 |
| items | TPickerItems | - | 数据源（必填） 使用密封类 `TPickerItems` 编译期强制二选一： - `TPickerColumns` → 多列独立选择 - `TPickerLinked` → 联动选择 自由结构数据通过 `.fromRaw()` 工厂构造归一化。 相对上一帧值不相等时会触发组件重新初始化；内容相等的新实例不会重建。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChange | void Function(int col, TPickerValue value)? | - | 值改变回调（滚动时实时触发） 触发时机： - 用户滚动经过某个 enabled 项时 - disabled 修正动画完成后，回调最终落点 `col` 为本次触发的列索引（0-based，从左到右），联动模式下也仅指用户实际 滚动的列（下游列联动刷新是结果，不是触发源）。可用于按列精确响应。 `value` 为当前各列选中快照。 注意：此回调代表滚动时实时变化，不代表用户已确认选择。 弹窗场景请配合 `TPopup` 头部确认按钮，在关闭前读取 draft 值提交。 按需加载：在此维护 draft / 联动缓存；列底分页见 `onColumnScrollEnd`。 |
| onColumnScrollEnd | void Function(int col, TPickerValue value)? | - | 指定列滚动结束回调（惯性滚动停止或手指抬起后） `col` 为列索引；`value` 为当前各列选中快照。 适合在业务层判断 `value.indexes[col]` 是否接近列底并触发分页，避免在 `onChange` 里对每一项选中变化都做加载判定。 |
