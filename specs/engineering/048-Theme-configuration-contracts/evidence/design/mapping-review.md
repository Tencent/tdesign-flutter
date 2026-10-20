# 本轮新增映射逐项核对

本表审查的是本 PR 的 044/077 新增映射，不冒称复核整个设计系统。设计目标为用户指定的 [TDesign for mobile](https://www.figma.com/design/5iZtzla34Rz25j4cK7viAz?node-id=750-23479)，2026-10-16 通过只读 Plugin API 读取。

## 当前固定默认策略（2026-10-16）

用户允许固定默认接入一致刻度；本批三项默认对齐和22处源码尺寸映射已实施，详见[fixed-default-mapping.md](fixed-default-mapping.md)。此前比较报告和45处原因分类均是本批前的检查点，不能继续当作当前待办。原6处已补齐组件级配置（共9个公开字段），不新增全局映射或站点控制项；其余14处缺口保持现状。详见[component-token-mapping.md](component-token-mapping.md)。不宣称Search的布局回退是独立的可见图标控制。

## 当前用户尺寸裁定（2026-10-16）

M037、M087、M089的默认冲突已按用户确认修正：Cell card圆角9→radiusLarge，Table水平padding12→spacer1，Tabs tag内框水平padding16→spacer2。显式配置继续优先；Cell cardPadding布局差异M036仍未裁定。小程序比较报告的3个冲突是裁定前检查点，当前实现以本节及下表为准。

## 小程序补充复核

59个待确认/撤回消费点已完成两轮比较，见 [miniprogram-comparison.md](miniprogram-comparison.md)：6点明确全局来源、4点部分成立、3点默认冲突、1点结构不等价，其余45点不支持原全局映射。比较报告保留前置检查点；下表decision/current已同步后续裁定与组件字段实现。“有依据”不等于“已经实施”。

## 当前用户裁定（2026-10-16）

本次明确以所给设计稿为准，仅修正两处冲突：Badge square圆角2→3，接入Flutter `radiusSmall`；SideBar tag选中内块9→6，接入`radiusDefault`。设计稿变量名分别是radius-default=3、radius-medium=6，这是与当前Flutter既有3/6档的显式适配；不改全局定义，不新增radiusMedium。

Badge气泡10/1、dot8、padding4/6，SideBar邻项反向角9、最小高56及其余缺少依据映射保持原行为。M019中的square部分、M069已裁定，不再列为待解决的设计冲突；M019原公式中的bubble尖角仍未绑定。

## 证据和边界

- [变量原始记录](design-variables.json)：size 集合共55变量，包含 size1..16 和 comp-size、padding、margin 的真实 alias；后者消费 size 并非数值凑合。字体、圆角同时记录。
- [节点绑定原始记录](design-bindings.json)：16个相关组件页，按实际属性/变量聚合并保留具体节点ID、名称、属性值及父层名称。嵌套 Button/Avatar 的绑定不能归给 Badge/Cell 本体；同名文字样式若只见于页面标题，也不能归给头像。
- DropdownMenu、Message、Refresh、Steps、Swiper、Tag、CountDown 因 Figma MCP Starter 调用额度已用完而未读取；Table 不在此文件返回的页面清单。没有把读取失败当成设计没有 token。
- 旧文件 mdBVCCVGERhxoZLle2eLT0、4SdclZkcv5bPgX6pa8AsmI 的连接器拒绝访问；使用用户随后提供的可访问文件，不混称同一设计版本。
- 现有规范047的Flutter圆角集合是3/6/9/12；新文件有 small2/default3/medium6/large9。两处用户已裁定的冲突按上述决定执行；其余1.5px、8px、邻项9px等继续保留并单列，禁止用比例掩盖差异，禁止仅按同值猜别名。
- 颜色、字体族、基础size1..16的转换能力继续保留；命令式弹层实时继承与表格文字溢出属于运行修复，不是新增token绑定，不在此值映射清单中重复计数。

## 处置概览

- 撤回：无映射依据：1个源码消费点。
- 保留：节点绑定：36个源码消费点。
- 修正：用户授权一致刻度：22个源码消费点。
- 待确认：已恢复默认：23个源码消费点。
- 组件配置已补齐：未新增全局映射：6个源码消费点。
- 修正：语义字体来源：4个源码消费点。
- 修正：用户跨端默认裁定：3个源码消费点。
- 修正：用户设计裁定（square）：1个源码消费点。
- 保留：组件规范：2个源码消费点。
- 修正：用户尺寸裁定：3个源码消费点。
- 撤回：规范冲突：1个源码消费点。
- 修正：用户设计裁定：1个源码消费点。
- 修正：删除整体缩放：2个源码消费点。
- 保留：文字样式绑定：3个源码消费点。
- 修正：只控制绑定属性：3个源码消费点。
- 修正：独立属性绑定：2个源码消费点。
- 补齐：节点绑定：1个源码消费点。

计数为复核前新增源码消费点，不是组件数。M019原式同时涉及square与bubble尖角，本次只裁定square；M编号仍对应复核前表达式，不能作为当前源码行号。

## 逐项清单

| 编号 | 组件/消费表达式（复核前） | 处置 | 当前行为 | 依据 |
| --- | --- | --- | --- | --- |
| M001 | `avatar/t_avatar.dart`<br>`: context.tTheme.shadowAvatarGroup ?? [TAvatarDefaults.groupShadow],` | 撤回：无映射依据 | 保留 groupShadow / 内置头像层叠投影；不合成全局阴影别名 | Spec034/048；未取得组件效果绑定 |
| M002 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.large => token?.size15 ?? 64,` | 保留：节点绑定 | 头像外框 size15/13/12 | avatar width/height → comp-size/xxxxl、xxl、xl |
| M003 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.medium => token?.size13 ?? mediumDimension,` | 保留：节点绑定 | 头像外框 size15/13/12 | avatar width/height → comp-size/xxxxl、xxl、xl |
| M004 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.small => token?.size12 ?? 40,` | 保留：节点绑定 | 头像外框 size15/13/12 | avatar width/height → comp-size/xxxxl、xxl、xl |
| M005 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.large => token?.size10 ?? 32,` | 修正：用户授权一致刻度 | Avatar大号内置图标读取size10，默认32不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M006 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.medium => token?.size8 ?? 24,` | 修正：用户授权一致刻度 | Avatar中号内置图标读取size8，默认24不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M007 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.small => token?.size7 ?? 20,` | 待确认：已恢复默认 | 小号内置图标保持20，组件iconSize优先；大/中号已分别接入size10/size8 | Spec034/060；avatar 图标尺寸无绑定见证 |
| M008 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.large => token?.fontTitleExtraLarge?.size ?? 20,` | 待确认：已恢复默认 | 大号字符固定 20 / w600；不能用页标题的 Title/ExtraLarge 样式证明头像绑定 | Spec034/060；采样未定位大号头像文字节点 |
| M009 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.medium => token?.fontMarkLarge?.size ?? 16,` | 修正：语义字体来源 | 中号 Title/Medium；小号 Title/Small，替换同值 Mark；单字 height=1 保留 | avatar styles：I26722:8947;26711:7105 / I26722:9195;26722:7351;26711:7140 |
| M010 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.small => token?.fontMarkMedium?.size ?? 14,` | 修正：语义字体来源 | 中号 Title/Medium；小号 Title/Small，替换同值 Mark；单字 height=1 保留 | avatar styles：I26722:8947;26711:7105 / I26722:9195;26722:7351;26711:7140 |
| M011 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.large => token?.fontTitleExtraLarge?.fontWeight,` | 待确认：已恢复默认 | 大号字符固定 20 / w600；不能用页标题的 Title/ExtraLarge 样式证明头像绑定 | Spec034/060；采样未定位大号头像文字节点 |
| M012 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.medium => token?.fontMarkLarge?.fontWeight,` | 修正：语义字体来源 | 中号 Title/Medium；小号 Title/Small，替换同值 Mark；单字 height=1 保留 | avatar styles：I26722:8947;26711:7105 / I26722:9195;26722:7351;26711:7140 |
| M013 | `avatar/t_avatar_defaults.dart`<br>`TAvatarSize.small => token?.fontMarkMedium?.fontWeight,` | 修正：语义字体来源 | 中号 Title/Medium；小号 Title/Small，替换同值 Mark；单字 height=1 保留 | avatar styles：I26722:8947;26711:7105 / I26722:9195;26722:7351;26711:7140 |
| M014 | `backtop/t_backtop.dart`<br>`roundSize: theme.roundSize ?? token.size13,` | 保留：节点绑定 | 圆形48、半圆高40、水平padding8、gap2 | backtop：26631:6440、26631:6475 / comp-size、paddingLR/s、margin/xxs |
| M015 | `backtop/t_backtop.dart`<br>`halfCircleHeight: theme.halfCircleHeight ?? token.size12,` | 保留：节点绑定 | 圆形48、半圆高40、水平padding8、gap2 | backtop：26631:6440、26631:6475 / comp-size、paddingLR/s、margin/xxs |
| M016 | `backtop/t_backtop.dart`<br>`iconSize: theme.iconSize ?? token.size7,` | 修正：用户跨端默认裁定 | BackTop图标默认22；组件iconSize优先；无匹配全局size，保持独立默认 | 用户2026-10-16明确采用小程序默认；22/25不使用加减或比例拼接Token，20与size7一致 |
| M017 | `backtop/t_backtop.dart`<br>`theme.halfCircleHorizontalPadding ?? token.size4,` | 保留：节点绑定 | 圆形48、半圆高40、水平padding8、gap2 | backtop：26631:6440、26631:6475 / comp-size、paddingLR/s、margin/xxs |
| M018 | `backtop/t_backtop.dart`<br>`contentGap: theme.contentGap ?? token.size1,` | 保留：节点绑定 | 圆形48、半圆高40、水平padding8、gap2 | backtop：26631:6440、26631:6475 / comp-size、paddingLR/s、margin/xxs |
| M019 | `badge/t_badge_label.dart`<br>`final smallCornerScale = context.tTheme.radiusSmall / 3;` | 修正：用户设计裁定（square） | square直接读取radiusSmall，默认3；原公式涉及的bubble尖角仍固定1 | 用户2026-10-16裁定以指定设计稿为准；Badge节点27741:30861、25181:19264绑定radius-default=3，适配当前Flutter3px档radiusSmall；尖角未裁定 |
| M020 | `badge/t_badge_label.dart`<br>`final largeCornerScale = context.tTheme.radiusLarge / 9;` | 组件配置已补齐：未新增全局映射 | bubble默认普通角10、左下1；可由TBadgeThemeData.bubbleBorderRadius覆盖，不绑定全局radius；square仍为radiusSmall默认3 | 小程序badge.less的--td-badge-bubble-border-radius；原全局圆角绑定仍无依据；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md |
| M021 | `badge/t_badge_resolved_style.dart`<br>`final smallSize = tBadgeTheme?.dotSize ?? token.size4;` | 修正：用户授权一致刻度 | Badge圆点直径读取size4，默认8不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M022 | `badge/t_badge_resolved_style.dart`<br>`EdgeInsets.symmetric(horizontal: large ? token.size3 : token.size2);` | 待确认：已恢复默认 | medium/large水平padding分别4/6，显式padding优先 | 缺少这两个padding到size刻度的绑定；square圆角裁定不涉及padding |
| M023 | `button/t_button_resolve.dart`<br>`TButtonSize.large \|\| TButtonSize.medium => token.fontMarkLarge,` | 保留：组件规范 | MarkLarge / MarkMedium | Spec009；既有 Button 字体契约 |
| M024 | `button/t_button_resolve.dart`<br>`TButtonSize.small \|\| TButtonSize.extraSmall => token.fontMarkMedium,` | 保留：组件规范 | MarkLarge / MarkMedium | Spec009；既有 Button 字体契约 |
| M025 | `button/t_button_resolve.dart`<br>`TButtonSize.large => token.size13,` | 保留：节点绑定 | 四档高度 48/40/32/28；水平 padding 20/16/12/8 | button height→comp-size/xxl、xl、m、s；padding→size/7、paddingLR/l、m、s |
| M026 | `button/t_button_resolve.dart`<br>`TButtonSize.medium => token.size12,` | 保留：节点绑定 | 四档高度 48/40/32/28；水平 padding 20/16/12/8 | button height→comp-size/xxl、xl、m、s；padding→size/7、paddingLR/l、m、s |
| M027 | `button/t_button_resolve.dart`<br>`TButtonSize.small => token.size10,` | 保留：节点绑定 | 四档高度 48/40/32/28；水平 padding 20/16/12/8 | button height→comp-size/xxl、xl、m、s；padding→size/7、paddingLR/l、m、s |
| M028 | `button/t_button_resolve.dart`<br>`TButtonSize.extraSmall => token.size9,` | 保留：节点绑定 | 四档高度 48/40/32/28；水平 padding 20/16/12/8 | button height→comp-size/xxl、xl、m、s；padding→size/7、paddingLR/l、m、s |
| M029 | `button/t_button_resolve.dart`<br>`TButtonSize.large => token.size7,` | 保留：节点绑定 | 四档高度 48/40/32/28；水平 padding 20/16/12/8 | button height→comp-size/xxl、xl、m、s；padding→size/7、paddingLR/l、m、s |
| M030 | `button/t_button_resolve.dart`<br>`TButtonSize.medium => token.size6,` | 保留：节点绑定 | 四档高度 48/40/32/28；水平 padding 20/16/12/8 | button height→comp-size/xxl、xl、m、s；padding→size/7、paddingLR/l、m、s |
| M031 | `button/t_button_resolve.dart`<br>`TButtonSize.small => token.size5,` | 保留：节点绑定 | 四档高度 48/40/32/28；水平 padding 20/16/12/8 | button height→comp-size/xxl、xl、m、s；padding→size/7、paddingLR/l、m、s |
| M032 | `button/t_button_resolve.dart`<br>`TButtonSize.extraSmall => token.size4,` | 保留：节点绑定 | 四档高度 48/40/32/28；水平 padding 20/16/12/8 | button height→comp-size/xxl、xl、m、s；padding→size/7、paddingLR/l、m、s |
| M033 | `button/t_button_resolve.dart`<br>`TButtonSize.large => token.size8,` | 修正：用户授权一致刻度 | Button大档图标读取size8，默认24不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M034 | `button/t_button_resolve.dart`<br>`TButtonSize.medium => token.size7,` | 修正：用户授权一致刻度 | Button中档图标读取size7，默认20不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M035 | `button/t_button_resolve.dart`<br>`TButtonSize.small \|\| TButtonSize.extraSmall => token.size7 - 2,` | 组件配置已补齐：未新增全局映射 | 小/超小图标默认18；可由TButtonThemeData分档字段覆盖，ButtonStyle.iconSize仍优先；不以size7-2拟合 | 小程序button.less的--td-button-small/extra-small-icon-size默认36rpx；没有18dp全局size档；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md |
| M036 | `cell/t_cell_group.dart`<br>`EdgeInsets.symmetric(horizontal: context.tTheme.spacer2)` | 待确认：已恢复默认 | cardPadding保持16且组件Theme优先；卡片圆角已另经用户裁定为radiusLarge默认9，不再属于本项缺口 | Cell已取绑定见证属于内部Cell内容，不能证明card容器padding的全局来源 |
| M037 | `cell/t_cell_group.dart`<br>`BorderRadius.circular(context.tTheme.radiusLarge * (8 / 9))` | 修正：用户尺寸裁定 | Cell card圆角读取radiusLarge，默认9；cardBorderRadius显式值优先，cardPadding不变 | 用户2026-10-16确认9；小程序cell-group--card直接引用radius-large；不再使用8/9比例 |
| M038 | `checkbox/t_check_box.dart`<br>`final radius = BorderRadius.circular(context.tTheme.radiusSmall / 2);` | 撤回：规范冲突 | 方形指示器1.5px；不借用 radiusSmall/2 | Spec046明确1.5；新设计未取得指示器角的绑定 |
| M039 | `drawer/t_drawer_content.dart`<br>`context.tTheme.size6,` | 保留：节点绑定 | 标题16/24/16/8，列表padding16、图文gap8 | drawer：27362:23975 的 title / 27362:23857 的 item-title，paddingLR/TB、margin/s |
| M040 | `drawer/t_drawer_content.dart`<br>`context.tTheme.size8,` | 保留：节点绑定 | 标题16/24/16/8，列表padding16、图文gap8 | drawer：27362:23975 的 title / 27362:23857 的 item-title，paddingLR/TB、margin/s |
| M041 | `drawer/t_drawer_content.dart`<br>`context.tTheme.size6,` | 保留：节点绑定 | 标题16/24/16/8，列表padding16、图文gap8 | drawer：27362:23975 的 title / 27362:23857 的 item-title，paddingLR/TB、margin/s |
| M042 | `drawer/t_drawer_content.dart`<br>`context.tTheme.size4,` | 保留：节点绑定 | 标题16/24/16/8，列表padding16、图文gap8 | drawer：27362:23975 的 title / 27362:23857 的 item-title，paddingLR/TB、margin/s |
| M043 | `drawer/t_drawer_content.dart`<br>`context.tTheme.size6,` | 保留：节点绑定 | 标题16/24/16/8，列表padding16、图文gap8 | drawer：27362:23975 的 title / 27362:23857 的 item-title，paddingLR/TB、margin/s |
| M044 | `drawer/t_drawer_content.dart`<br>`context.tTheme.size6,` | 保留：节点绑定 | 标题16/24/16/8，列表padding16、图文gap8 | drawer：27362:23975 的 title / 27362:23857 的 item-title，paddingLR/TB、margin/s |
| M045 | `drawer/t_drawer_content.dart`<br>`context.tTheme.size6,` | 保留：节点绑定 | 标题16/24/16/8，列表padding16、图文gap8 | drawer：27362:23975 的 title / 27362:23857 的 item-title，paddingLR/TB、margin/s |
| M046 | `drawer/t_drawer_content.dart`<br>`drawerTheme?.itemIconSize ?? context.tTheme.size8,` | 修正：用户授权一致刻度 | Drawer菜单图标读取size8，默认24不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M047 | `drawer/t_drawer_content.dart`<br>`iconGap: drawerTheme?.itemIconGap ?? context.tTheme.size4,` | 保留：节点绑定 | 标题16/24/16/8，列表padding16、图文gap8 | drawer：27362:23975 的 title / 27362:23857 的 item-title，paddingLR/TB、margin/s |
| M048 | `dropdown_menu/t_dropdown_item.dart`<br>`constraints: BoxConstraints(minHeight: context.tTheme.size12),` | 待确认：已恢复默认 | 恢复本轮新增映射前的组件规格，不添加公开token | 该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定 |
| M049 | `dropdown_menu/t_dropdown_menu.dart`<br>`? BoxConstraints(minHeight: context.tTheme.size13)` | 修正：用户授权一致刻度 | Dropdown栏最小高度读取size13，默认48不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M050 | `dropdown_menu/t_dropdown_menu.dart`<br>`size: theme.iconSize ?? context.tTheme.size8,` | 修正：用户跨端默认裁定 | Dropdown触发箭头读取size7，默认20；组件iconSize优先 | 用户2026-10-16明确采用小程序默认；22/25不使用加减或比例拼接Token，20与size7一致 |
| M051 | `loading/t_loading.dart`<br>`? SizedBox(height: context.tTheme.size3)` | 修正：用户授权一致刻度 | Loading纵向图文间距读取size3，默认6不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M052 | `loading/t_loading.dart`<br>`: SizedBox(width: context.tTheme.size4),` | 保留：节点绑定 | 横向gap8 → size4 | loading：26799:11081 / margin/s → size4 |
| M053 | `loading/t_loading.dart`<br>`SizedBox(width: context.tTheme.size4),` | 保留：节点绑定 | 横向gap8 → size4 | loading：26799:11081 / margin/s → size4 |
| M054 | `message/t_message.dart`<br>`padding: EdgeInsets.symmetric(horizontal: context.tTheme.size6),` | 待确认：已恢复默认 | 恢复本轮新增映射前的组件规格，不添加公开token | 该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定 |
| M055 | `refresh/t_pull_down_refresh.dart`<br>`child: TLoading(size: context.tTheme.size8, text: text),` | 修正：用户跨端默认裁定 | Refresh内置Loading尺寸默认25；无匹配全局size，保持独立默认 | 用户2026-10-16明确采用小程序默认；22/25不使用加减或比例拼接Token，20与size7一致 |
| M056 | `search/t_search_bar.dart`<br>`var height = theme?.height ?? token.size12;` | 修正：用户授权一致刻度 | Search默认最小高度读取size12，默认40不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M057 | `search/t_search_bar.dart`<br>`theme?.contentPadding ?? EdgeInsets.symmetric(horizontal: token.size5);` | 保留：节点绑定 | 内部水平padding12 → size5 | search：I27771:32133;27771:31347 / paddingLR/m |
| M058 | `search/t_search_bar.dart`<br>`size: token.size8,` | 修正：用户授权一致刻度 | Search图标主题默认字段；前缀自身20不受它接管读取size8，默认24不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M059 | `search/t_search_bar.dart`<br>`size: token.size8,` | 修正：用户授权一致刻度 | Search清除图标读取size8，默认24不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M060 | `search/t_search_bar.dart`<br>`searchIconTheme.size ?? token.size8,` | 修正：用户授权一致刻度 | Search搜索图标预留的布局回退读取size8，默认24不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M061 | `search/t_search_bar.dart`<br>`clearIconTheme.size ?? token.size8,` | 修正：用户授权一致刻度 | Search清除图标预留的布局回退读取size8，默认24不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M062 | `search/t_search_bar.dart`<br>`child: TInternalIcon(TIcons.search, size: token.size7),` | 待确认：已恢复默认 | 高度40、图标24/20、清除区域32；现有组件 Theme 优先 | Search 40可能由排版计算；没有这些属性直接绑定见证 |
| M063 | `search/t_search_bar.dart`<br>`width: token.size10,` | 待确认：已恢复默认 | 高度40、图标24/20、清除区域32；现有组件 Theme 优先 | Search 40可能由排版计算；没有这些属性直接绑定见证 |
| M064 | `sidebar/t_wrap_sidebar_item.dart`<br>`topAdjacent ? context.tTheme.radiusLarge : 0,` | 待确认：已恢复默认 | line相邻项反向圆角仍为9；不读取radiusLarge或radiusDefault | 尚未取得相邻项反向角的绑定；用户本次只裁定M069的tag选中内块 |
| M065 | `sidebar/t_wrap_sidebar_item.dart`<br>`bottomAdjacent ? context.tTheme.radiusLarge : 0,` | 待确认：已恢复默认 | line相邻项反向圆角仍为9；不读取radiusLarge或radiusDefault | 尚未取得相邻项反向角的绑定；用户本次只裁定M069的tag选中内块 |
| M066 | `sidebar/t_wrap_sidebar_item.dart`<br>`padding: contentPadding ?? EdgeInsets.all(context.tTheme.size6),` | 保留：节点绑定 | line padding16；tag 外/内 padding8 | sidebar item/line → paddingLR/TB/l；item/tag → paddingLR/TB/s |
| M067 | `sidebar/t_wrap_sidebar_item.dart`<br>`constraints: BoxConstraints(minHeight: context.tTheme.size14),` | 待确认：已恢复默认 | tag最小高度仍为56，不接入size14 | 未取得该高度的直接绑定；M069的圆角裁定不涉及高度 |
| M068 | `sidebar/t_wrap_sidebar_item.dart`<br>`padding: EdgeInsets.all(context.tTheme.size4),` | 保留：节点绑定 | line padding16；tag 外/内 padding8 | sidebar item/line → paddingLR/TB/l；item/tag → paddingLR/TB/s |
| M069 | `sidebar/t_wrap_sidebar_item.dart`<br>`borderRadius: BorderRadius.circular(context.tTheme.radiusLarge),` | 修正：用户设计裁定 | tag选中内块读取radiusDefault，默认6；相邻项反向角9及最小高56不变 | 用户2026-10-16裁定以指定设计稿为准；I27264:21535;27264:20989;27273:20750绑定radius-medium=6，适配Flutter6px档radiusDefault |
| M070 | `sidebar/t_wrap_sidebar_item.dart`<br>`padding: contentPadding ?? EdgeInsets.all(context.tTheme.size4),` | 保留：节点绑定 | line padding16；tag 外/内 padding8 | sidebar item/line → paddingLR/TB/l；item/tag → paddingLR/TB/s |
| M071 | `stepper/t_stepper.dart`<br>`? token.size7 / 20` | 修正：删除整体缩放 | 控件/输入区/图标恢复既有规格；另将真实 gap4 接到 size2 | stepper 无三项几何同比缩放绑定；itemSpacing→margin/xs→size2 |
| M072 | `stepper/t_stepper.dart`<br>`: token.size8 / 24;` | 修正：删除整体缩放 | 控件/输入区/图标恢复既有规格；另将真实 gap4 接到 size2 | stepper 无三项几何同比缩放绑定；itemSpacing→margin/xs→size2 |
| M073 | `stepper/t_stepper.dart`<br>`TStepperSize.small => token.fontBodyExtraSmall,` | 保留：文字样式绑定 | 小 BodyExtraSmall、中 BodySmall、大 BodyLarge | stepper styles：26631:6771、6769、6767 |
| M074 | `stepper/t_stepper.dart`<br>`TStepperSize.medium => token.fontBodySmall,` | 保留：文字样式绑定 | 小 BodyExtraSmall、中 BodySmall、大 BodyLarge | stepper styles：26631:6771、6769、6767 |
| M075 | `stepper/t_stepper.dart`<br>`TStepperSize.large => token.fontBodyLarge,` | 保留：文字样式绑定 | 小 BodyExtraSmall、中 BodySmall、大 BodyLarge | stepper styles：26631:6771、6769、6767 |
| M076 | `steps/t_steps_horizontal_item.dart`<br>`size: context.tTheme.size6,` | 待确认：已恢复默认 | 恢复本轮新增映射前的组件规格，不添加公开token | 该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定 |
| M077 | `steps/t_steps_vertical_item.dart`<br>`size: context.tTheme.size6,` | 待确认：已恢复默认 | 恢复本轮新增映射前的组件规格，不添加公开token | 该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定 |
| M078 | `steps/t_steps_vertical_item.dart`<br>`size: context.tTheme.size6,` | 待确认：已恢复默认 | 恢复本轮新增映射前的组件规格，不添加公开token | 该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定 |
| M079 | `swiper/t_swiper.dart`<br>`constraints: BoxConstraints(minHeight: context.tTheme.size8),` | 修正：用户授权一致刻度 | Swiper分数框最小高度读取size8，默认24不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M080 | `swiper/t_swiper.dart`<br>`padding: EdgeInsets.symmetric(horizontal: context.tTheme.size4),` | 待确认：已恢复默认 | 恢复本轮新增映射前的组件规格，不添加公开token | 该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定 |
| M081 | `switch/t_switch.dart`<br>`TSwitchSize.large => context.tTheme.size10 / 32,` | 修正：只控制绑定属性 | size10/9/8只控制高度32/28/24；宽度保持独立；绘制适配 | switch height→comp-size/m、s、xs；未找到宽度随高度变化绑定 |
| M082 | `switch/t_switch.dart`<br>`TSwitchSize.medium => context.tTheme.size9 / 28,` | 修正：只控制绑定属性 | size10/9/8只控制高度32/28/24；宽度保持独立；绘制适配 | switch height→comp-size/m、s、xs；未找到宽度随高度变化绑定 |
| M083 | `switch/t_switch.dart`<br>`TSwitchSize.small => context.tTheme.size8 / 24,` | 修正：只控制绑定属性 | size10/9/8只控制高度32/28/24；宽度保持独立；绘制适配 | switch height→comp-size/m、s、xs；未找到宽度随高度变化绑定 |
| M084 | `tabbar/t_tab_bar.dart`<br>`_effectiveBarHeight = theme?.barHeight ?? context.tTheme.size14;` | 保留：节点绑定 | barHeight 默认 size14=56，显式 barHeight 优先 | tabbar：26969:13458 / height→comp-size/xxxl |
| M085 | `tabbar/t_tab_bar.dart`<br>`return context.tTheme.size14;` | 保留：节点绑定 | barHeight 默认 size14=56，显式 barHeight 优先 | tabbar：26969:13458 / height→comp-size/xxxl |
| M086 | `tabbar/t_tab_bar.dart`<br>`var height = context.tTheme.size14;` | 保留：节点绑定 | barHeight 默认 size14=56，显式 barHeight 优先 | tabbar：26969:13458 / height→comp-size/xxxl |
| M087 | `table/t_table.dart`<br>`EdgeInsets.symmetric(horizontal: context.tTheme.size6),` | 修正：用户尺寸裁定 | Table表头和数据单元格水平padding读取spacer1，默认12；上下仍0；cellPadding显式值优先 | 用户2026-10-16确认12；小程序td/th padding为spacer、spacer1，当前只迁移已裁定的水平属性 |
| M088 | `tabs/t_horizontal_tab_bar.dart`<br>`? BoxConstraints(minHeight: context.tTheme.size10)` | 修正：用户授权一致刻度 | Tabs tag最小高度读取size10，默认32不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M089 | `tabs/t_horizontal_tab_bar.dart`<br>`horizontal: context.tTheme.size4,` | 修正：用户尺寸裁定 | Tabs tag内框水平padding读取spacer2，默认16；上下0、最小高32及外层labelPadding不变 | 用户2026-10-16确认16；小程序item-inner--tag水平padding直接引用spacer2 |
| M090 | `tag/t_tag.dart`<br>`hPadding = context.tTheme.size6;` | 组件配置已补齐：未新增全局映射 | 超大档原始横16/纵9，按实际边框补偿；extraLargePadding可指定净间距，统一padding优先 | 小程序tag.less的--td-tag-extra-large-padding；保留Flutter原盒模型，不新增全局绑定；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md |
| M091 | `tag/t_tag.dart`<br>`hPadding = context.tTheme.size4;` | 组件配置已补齐：未新增全局映射 | 大档原始横8/纵3，按实际边框补偿；largePadding可指定净间距，统一padding优先 | 小程序tag.less的--td-tag-large-padding；保留Flutter原盒模型，不新增全局绑定；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md |
| M092 | `tag/t_tag.dart`<br>`hPadding = context.tTheme.size4;` | 组件配置已补齐：未新增全局映射 | 中档原始横8/纵2，按实际边框补偿；mediumPadding可指定净间距，统一padding优先 | 小程序tag.less的--td-tag-medium-padding；保留Flutter原盒模型，不新增全局绑定；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md |
| M093 | `tag/t_tag.dart`<br>`hPadding = context.tTheme.size3;` | 组件配置已补齐：未新增全局映射 | 小档原始横6/纵2，按实际边框补偿；smallPadding可指定净间距，统一padding优先 | 小程序tag.less的--td-tag-small-padding；保留Flutter原盒模型，不新增全局绑定；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md |
| M094 | `time_counter/t_time_counter_style.dart`<br>`size: context.tTheme.fontSizeTitleLarge.round(),` | 待确认：已恢复默认 | 恢复本轮新增映射前的组件规格，不添加公开token | 该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定 |
| M095 | `time_counter/t_time_counter_style.dart`<br>`lineHeight: context.tTheme.lineHeightTitleLarge.round(),` | 待确认：已恢复默认 | 恢复本轮新增映射前的组件规格，不添加公开token | 该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定 |
| M096 | `time_counter/t_time_counter_style.dart`<br>`blockExtent = context.tTheme.size7;` | 修正：用户授权一致刻度 | CountDown小号背景块读取size7，默认20不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M097 | `time_counter/t_time_counter_style.dart`<br>`blockExtent = context.tTheme.size8;` | 修正：用户授权一致刻度 | CountDown中号背景块读取size8，默认24不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M098 | `time_counter/t_time_counter_style.dart`<br>`blockExtent = context.tTheme.size9;` | 修正：用户授权一致刻度 | CountDown大号背景块读取size9，默认28不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M099 | `toast/t_toast.dart`<br>`const EdgeInsets.fromLTRB(22, 14, 22, 14) * (theme.size8 / 24),` | 修正：独立属性绑定 | 左右size8=24、上下size6=16；删除密度比例，默认有意改为24/16 | toast：26833:11129 / paddingLR/xl、paddingTB/l |
| M100 | `toast/t_toast.dart`<br>`size: toastTheme.iconSize ?? context.tTheme.size8,` | 修正：用户授权一致刻度 | Toast横向图标读取size8，默认24不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M101 | `toast/t_toast.dart`<br>`padding: toastTheme.padding ?? EdgeInsets.all(context.tTheme.size8),` | 保留：节点绑定 | 列布局padding24、加载水平padding24；组件 padding 优先 | toast：26833:11142 / paddingLR/xl、paddingTB/xl |
| M102 | `toast/t_toast.dart`<br>`size: toastTheme.iconSize ?? context.tTheme.size10,` | 修正：用户授权一致刻度 | Toast纵向图标读取size10，默认32不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M103 | `toast/t_toast.dart`<br>`EdgeInsets.symmetric(horizontal: context.tTheme.size8),` | 保留：节点绑定 | 列布局padding24、加载水平padding24；组件 padding 优先 | toast：26833:11142 / paddingLR/xl、paddingTB/xl |
| M104 | `toast/t_toast.dart`<br>`size: toastTheme.iconSize ?? context.tTheme.size10,` | 修正：用户授权一致刻度 | Toast加载图标读取size10，默认32不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M105 | `toast/t_toast.dart`<br>`padding: toastTheme.padding ?? EdgeInsets.all(context.tTheme.size8),` | 保留：节点绑定 | 列布局padding24、加载水平padding24；组件 padding 优先 | toast：26833:11142 / paddingLR/xl、paddingTB/xl |
| M106 | `toast/t_toast.dart`<br>`size: toastTheme.iconSize ?? context.tTheme.size10,` | 修正：用户授权一致刻度 | Toast无文字加载图标读取size10，默认32不变；已有显式入口优先 | 用户2026-10-16授权固定默认也可使用一致Token；小程序同一属性固定默认与现有基础size档完全一致；新增Flutter依赖，不冒称上游全局引用 |
| M107 | `toast/t_toast.dart`<br>`const EdgeInsets.fromLTRB(22, 14, 22, 14) * (theme.size8 / 24),` | 修正：独立属性绑定 | 左右size8=24、上下size6=16；删除密度比例，默认有意改为24/16 | toast：26833:11129 / paddingLR/xl、paddingTB/l |
| M108 | `tree/t_tree_select.dart`<br>`size: Size.square(context.tTheme.radiusLarge),` | 待确认：已恢复默认 | 反向角9、文字右12、操作槽56、图标24 | 已取节点的圆角属于叶选中内框，不证明根项反向角；其他属性无对应绑定 |
| M109 | `tree/t_tree_select.dart`<br>`size: Size.square(context.tTheme.radiusLarge),` | 待确认：已恢复默认 | 反向角9、文字右12、操作槽56、图标24 | 已取节点的圆角属于叶选中内框，不证明根项反向角；其他属性无对应绑定 |
| M110 | `tree/t_tree_select.dart`<br>`left: context.tTheme.size6,` | 保留：节点绑定 | 根项左侧padding16 → size6 | tree：27449:25774 / paddingLeft→paddingLR/l |
| M111 | `tree/t_tree_select.dart`<br>`right: context.tTheme.size5,` | 待确认：已恢复默认 | 反向角9、文字右12、操作槽56、图标24 | 已取节点的圆角属于叶选中内框，不证明根项反向角；其他属性无对应绑定 |
| M112 | `tree/t_tree_select.dart`<br>`width: context.tTheme.size14,` | 待确认：已恢复默认 | 反向角9、文字右12、操作槽56、图标24 | 已取节点的圆角属于叶选中内框，不证明根项反向角；其他属性无对应绑定 |
| M113 | `tree/t_tree_select.dart`<br>`size: context.tTheme.size8,` | 待确认：已恢复默认 | 反向角9、文字右12、操作槽56、图标24 | 已取节点的圆角属于叶选中内框，不证明根项反向角；其他属性无对应绑定 |
| M114 | `stepper/t_stepper.dart`<br>`spacing: componentTheme?.spacing ?? token.size2` | 补齐：节点绑定 | normal/filled gap4 → size2；不缩放控件/输入区/图标 | stepper itemSpacing → margin/xs → size2；theme spacing 优先 |

## 缺少依据及冲突项（单列）

- M001：avatar/t_avatar.dart，`: context.tTheme.shadowAvatarGroup ?? [TAvatarDefaults.groupShadow],`。Spec034/048；未取得组件效果绑定；保留 groupShadow / 内置头像层叠投影；不合成全局阴影别名。
- M007：小号内置图标保持20，组件iconSize优先；大/中号已分别接入size10/size8。Spec034/060；avatar 图标尺寸无绑定见证。
- M008：avatar/t_avatar_defaults.dart，`TAvatarSize.large => token?.fontTitleExtraLarge?.size ?? 20,`。Spec034/060；采样未定位大号头像文字节点；大号字符固定 20 / w600；不能用页标题的 Title/ExtraLarge 样式证明头像绑定。
- M011：avatar/t_avatar_defaults.dart，`TAvatarSize.large => token?.fontTitleExtraLarge?.fontWeight,`。Spec034/060；采样未定位大号头像文字节点；大号字符固定 20 / w600；不能用页标题的 Title/ExtraLarge 样式证明头像绑定。
- M020：bubble默认普通角10、左下1；可由TBadgeThemeData.bubbleBorderRadius覆盖，不绑定全局radius；square仍为radiusSmall默认3。小程序badge.less的--td-badge-bubble-border-radius；原全局圆角绑定仍无依据；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md。
- M022：badge/t_badge_resolved_style.dart，`EdgeInsets.symmetric(horizontal: large ? token.size3 : token.size2);`。缺少这两个padding到size刻度的绑定；square圆角裁定不涉及padding；medium/large水平padding分别4/6，显式padding优先。
- M035：小/超小图标默认18；可由TButtonThemeData分档字段覆盖，ButtonStyle.iconSize仍优先；不以size7-2拟合。小程序button.less的--td-button-small/extra-small-icon-size默认36rpx；没有18dp全局size档；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md。
- M036：cardPadding保持16且组件Theme优先；卡片圆角已另经用户裁定为radiusLarge默认9，不再属于本项缺口。Cell已取绑定见证属于内部Cell内容，不能证明card容器padding的全局来源。
- M038：checkbox/t_check_box.dart，`final radius = BorderRadius.circular(context.tTheme.radiusSmall / 2);`。Spec046明确1.5；新设计未取得指示器角的绑定；方形指示器1.5px；不借用 radiusSmall/2。
- M048：dropdown_menu/t_dropdown_item.dart，`constraints: BoxConstraints(minHeight: context.tTheme.size12),`。该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定；恢复本轮新增映射前的组件规格，不添加公开token。
- M054：message/t_message.dart，`padding: EdgeInsets.symmetric(horizontal: context.tTheme.size6),`。该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定；恢复本轮新增映射前的组件规格，不添加公开token。
- M062：search/t_search_bar.dart，`child: TInternalIcon(TIcons.search, size: token.size7),`。Search 40可能由排版计算；没有这些属性直接绑定见证；高度40、图标24/20、清除区域32；现有组件 Theme 优先。
- M063：search/t_search_bar.dart，`width: token.size10,`。Search 40可能由排版计算；没有这些属性直接绑定见证；高度40、图标24/20、清除区域32；现有组件 Theme 优先。
- M064：sidebar/t_wrap_sidebar_item.dart，`topAdjacent ? context.tTheme.radiusLarge : 0,`。尚未取得相邻项反向角的绑定；用户本次只裁定M069的tag选中内块；line相邻项反向圆角仍为9；不读取radiusLarge或radiusDefault。
- M065：sidebar/t_wrap_sidebar_item.dart，`bottomAdjacent ? context.tTheme.radiusLarge : 0,`。尚未取得相邻项反向角的绑定；用户本次只裁定M069的tag选中内块；line相邻项反向圆角仍为9；不读取radiusLarge或radiusDefault。
- M067：sidebar/t_wrap_sidebar_item.dart，`constraints: BoxConstraints(minHeight: context.tTheme.size14),`。未取得该高度的直接绑定；M069的圆角裁定不涉及高度；tag最小高度仍为56，不接入size14。
- M076：steps/t_steps_horizontal_item.dart，`size: context.tTheme.size6,`。该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定；恢复本轮新增映射前的组件规格，不添加公开token。
- M077：steps/t_steps_vertical_item.dart，`size: context.tTheme.size6,`。该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定；恢复本轮新增映射前的组件规格，不添加公开token。
- M078：steps/t_steps_vertical_item.dart，`size: context.tTheme.size6,`。该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定；恢复本轮新增映射前的组件规格，不添加公开token。
- M080：swiper/t_swiper.dart，`padding: EdgeInsets.symmetric(horizontal: context.tTheme.size4),`。该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定；恢复本轮新增映射前的组件规格，不添加公开token。
- M090：超大档原始横16/纵9，按实际边框补偿；extraLargePadding可指定净间距，统一padding优先。小程序tag.less的--td-tag-extra-large-padding；保留Flutter原盒模型，不新增全局绑定；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md。
- M091：大档原始横8/纵3，按实际边框补偿；largePadding可指定净间距，统一padding优先。小程序tag.less的--td-tag-large-padding；保留Flutter原盒模型，不新增全局绑定；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md。
- M092：中档原始横8/纵2，按实际边框补偿；mediumPadding可指定净间距，统一padding优先。小程序tag.less的--td-tag-medium-padding；保留Flutter原盒模型，不新增全局绑定；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md。
- M093：小档原始横6/纵2，按实际边框补偿；smallPadding可指定净间距，统一padding优先。小程序tag.less的--td-tag-small-padding；保留Flutter原盒模型，不新增全局绑定；固定提交a9f3ba680481d438b0be37e2e25cf4a62cf0acb3，详见component-token-mapping.md。
- M094：time_counter/t_time_counter_style.dart，`size: context.tTheme.fontSizeTitleLarge.round(),`。该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定；恢复本轮新增映射前的组件规格，不添加公开token。
- M095：time_counter/t_time_counter_style.dart，`lineHeight: context.tTheme.lineHeightTitleLarge.round(),`。该页受 Figma 调用额度限制未读取；现有规范仅能证明数值，不能证明当前绑定；恢复本轮新增映射前的组件规格，不添加公开token。
- M108：tree/t_tree_select.dart，`size: Size.square(context.tTheme.radiusLarge),`。已取节点的圆角属于叶选中内框，不证明根项反向角；其他属性无对应绑定；反向角9、文字右12、操作槽56、图标24。
- M109：tree/t_tree_select.dart，`size: Size.square(context.tTheme.radiusLarge),`。已取节点的圆角属于叶选中内框，不证明根项反向角；其他属性无对应绑定；反向角9、文字右12、操作槽56、图标24。
- M111：tree/t_tree_select.dart，`right: context.tTheme.size5,`。已取节点的圆角属于叶选中内框，不证明根项反向角；其他属性无对应绑定；反向角9、文字右12、操作槽56、图标24。
- M112：tree/t_tree_select.dart，`width: context.tTheme.size14,`。已取节点的圆角属于叶选中内框，不证明根项反向角；其他属性无对应绑定；反向角9、文字右12、操作槽56、图标24。
- M113：tree/t_tree_select.dart，`size: context.tTheme.size8,`。已取节点的圆角属于叶选中内框，不证明根项反向角；其他属性无对应绑定；反向角9、文字右12、操作槽56、图标24。

M019的square部分与M069已按用户设计裁定落实；M020已补齐组件气泡圆角配置，仍不建立全局radius绑定。M020、M035、M090..M093的组件字段均有小程序来源，详见[组件级清单](component-token-mapping.md)；未扩展站点控制器。

## 后续需要的裁定

未读取的7页需要读取实际绑定；Table需要其对应设计节点；已读取但没有属性绑定的尺寸需要组件规范或绑定实例；Badge square和SideBar tag选中块已按用户裁定迁移；其余圆角的设计版本差异仍需确认。除已授权的组件级字段外，当前不会新增无依据的全局引用或合成别名。

## 测试标准调整

本轮新增独立属性与反向隔离断言：Avatar Title 与 Mark 不混用；Switch 的实际绘制高度改变而宽度不变；Stepper gap可变但无关尺寸不缩放几何；Toast横纵padding独立；Badge/Checkbox/Cell的专有几何与AvatarGroup阴影不受无关全局token接管。57页矩阵仅验证实际支持的链路，不能作为设计绑定依据。

## 转换层与布局推导（不计入114个组件消费点）

| 改动 | 决策与证据 |
| --- | --- |
| 新增size1..16 / sizeMap | 保留；design-variables.json记录了16个基础尺寸及comp-size、padding、margin的alias链。集合存在证明刻度可用，具体消费者仍逐字段判断。 |
| 字体族与fallback解析 | 保留；设计有字体族变量，CSS字体栈的拆分与fallback是输入解析能力，不新增组件依赖。 |
| 独立字号、行高和mobile层级 | 保留；对应设计font变量的Title/Body/Mark命名；独立字段转换不应捆绑其他维度。 |
| shadow1合成shadowAvatarGroup | 删除；没有已取得的映射依据，组件原groupShadow配置继续有效。 |
| Button纵向/纯图标padding从有效高度、行盒/图标推导 | 保留；属于同一按钮盒内的居中布局约束，不是借用别的刻度作密度倍率；见Spec009和实际组件断言。 |
| 浮层主题持续继承 | 保留；修正主题生命周期，不创造新的样式语义。 |

既有converter的spacer映射是当前基线已有契约（Spec044），本表不把其既有比例推定为本次设计稿已验证，也没有据此为新组件构造更多比例。
