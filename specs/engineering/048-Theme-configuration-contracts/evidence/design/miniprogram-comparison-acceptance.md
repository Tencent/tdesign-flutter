# 小程序补充比较验收

固定官方 develop@a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，包版本1.17.0。
逐项比较59个待确认/撤回消费点；第一轮查声明、实际CSS/模板使用和全局回退，第二轮检查Flutter属性职责、变体、单位、默认值与用户设计优先级。
读取并保存33份直接参考源码，不以搜索引擎旧缓存替代当前提交。

结果：6点可确定全局来源，4点部分成立，3点默认冲突，1点结构不等价，45点不支持原全局映射。
M080额外检查确认Flutter当前padding仍为固定8，故列为可接入spacer的候选，未冒称已生效。
当前已实施行为仍由mapping-review的decision/current描述；新证据字段implemented=false。

已校验59个编号唯一且与待确认/撤回集合完全相等、分类合计一致、全部引用文件及行范围有效、33份快照内容SHA256一致、git diff --check通过。
比较前后2277份组件/主题/测试/示例/转换相关文件哈希完全相同。
证据指纹见[miniprogram-comparison-fingerprint.json](miniprogram-comparison-fingerprint.json)。

本批是文档与源码审查，没有修改API、组件默认行为、主题控制范围或测试契约，不构成新增breaking change。
未运行小程序Demo、Flutter功能测试或像素Golden，未部署；既有测试结果不当作尚未实施映射的运行证据。
对应设计节点缺失或默认冲突的条目仍需设计裁定，不以小程序默认覆盖用户已明确的Figma裁定。
