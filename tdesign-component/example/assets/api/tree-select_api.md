## API
### TTreeSelect
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| multiple | bool | false | 是否允许选择多个叶子节点。 |
| onChanged | ValueChanged<List<List<Object?>>>? | - | 选中路径变化回调；为 null 时禁用。 |
| options | List<TTreeSelectOption> | - | 根选项。 |
| value | List<List<Object?>> | - | 受控选中路径。 |
