# TCellGroup

`TCellGroup` 负责 Cell 列表、标题、分隔线和卡片布局，不保存列表业务状态。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `cells` | `List<TCell>` | 必填 | 单元格列表 |
| `title` | `Widget?` | `null` | 组标题 |
| `variant` | `TCellGroupVariant?` | Theme / `standard` | 通栏或卡片形态 |
| `builder` | `TCellGroupBuilder?` | `null` | 单元格外层构建器 |
| `scrollable` | `bool` | `false` | 是否使用可滚动列表 |

```dart
const TCellGroup(
  variant: TCellGroupVariant.card,
  title: Text('Account'),
  cells: [
    TCell(title: Text('Profile'), arrow: true),
    TCell(title: Text('Security'), arrow: true),
  ],
)
```

## Theme

`TCellThemeData` 可设置默认组形态、组边框、卡片圆角与内边距、标题样式、标题内边距和最后一项分隔线。

Theme 不保存标题、Cell 列表、builder 或滚动状态。实例 `variant` 优先于 Theme。
