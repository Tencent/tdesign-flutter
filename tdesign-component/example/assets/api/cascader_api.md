## API
### TDMultiCascader
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| action | TDCascaderAction? | - | 自定义选择器右上角按钮 |
| backgroundColor | Color? | - | 背景颜色 |
| cascaderHeight | double | - | 选择器List的视窗高度，默认200 |
| closeText | String? | - | 关闭按钮文本 |
| data | List<Map> | - | 选择器的数据源 |
| initialData | String? | - | 初始化数据 |
| initialIndexes | List<int>? | - | 若为null表示全部从零开始 |
| isLetterSort | bool | false | 是否开启字母排序 |
| key |  | - |  |
| onChange | MultiCascaderCallback | - | 值发生变更时触发 |
| onClose | Function? | - | 选择器关闭按钮回调 |
| subTitles | List<String>? | - | 每级展示的次标题 |
| theme | String? | - | 展示风格 可选项：step/tab |
| title | String? | - | 选择器标题 |
| titleStyle | TextStyle? | - | 标题样式 |
| topRadius | double? | - | 顶部圆角 |
