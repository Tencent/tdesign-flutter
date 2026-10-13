# TD 内置样式所有权

## 目标与行为契约

TD 内置视觉和行为只接受受支持的实例参数/style、TD ThemeExtension 和 Token。外部 M2/M3 默认及显式主题不作为隐式配置入口。内部可以使用 Material 原生控件，但必须明确视觉及可配置行为的默认值。调用方自定义内容使用原始主题，组件已公开的内容默认样式继续提供。

- Button/IconButton 反馈、鼠标指针按实例/TD Theme 当前状态的非空值回退到 TD 内部默认值，不再读取 Material 按钮主题。Button.style.visualDensity 仍不生效。
- Tooltip 的文字、装饰、尺寸、时长、触发、反馈和语义由内部明确；不透传 TooltipTheme。自定义内容中的 Tooltip 不受影响。
- 内部编辑器的选择颜色、手柄和默认自适应菜单隔离外部视觉主题；保留选择、编辑、剪贴板、平台菜单操作、键盘、控制器、焦点和语义。前后缀不进入编辑器隔离范围。
- TText 默认选择高亮使用 TD brandColor 的 40% alpha，显式 selectionColor 仍优先；不改变祖先 SelectionArea 的选择注册及调用方菜单。
- TD 内部滚动视图使用私有滚动行为，不读取外部 MaterialScrollBehavior / ScrollbarTheme 的视觉或交互配置；取消主题选择的 glow/stretch，桌面原生滚动条由 TD 明确配置。已有公开 physics 等参数继续生效。隔离不传播给自定义内容内部的滚动视图。
- Collapse 明确前置内容居中；Slider 固定当前布局版本及 overlay 半径，不以零 padding 改变现有布局；Button 明确最大尺寸/对齐/动画；加载圆环明确约束和 padding；内部表面关闭 elevation overlay。
- 亮暗模式、平台、语言、方向、系统缩放和无障碍环境继续响应。禁止外部主题控制业务状态，不禁用内部原生能力。
- 实例状态属性仅覆盖非空值，回退到同状态 TD 默认值；显式透明、无边框及自定义图层保持原语义。

## Breaking 与迁移

此项为 breaking：外部 Material 视觉及行为主题不再是 TD 的隐式入口；使用已公开的 TD Theme、实例属性/style 定制。没有对应公开能力时暂不开放，不新增等价 Material 配置 API。调用方内容主题及必要原生能力保留。

## 当前验收

本轮基线为 2747c1e92。先逐项验证外部配置无效、TD 显式配置有效、自定义内容主题恢复和实际交互，再执行完整双版本功能、analyze、覆盖率及 Linux Golden 比较。仅更新已确认的有意像素差异，随后无更新参数复跑。此前实施保持本地；最终 review 通过后按用户授权提交、推送并更新 PR。历史验收不代替最终源码结果。

## 渐变按钮尺寸与描边

- 所有 size / variant 的普通与渐变按钮使用相同的内容 padding 与尺寸约束；边框不额外参与布局，只在前景绘制一次。
- 默认字号下 large / medium / small / extraSmall 高度为 48 / 40 / 32 / 28dp；outline / ghost 不得因描边产生额外的宽高。
- 显式 padding、minimumSize / fixedSize / maximumSize、状态边框与形状、点击区尺寸、RTL 以及自定义内容主题和位置保持原语义。
- 不将尺寸 Token 改为硬高度；字体缩放和大尺寸内容可像普通按钮一样撑大 minimumSize 按钮。
- 本项修正恢复已定义的尺寸契约，不新增或删除公开 API。原 PR 的 Material 主题迁移 breaking 说明保留；这一尺寸缺陷修复的用户更新日志为：fix(button): 修复渐变描边按钮尺寸与普通按钮不一致。不改自动生成的 CHANGELOG。

## Swiper 控制按钮定制收敛

契约与breaking迁移见 [swiper-control-style.md](./swiper-control-style.md)。删除controlIconSize，尺寸统一为controlStyle.iconSize；按状态非空合并，visualDensity禁止，自定义图层保留调用方主题。

### Message / Picker 审查缺口修复

- Message 跑马灯测量与绘制使用同一份最终 TD 文本配置，并保留系统文字缩放、方向与 locale；显式 TD 字体/字距不能造成单次滚动结束后文字残留。
- Picker 内置滚轮保持 TD 物理、禁用与输入策略；滚轮 viewport 以下恢复调用方 ScrollConfiguration，自定义 itemBuilder 内容遵守调用方滚动物理。不得通过恢复 Material 字体继承解决问题。
