## API
### TDMultiCascader
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| title | String? | - | 选择器标题 |
| titleStyle | TextStyle? | - | 标题样式 |
| theme | String? | - | 展示风格 可选项：step/tab |
| subTitles | List<String>? | - | 每级展示的次标题 |
| data | List<Map> | - | 选择器的数据源 |
| cascaderHeight | double | - | 选择器List的视窗高度，默认200 |
| initialIndexes | List<int>? | - | 若为null表示全部从零开始 |
| initialData | String? | - | 初始化数据 |
| backgroundColor | Color? | - | 背景颜色 |
| topRadius | double? | - | 顶部圆角 |
| closeText | String? | - | 关闭按钮文本 |
| isLetterSort | bool | false | 是否开启字母排序 |
| onClose | Function? | - | 选择器关闭按钮回调 |
| onChange | MultiCascaderCallback | - | 值发生变更时触发 |
