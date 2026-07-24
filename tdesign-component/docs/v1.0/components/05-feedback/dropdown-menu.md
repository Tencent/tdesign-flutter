# TDropdownMenu

下拉菜单使用泛型选项模型和受控回调。

```dart
TDropdownMenu<String>(
  items: [
    TDropdownItem<String>(
      label: '状态',
      options: const [
        TDropdownItemOption(value: 'all', label: '全部'),
      ],
      value: 'all',
      onChanged: (value) {},
    ),
  ],
)
```

单选使用 `value` 与 `onChanged`；多选使用 `values`、`onValuesChanged` 与 `onConfirm`。
`TDropdownItemOption<T>` 是不可变值对象，选中状态由父组件控制。

## Theme

`TDropdownThemeData` 只提供宽高、装饰、箭头和标签对齐等视觉布局默认值。菜单方向、
滚动、关闭策略和动画时长由 `TDropdownMenu` 实例控制。
