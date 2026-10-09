# TThemeData 复制操作收敛

## 背景与目标

copyWith 返回 ThemeExtension<TThemeData>，调用方需要强制转换或使用同义的 copyWithTThemeData。将 copyWith 和 lerp 的返回类型收窄到 TThemeData，统一推荐 copyWith，直接移除冗余入口，按 1.0 重构契约迁移。

## 行为契约

- copyWith 和 lerp 返回 TThemeData，可直接访问 Token、继续复制或赋值给具体类型。
- 移除 copyWithTThemeData 和 ofColor/ofFont/ofCorner/ofFontFamily/ofShadow；动态查询统一通过相应 Token Map。
- parseThemeData 收为私有；公开 JSON 解析统一 fromJson。
- 间距复制参数 marginMap 改为 spacerMap，与字段一致；省略或传 null 的 name 保留原名。
- 移除非必要的 ofExtra 泛型查询包装；业务扩展通过 extraThemeData 字段读取并判断类型。
- 仓库消费者迁移至 copyWith(name: ...)，删除可证明冗余的复制/过渡结果强制转换。
- Token 增量合并、引用链解析、默认回退、空值行为、extraThemeData 继承保持；原 default 名称重置修正为保留当前名称。
- lerp 的既有目标切换、不插值和 extraThemeData 行为保持；本 PR 不修复其他主题议题。
- 动态 Token 查询、JSON 解析和主题构建能力保留。

## 兼容性

返回类型属于公开签名变更，按仓库规则使用 breaking 类型。常规消费者可删掉 as TThemeData；重写 copyWith/lerp 的外部子类必须将返回类型收窄到 TThemeData。旧包装和查询方法不保留，迁移至 copyWith(name: ...) 及 Token Map；marginMap 改为 spacerMap。

## 验收

双 SDK 具体类型赋值/链式调用通过；全部 Token 配置增量合并和回退保持；现有组件功能回归、严格 analyze 和已登记入口通过。独立 PR 不包含文档工作区的全组件 Theme 展示改动。
