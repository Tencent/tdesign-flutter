## API
### TDSelectOption
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| label | String | - | 标签 |
| value | int | - | 值 |
| children | List<TDSelectOption> | const [] | 子选项 |
| multiple | bool | false | 当前子项支持多选 |
| maxLines | int | 1 | 最大显示行数 |
| columnWidth | double? | - | 自定义宽度，允许用户指定每个选项的宽度 |

```
```
 ### TDTreeSelect
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| options | List<TDSelectOption> | const [] | 展示的选项列表 |
| defaultValue | List<dynamic> | const [] | 初始值，对应options中的value值 |
| onChange | TDTreeSelectChangeEvent? | - | 选中值发生变化 |
| multiple | bool | false | 支持多选 |
| style | TDTreeSelectStyle | TDTreeSelectStyle.normal | 一级菜单样式 |
| height | double | 336 | 高度 |
