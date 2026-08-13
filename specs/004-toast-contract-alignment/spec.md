# Toast：默认背景色与默认时长对齐 TDesign Mobile

## 背景

TDesign Flutter 的 TToast 组件在与 TDesign Mobile 对齐时存在两处默认行为偏差，且遗留一处魔法数字哨兵值的风险：

1. **默认背景色过深**：默认背景使用 `fontGyColor1`（`#E5000000`，rgba(0,0,0,0.9)，白色页面约 #1A1A1A），比 TDesign Mobile 的 `--td-toast-bg-color: @font-gray-2`（rgba(0,0,0,0.6)，白色页面约 #666666）更黑、更不透明。
2. **默认消失时长偏长**：普通 toast 默认 `duration = 3000ms`，而 TDesign Mobile 的默认时长为 2000ms。
3. **魔法数字哨兵值**：原实现用 `Duration(seconds: 99999999)` 作为"永不自动消失"的哨兵标记。若用户恰好传入相近的超长 duration，会被误判为无限、toast 永不消失。

## 目标

- 将普通 toast（`showText` / `showIconText` / `showSuccess` / `showWarning` / `showFail`）默认背景色对齐 TDesign Mobile，由 `fontGyColor1` 改为 `fontGyColor2`。
- 将普通 toast 默认消失时长由 3000ms 对齐为 2000ms。
- 封装 `TToast.infiniteDuration` 具名常量替换魔法数字哨兵值，消除误判风险。
- 保持加载类 toast（`showLoading` / `showLoadingWithoutText`）"永不自动消失"语义不变。
- 保留 `toastTheme.backgroundColor` 自定义覆盖能力，不新增公共 API。

## 非目标

- 不新增、不删除、不重命名 TToast 的公共参数或类型。
- 不改变加载类 toast 的"永不自动消失"语义。
- 不引入淡入淡出动画、同 ID 替换闪烁优化等体验类改动（后续单独评估）。
- 不新增 `showClose` / `onClose` 关闭按钮等 API 能力。
- 不改动 Popup、DropdownMenu 等其他 Overlay 组件。

## 范围

### 涉及

- tdesign-component/lib/src/components/toast/t_toast.dart
- tdesign-component/test/components/toast/t_toast_test.dart

### 不涉及

- tdesign-component/example/ 下 toast 示例页
- 站点组件 README 的手工维护；API Markdown 由生成链负责
- 主题 token 定义（`fontGyColor2` 已存在于 `TThemeData`，无需新增）

## 行为契约

### 背景色

- 各 show 方法（showText / showIconText / showSuccess / showWarning / showFail / showLoading / showLoadingWithoutText）构建气泡时，背景色取值 `toastTheme.backgroundColor ?? theme.fontGyColor2`。
- 未通过 `TToastThemeData(backgroundColor:)` 自定义时，默认背景为 `fontGyColor2`（rgba(0,0,0,0.6)）。
- `toastTheme.backgroundColor` 优先级高于默认 token，自定义覆盖行为保持不变。

### 默认消失时长

- 普通 toast（showText / showIconText / showSuccess / showWarning / showFail）的默认 `duration` 为 `Duration(milliseconds: 2000)`。
- 加载类 toast（showLoading / showLoadingWithoutText）的默认 `duration` 为 `TToast.infiniteDuration`，即"永不自动消失"。
- 用户显式传入的 `duration` 以用户值为准，不受默认值影响。

### 无限时长哨兵值

- 新增公共具名常量 `static const Duration TToast.infiniteDuration`，值为 `Duration(seconds: 99999999)`。
- `showLoading` / `showLoadingWithoutText` 默认值与 `_showOverlay` 的"是否为无限"判定统一使用 `TToast.infiniteDuration`。
- 用户显式传入 `TToast.infiniteDuration` 时，语义即为"永不自动消失"；此行为与原先的魔法数字等效，但语义更清晰、便于维护。

### 实例语义（防重复叠加）

- 未指定 `toastId` 的匿名 Toast 共用固定内部 ID `toast_anonymous`，后一次展示会替换前一次。
- 目的是避免重复调用（如连续点击同一按钮）叠加多个半透明 Toast，导致"重复显示"且"背景不断变深"。
- 指定不同 `toastId` 时仍可多实例并存；指定相同 `toastId` 时后一次替换前一次（行为与原先一致）。

## 验收标准

- [x] 普通 toast 默认背景色为 `fontGyColor2`，测试断言同步更新。
- [x] `TToastThemeData(backgroundColor:)` 仍可自定义覆盖背景色。
- [x] 普通 toast 默认 duration 为 2000ms，超过后自动消失。
- [x] 加载类 toast 默认 duration 为 `TToast.infiniteDuration`，不自动消失。
- [x] `TToast.infiniteDuration` 具名常量存在并被统一使用，魔法数字哨兵值不再散落。
- [x] 未指定 `toastId` 的匿名 Toast 重复展示时后一次替换前一次，不叠加、背景不加深。
- [x] 指定不同 `toastId` 时多实例仍可并存。
- [x] toast 相关单元 / Widget 测试通过。
- [x] flutter analyze 与 git diff --check 通过。
