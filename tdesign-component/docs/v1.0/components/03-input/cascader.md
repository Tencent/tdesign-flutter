# TCascader — v1.0 定稿

> Sprint **S4** | 控制类 **F** | Material: TPopup+自绘
> 源码：`lib/src/components/cascader` · [guide](../guide/developer-guide.md)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘 + Material 底座（滚轮/日历等） |
| Material | `showModalBottomSheet` + 自绘列 |
| Theme | `TCascaderThemeData` |
| 禁用 | 项级 `disabled` KEEP；整组 `onChanged: null` |
| L4 | show 样式参数 → **`TCascaderThemeData`** |

## 受控

`value` + `onChanged`；项级 `*.disabled` KEEP。禁用：`onChanged: null`。


Form → [form.md §2](../foundation/form.md#2-字段桥接控制类--form-写法)


---

## 1. API

### 保留

| 符号 | 说明 |
| --- | --- |
| showMultiCascader | 命令式 show API（E 类壳 + F 类选中） |
| data | 级联数据源 `List<Map>` |
| TCascaderAction | 右上角确认区（`text` / `builder` + `onConfirm`） |
| isLetterSort | 字母排序 |
| subTitles | 各级副标题 |
| onClose | 关闭回调 |

### 迁移 / 改名

| 0.2.x | v1.0 | 原因 |
| --- | --- | --- |
| onChange | onChanged | F 类；`void Function(List<MultiCascaderListModel>)?` |
| initialIndexes / initialData | value | 受控选中路径 |
| theme（`step` / `tab`） | TCascaderThemeData.variant | L4 → Theme |
| title / closeText | TCascaderThemeData | L4 默认文案 |
| barrierColor / duration | TCascaderThemeData | L4 蒙层与动画 |
| cascaderHeight | TCascaderThemeData | L4 列视窗高度 |
| titleStyle / backgroundColor / topRadius | TCascaderThemeData | 内部 Widget L4 迁入 |

### 废弃

| 符号 | 原因 |
| --- | --- |
| initialIndexes / initialData | 初值由父 State + `value` |
| `TTheme.of` 取蒙层色 | `Theme.of` + `TCascaderThemeData.barrierColor` |

### 新增

| 符号 | 说明 |
| --- | --- |
| value | 受控选中路径；配套 `onChanged` |
| TCascaderThemeData | L4 面板、确认栏、列高与 step/tab 形态 |
| TCascaderVariant | 原 `theme` 字符串 enum 化（`step` / `tab`） |

### show API（`showMultiCascader`）

| 参数 | 层级 | v1.0 | 说明 |
| --- | --- | --- | --- |
| `context` | E 首参 | **保留** | `BuildContext`；非 Theme 字段 |
| `data` | L2 | **保留** | 级联树数据 |
| `onChanged` | L3 | **改名** | 原 `onChange`；选中路径变更 |
| `value` | L1 | **新增** | 受控当前选中；替代 `initialIndexes` / `initialData` |
| `subTitles` | L2 | **保留** | 各级列标题 |
| `isLetterSort` | L1 | **保留** | 字母索引排序 |
| `action` | L3 | **保留** | `TCascaderAction` 确认按钮 |
| `onClose` | L3 | **保留** | 面板关闭 |
| `title` / `closeText` | L4 | → Theme | 默认标题/关闭文案 |
| `theme`（step/tab） | L4 | → Theme | `TCascaderThemeData.variant` |
| `cascaderHeight` | L4 | → Theme | 列视窗高度 |
| `barrierColor` / `duration` | L4 | → Theme | 蒙层色与入场动画 |

### L4 迁入 `TCascaderThemeData`

| 0.2.x 来源 | Theme 字段 | Material 对照 |
| --- | --- | --- |
| `title` / `titleStyle` | `titleStyle` | 无；TDesign 面板标题 |
| `closeText` | `closeText` | 对齐 BottomSheet 关闭文案 |
| `cascaderHeight` | `columnHeight` | 自绘列高 |
| `backgroundColor` / `topRadius` | `panelColor` / `panelRadius` | 近似 `BottomSheetTheme` |
| `barrierColor` | `barrierColor` | `ModalBarrier` / `showModalBottomSheet` |
| `theme` step/tab | `variant` | TDesign 步进/Tab 形态 |
| `duration` | `transitionDuration` | Route 动画 |

### export

- **保留**：`TCascader`、`showMultiCascader`、`TCascaderAction`、`MultiCascaderListModel`、`TCascaderThemeData`、`TCascaderVariant`
- **移出**：`TMultiCascader` 内部实现、`TCustomTab` 等（与 [附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) 一致）

---

## 2. Theme

`TCascaderThemeData` · Material: **BottomSheet + 自绘列** · [theme.md](../foundation/theme.md)

### Material vs TDesign

| 字段 | 来源 | 说明 |
| --- | --- | --- |
| `data` / `subTitles` / `isLetterSort` | **单次 show L2** | 业务数据与列标题 |
| `value` / `onChanged` | **F 类 Widget API** | 选中路径受控；Form → `TFormField` |
| `action` / `onClose` | **单次 show L3** | 确认与关闭 |
| `showMultiCascader` | **E 类首参** | `showModalBottomSheet(context, …)` |
| `variant` / `columnHeight` / 面板色圆角 | **`TCascaderThemeData`** | step/tab 与列布局 L4 |
| `barrierColor` / `transitionDuration` | Material **Route** + Theme 默认 | 蒙层与动画 |
