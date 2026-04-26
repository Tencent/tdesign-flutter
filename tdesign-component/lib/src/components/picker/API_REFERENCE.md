# TPicker API 定义

> 纯滚轮选择器组件，数据决定形态。对齐 Flutter 惯例 + TDesign 生态。

---

## API 总览

```dart
TPicker(
  items: [...],            // ① 选项（必填）
  initialValue: [...],     // ② 初始选中（可选）
  onChange: (v) => ...,    // ③ 值改变回调（可选）
  onLoad: (e) => ...,      // ④ 加载回调（可选）
  preloadThreshold: 5,    // ⑤ 预加载阈值（可选，默认 5）
  height: 200,             // ⑥ 视窗高度（可选，默认 200）
  itemCount: 5,            // ⑦ 每屏 item 数（可选，默认 5）
)
```

| # | 参数 | 类型 | 必填 | 默认值 | 说明 |
|---|------|------|------|--------|------|
| ① | `items` | `dynamic` | ✅ | - | 数据源 |
| ② | `initialValue` | `List?` | ❌ | `null` | 初始选中 |
| ③ | `onChange` | `Function(TPickerValue)?` | ❌ | `null` | 值改变回调 |
| ④ | `onLoad` | `Function(TPickerLoadEvent)?` | ❌ | `null` | 接近底部时触发 |
| ⑤ | `preloadThreshold` | `int` | ❌ | `5` | 触发 onLoad 的剩余项数 |
| ⑥ | `height` | `double` | ❌ | `200` | 视窗高度 |
| ⑦ | `itemCount` | `int` | ❌ | `5` | 每屏显示项数 |

---

## 类型定义

### TPickerOption — 选项数据

```dart
class TPickerOption {
  /// 显示文字
  final String label;
  
  /// 实际值（onChange 返回此字段）
  final dynamic value;
  
  /// 是否禁用（不可选中/置灰显示），默认 false
  final bool disabled;

  const TPickerOption({
    required this.label,
    required this.value,
    this.disabled = false,
  });
}
```

### TPickerValue — onChange 返回值

```dart
class TPickerValue {
  /// 当前选中的 value 列表（每列的 TPickerOption.value）
  final List values;          // ['广东', '深圳', '南山']
  
  /// 当前选中的索引列表
  final List<int> indexes;     // [0, 1, 2]
}
```

### TPickerLoadEvent — onLoad 回调参数

```dart
class TPickerLoadEvent {
  /// 当前是第几列（从 0 开始）
  final int column;
  
  /// 该列的父级选中值（第一列为 null）
  final dynamic parentValue;
  
  /// 该列当前已显示的数据量
  final int displayedCount;
  
  /// 距离底部还有多少项
  final int remaining;
}
```

---

## 参数详解

### ① `items` — 选项（必填）

**类型**：`dynamic`

传入的数据类型决定选择器形态：

| 传入类型 | 形态 | 示例 |
|----------|------|------|
| `List<List<TPickerOption>>` | 多列独立选择 | 见下方示例 |
| `Map<dynamic, dynamic>` | 联动选择 | 见下方示例 |

**多列独立**：列之间无关联，每列独立滚动。

**联动**：前列的选择影响后列的选项。滚动第一列 → 第二列自动刷新。

---

### ② `initialValue` — 初始选中

**类型**：`List?`

根据 `items` 类型有不同的匹配方式：

| items 类型 | initialValue 用法 | 示例 |
|-------------|-------------------|------|
| `List<List>` | **按 value 匹配** | `['M', '25']` → 找 label='男' 的 option 且 value='M' |
| `Map` | **按 value 逐级匹配** | `['广东', '深圳']` → 逐级定位 |

**不传或传 null**：默认全选第一项。

---

### ③ `onChange` — 值改变回调

**类型**：`void Function(TPickerValue)?`

每次滚动停止后触发。

**用途**：
- 获取当前选中值（values / indexes）
- 检测联动变化（通过 `values.length` 变化判断是否需加载下一级）

---

### ④ `onLoad` — 加载回调

**类型**：`void Function(TPickerLoadEvent)?`

当某列滚动到距底部剩余 `preloadThreshold` 项时触发。用于大数据场景的按需加载。

**工作流程**：

```
1. 用户滚动某列
2. 剩余项数 <= preloadThreshold（默认 5）
3. Picker 触发 onLoad(event) ──→ 通知你
4. 你异步请求新数据
5. 你修改外部 data Map + setState()
6. Picker rebuild → 看到新数据
7. 用户继续无缝滚动
```

**不传此参数时**：无预加载能力，适合小数据场景。

---

### ⑤ `preloadThreshold` — 预加载阈值

**类型**：`int`  
**默认**：`5`

距离底部还有多少项时触发 `onLoad`。值越大越早触发。

| 值 | 效果 |
|-----|------|
| `0` | 到底才触发（可能短暂看到末尾） |
| **`5`** | 推荐，体验流畅 |
| `10+` | 很早触发，适合慢网络 |

---

### ⑥ `height` — 视窗高度

**类型**：`double`  
**默认**：`200`

选择器的总高度。与 `itemCount` 共同决定每个 item 高度。

---

### ⑦ `itemCount` — 每屏 item 数

**类型**：`int`  
**默认**：`5`

可视区域内显示的行数。item 实际高度 = `height / itemCount`。

| itemCount | item 高度 | 效果 |
|-----------|----------|------|
| 3 | ~67px | 大字紧凑 |
| **5** | 40px | 标准 |
| 7+ | <29px | 小字密集 |

---

## 使用示例

### 单列选择

```dart
TPicker(
  items: [
    [TPickerOption(label: '男', value: 'M'), TPickerOption(label: '女', value: 'F')],
  ],
  onChange: (v) => print(v.values),    // ['M']
)
```

### 多列独立选择

```dart
TPicker(
  items: [
    [TPickerOption(label: '男', value: 'M'), TPickerOption(label: '女', value: 'F')],
    [TPickerOption(label: '18岁', value: 18), TPickerOption(label: '25岁', value: 25), TPickerOption(label: '30岁', value: 30)],
  ],
  initialValue: ['M', 25],
  onChange: (v) => print(v.values),    // ['M', 25]
)
```

### 联动选择（省市区）

```dart
final provinceData = {
  TPickerOption(label: '广东', value: 'GD'): [
    TPickerOption(label: '深圳', value: 'SZ'): [
      TPickerOption(label: '南山区', value: 'NS'),
      TPickerOption(label: '福田区', value: 'FT'),
      TPickerOption(label: '宝安区', value: 'BA'),
    ],
    TPickerOption(label: '广州', value: 'GZ'): [
      TPickerOption(label: '天河区', value: 'TH'),
      TPickerOption(label: '越秀区', value: 'YX'),
    ],
  ],
  TPickerOption(label: '浙江', value: 'ZJ'): [
    TPickerOption(label: '杭州', value: 'HZ'): [
      TPickerOption(label: '西湖区', value: 'XH'),
      TPickerOption(label: '余杭区', value: 'YH'),
    ],
  ],
};

TPicker(
  items: provinceData,
  initialValue: ['GD', 'SZ'],
  onChange: (v) => print(v.values),    // ['GD', 'SZ', 'NS']
)
```

### 带 disabled 的选项

```dart
TPicker(
  items: [
    [TPickerOption(label: '选项A', value: 'A'),
     TPickerOption(label: '选项B(售罄)', value: 'B', disabled: true),
     TPickerOption(label: '选项C', value: 'C')],
  ],
  onChange: (v) => print(v.values),
)
// B 显示但不可选中，自动跳过
```

### 大数据按需加载（onLoad）

```dart
class _ProvincePage extends StatefulWidget {
  late Map _data = {};
  late List _selected = [];
  int? _prevLen;
  
  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }
  
  Future<void> _loadProvinces() async {
    final provinces = await api.getProvinces();
    if (mounted) setState(() => _data = provinces);
  }
  
  Future<void> _loadCities(String province) async {
    final cities = await api.getCities(province);
    if (mounted) setState(() => (_data[province] as Map?)?.addAll(cities));
  }
  
  @override
  Widget build(BuildContext context) {
    return TPicker(
      items: _data,
      preloadThreshold: 5,
      initialValue: _selected.isEmpty ? null : _selected,
      onChange: (v) {
        _selected = v.values;
        // 联动：检测到新一级时加载下一级（通过 values.length 变化判断）
        if (v.values.length > (_prevLen ?? 0)) {
          if (v.values.length == 1) _loadCities(v.values.first);
          else if (v.values.length == 2) _loadDistricts(v.values.last);
        }
        _prevLen = v.values.length;
      },
      onLoad: (e) async {
        // 同列大数据预加载：onLoad 提供了 remaining 信息
        print('第${e.column}列快到底了，父级=${e.parentValue}，还剩${e.remaining}项');
        final more = await api.loadMore(e.parentValue);
        if (more.isNotEmpty && mounted) {
          setState(() {
            final parentMap = _getOrCreateParent(_data, e.parentValue);
            parentMap.addAll(more.map((item) => TPickerOption(...)));
          });
        }
      },
    );
  }
}
```

### 嵌入弹窗

```dart
showModalBottomSheet(
  context: context,
  builder: (_) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildTitleBar(context, title: '请选择', onConfirm: () => Navigator.pop(context)),
      TPicker(
        items: data,
        onChange: (v) => print(v.values),
      ),
    ],
  ),
)
```

---

## 内部行为（不需要用户关心）

以下由组件内部自动处理：

- [x] 根据距离中心的远近，自动计算字体渐变（近粗远细、近深远浅）
- [x] 联动模式下，前列变化自动刷新后列数据
- [x] disabled 项自动跳过不可选中
- [x] 滚动波纹效果已禁用

---

## 不实现的功能

以下功能**不包含**在本组件中，由用户自行实现：

| 功能 | 原因 | 实现方式 |
|------|------|----------|
| 标题栏 / Header | 解耦展示层 | 外部包一层 Widget |
| 确认 / 取消按钮 | 解耦交互层 | 外部包装或 showDialog |
| 弹窗容器 | 解耦展示层 | showModalBottomSheet |
| 日期逻辑（年月日时分秒） | 非通用需求 | 用户在 items 中自行拼装 |
| 时间单位后缀 | 非通用需求 | 在 label 中写 `'2024年'` |

---

## 文件结构

```
picker/
├── t_picker.dart              # 主组件 TPicker
├── t_picker_option.dart        # TPickerOption 数据类
├── t_picker_value.dart         # TPickerValue / TPickerLoadEvent
├── t_item_widget.dart          # 内部 item 渲染组件
└── no_wave_behavior.dart       # 滚动行为禁用波纹
```

**删除的文件（旧版）**：
- ~~`t_date_picker.dart`~~ → 合入 `t_picker.dart`
- ~~`t_multi_picker.dart`~~ → 合入 `t_picker.dart`
- ~~`t_picker.dart`~~（旧工具类）→ 已删除

---

## 命名对齐

| 参数 | 对齐目标 |
|------|----------|
| **`items`** | 本项目 `TActionSheet`, `TDrawer`, `TDropdownMenu`, `TForm`；Flutter 官方 `DropdownButton.items` |
| **`initialValue`** | Flutter 官方 `TextFormField.initialValue`, `CupertinoDatePicker.initialDateTime` |
| **`onChange`** | 本项目 `TRate`, `TCalendar`, `TIndexes`, `TTimeCounter` 等 |
| **`onLoad`** | TDesign 其他端 `loadMethod` / `lazy-load` |
| **`TPickerOption.label/value`** | TDesign Web `label` / `value`；Flutter `DropdownMenuItem.value` / `DropdownButtonChild` |
| **`disabled`** | 全平台通用禁用命名 |

---

## 与旧版对比

| 旧版 | 新版 | 变化原因 |
|------|------|----------|
| `TDatePicker` | 合入 `TPicker(items:)` | 统一接口 |
| `TMultiPicker` | 合入 `TPicker(items:)` | 数据驱动 |
| `TMultiLinkedPicker` | 合入 `TPicker(items:)` | 数据驱动 |
| `DatePickerModel` | 删除 | 用户通过 TPickerOption 自行管理数据 |
| `MultiLinkedPickerModel` | 删除 | 内部实现 |
| `onChanged` (d 结尾) | `onChange` (e 结尾) | 对齐项目规范 |
| `onSelectedItemChanged` | 移除（信息合入 `onChange`） | 过度设计 |
| `isTimeUnit` | 移除 | 在 label 中自定义 |
| Header 全套属性 | 移除 | 用户自行包装 |
| `filterItems` | → `TPickerOption.disabled` | 更直观 |
| String 数据 | → `TPickerOption {label, value}` | 支持分离显示和实际值 |

---

*生成时间: 2026-04-27*
