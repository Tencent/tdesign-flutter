## API

### TTreeSelect

#### 构造方法

##### TTreeSelect

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| multiple | bool | false | 是否允许选择多个叶子节点。 为 false 时，`value` 最多包含一条路径。 | 否 |
| onChanged | ValueChanged&lt;List&lt;List&lt;Object?&gt;&gt;&gt;? | - | 选中路径变化回调；为 null 时禁用。 | 否 |
| options | List&lt;TTreeSelectOption&gt; | - | 根选项。 | 是 |
| value | List&lt;List&lt;Object?&gt;&gt; | - | 受控选中路径；每一项应为从根到叶子的完整 `TTreeSelectOption.value` 路径。 单选模式最多传入一条，多选模式可传入多条且不得重复。 | 是 |


### TTreeSelectOption

#### 构造方法

##### TTreeSelectOption

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| children | List&lt;TTreeSelectOption&gt; | const [] | 子选项。 | 否 |
| disabled | bool | false | 是否禁用。 | 否 |
| label | String | - | 展示文案。 | 是 |
| value | Object? | - | 业务值；同一层级的选项必须保持唯一。 | 是 |
