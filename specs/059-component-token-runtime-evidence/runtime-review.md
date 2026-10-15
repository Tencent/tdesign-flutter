# 677项组件消费队列：当前阶段记录

这是阶段验收，不是正式1.0发布批准。原始静态盘点保留为基线，当前进展以本记录及runtime-review.json为准。

| 状态 | 项数 |
|---|---:|
| 待补运行证据 | 524 |
| 默认运行已验证，视觉待验收 | 116 |
| 运行差异待处理 | 31 |
| 平台几何待裁定 | 1 |
| 冻结源码未找到消费者 | 5 |

两套SDK各46项新增检查，逐SDK采集1008条观察，涉及150个变量名（含1项既有已审变量）；两套观察逐条相同。46项是各439项完整相关功能回归的子集，不重复相加。

## 证据解释

- 默认运行已验证只关闭该层证据；不表示每个公开覆盖路径、所有状态、设计像素或真机已通过。
- enforce=false是差异诊断，不是通过断言；这些观察进入差异队列，不冒充绿色对齐用例。既有及新增已确认契约的assert仍由普通测试执行。
- 31项是变量级差异，可能共用根因，不等于31个独立缺陷。固定规格、语义Token别名与设计例外需要契约裁定。
- 已批准的grayColor3/radiusCircle等全局差异沿用Spec047，主色填充按钮深色禁用文字沿用Spec048；不反向覆盖已批准决策。
- 5项只关闭冻结版本的消费者查找，不删除公开CSS变量，也不推定未来版本无消费者。
- 未验证或发现差异的条目没有修改finalPaintVerified。当前未改生产行为、CI、测试清单、版本号或Golden。

## 实测差异

| 变量 | 代表场景 | 实际值 | 比较目标 |
|---|---|---|---|
| avatarBorderColor | dark/custom=false/large | #ff242424 | #ffffffff |
| avatarIconSmallFontSize | dark/custom=true/small | 20 | 31 |
| avatarTextLargeFontSize | dark/custom=true/large | 20 | 31 |
| avatarTextMediumFontSize | dark/custom=true/medium | 16 | 21 |
| avatarTextSmallFontSize | dark/custom=true/small | 14 | 18 |
| buttonDangerDisabledBg | dark/custom=true/fill/danger/disabled | #ff291838 | #ff2a1b3f |
| buttonDangerDisabledColor | dark/custom=false/fill/danger/disabled | #38ffffff | #e6ffffff |
| buttonDangerOutlineDisabledColor | dark/custom=true/outline/danger/disabled | #ff291838 | #ff2a1b3f |
| buttonDangerTextDisabledColor | dark/custom=false/text/danger/disabled | #38ffffff | #e6ffffff |
| buttonDefaultActiveBgColor | dark/custom=false/fill/defaultTheme/pressed | #ff383838 | #ff4b4b4b |
| buttonGhostBorderColor | dark/custom=true/ghost/defaultTheme/idle | #ff37429a | #ff363f93 |
| buttonGhostColor | dark/custom=true/ghost/defaultTheme/idle | #ff37429a | #ff363f93 |
| buttonGhostDangerHoverColor | dark/custom=false/ghost/danger/pressed | #ffc64751 | #ffa03f46 |
| buttonGhostHoverColor | dark/custom=false/ghost/defaultTheme/pressed | #e6ffffff | #8cffffff |
| buttonGhostPrimaryHoverColor | dark/custom=false/ghost/primary/pressed | #ff4582e6 | #ff699ef5 |
| buttonLightActiveBgColor | dark/custom=false/fill/light/pressed | #ff1b2f51 | #ff173463 |
| emptyActionMarginTop | dark/custom=true/image=false | 32 | 37 |
| emptyDescriptionMarginTop | dark/custom=false/image=false | 22 | 16 |
| inputBorderColor | dark/custom=false/enabled=true | #ff5e5e5e | #ff383838 |
| inputVerticalPadding | dark/custom=true/enabled=true | 16 | 19 |
| switchDotLargeSize | dark/large/value=false/icon | 25.14285714 | 26 |
| switchDotPlainLargeSize | dark/large/value=false/filled | 18.28571429 | 22 |
| switchDotPlainSize | dark/medium/value=false/filled | 16 | 18 |
| switchDotPlainSmallSize | dark/small/value=false/filled | 13.71428571 | 14 |
| switchDotSmallSize | dark/small/value=false/icon | 18.85714286 | 18 |
| switchIconLargeSize | dark/large/value=false/icon | 18.28571429 | 24 |
| switchIconSize | dark/medium/value=false/icon | 16 | 20 |
| switchIconSmallSize | dark/small/value=false/icon | 13.71428571 | 16 |
| switchLabelColor | dark/custom=false/TSwitchVariant.icon/value=false | #38ffffff | #ff383838 |
| switchLargeWidth | dark/large/value=false/filled | 51.42857143 | 52 |
| switchSmallWidth | dark/small/value=false/filled | 38.57142857 | 39 |

完整浅/暗、正常/按压/禁用、默认/自定义观察见[runtime-observations.json](runtime-observations.json)，目标源码、现有测试候选和每项缺口见[runtime-review.json](runtime-review.json)。

## 逐组件分布

| 组件 | 默认运行已验证 | 差异待处理 | 平台几何 | 无消费者 | 待补运行 |
|---|---:|---:|---:|---:|---:|
| action-sheet | 0 | 0 | 0 | 0 | 11 |
| avatar | 12 | 5 | 0 | 0 | 1 |
| avatar-group | 0 | 0 | 0 | 0 | 5 |
| back-top | 0 | 0 | 0 | 0 | 6 |
| badge | 0 | 0 | 0 | 0 | 14 |
| button | 54 | 11 | 1 | 1 | 19 |
| calendar | 0 | 0 | 0 | 0 | 13 |
| cascader | 0 | 0 | 0 | 0 | 19 |
| cell | 0 | 0 | 0 | 0 | 23 |
| cell-group | 0 | 0 | 0 | 0 | 6 |
| checkbox | 0 | 0 | 0 | 0 | 17 |
| collapse-panel | 0 | 0 | 0 | 0 | 13 |
| date-time-picker | 0 | 0 | 0 | 0 | 1 |
| dialog | 0 | 0 | 0 | 0 | 8 |
| divider | 0 | 0 | 0 | 0 | 8 |
| drawer | 0 | 0 | 0 | 0 | 11 |
| dropdown-menu | 0 | 0 | 0 | 0 | 8 |
| empty | 3 | 2 | 0 | 0 | 0 |
| footer | 0 | 0 | 0 | 0 | 12 |
| form-item | 0 | 0 | 0 | 0 | 5 |
| image | 0 | 0 | 0 | 0 | 4 |
| image-viewer | 0 | 0 | 0 | 0 | 8 |
| indexes | 0 | 0 | 0 | 0 | 11 |
| indexes-anchor | 0 | 0 | 0 | 0 | 9 |
| input | 7 | 2 | 0 | 3 | 12 |
| link | 15 | 0 | 0 | 0 | 0 |
| loading | 0 | 0 | 0 | 0 | 5 |
| message-item | 0 | 0 | 0 | 0 | 9 |
| navbar | 0 | 0 | 0 | 0 | 13 |
| notice-bar | 0 | 0 | 0 | 0 | 11 |
| paragraph | 0 | 0 | 0 | 0 | 1 |
| picker | 0 | 0 | 0 | 0 | 11 |
| picker-item | 0 | 0 | 0 | 0 | 3 |
| popover | 0 | 0 | 0 | 0 | 13 |
| popup | 0 | 0 | 0 | 0 | 5 |
| progress | 8 | 0 | 0 | 1 | 0 |
| radio | 0 | 0 | 0 | 0 | 17 |
| rate | 0 | 0 | 0 | 0 | 7 |
| result | 0 | 0 | 0 | 0 | 10 |
| search | 0 | 0 | 0 | 0 | 15 |
| side-bar | 0 | 0 | 0 | 0 | 3 |
| side-bar-item | 0 | 0 | 0 | 0 | 7 |
| skeleton | 0 | 0 | 0 | 0 | 10 |
| slider | 0 | 0 | 0 | 0 | 16 |
| step-item | 0 | 0 | 0 | 0 | 26 |
| stepper | 0 | 0 | 0 | 0 | 3 |
| swiper | 0 | 0 | 0 | 0 | 2 |
| swiper-nav | 0 | 0 | 0 | 0 | 11 |
| switch | 17 | 11 | 0 | 0 | 3 |
| tab-bar | 0 | 0 | 0 | 0 | 3 |
| tab-bar-item | 0 | 0 | 0 | 0 | 7 |
| table | 0 | 0 | 0 | 0 | 10 |
| tabs | 0 | 0 | 0 | 0 | 15 |
| tag | 0 | 0 | 0 | 0 | 12 |
| textarea | 0 | 0 | 0 | 0 | 9 |
| toast | 0 | 0 | 0 | 0 | 6 |
| tree-select | 0 | 0 | 0 | 0 | 8 |
| upload | 0 | 0 | 0 | 0 | 9 |

## 本批默认运行通过清单

| 变量 | 测试入口 | 观察数/SDK |
|---|---|---:|
| avatarBgColor | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 12 |
| avatarBorderWidthLarge | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 8 |
| avatarBorderWidthMedium | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 8 |
| avatarBorderWidthSmall | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 8 |
| avatarCircleBorderRadius | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 12 |
| avatarContentColor | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 12 |
| avatarIconLargeFontSize | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 4 |
| avatarIconMediumFontSize | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 4 |
| avatarLargeWidth | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 4 |
| avatarMediumWidth | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 4 |
| avatarRoundBorderRadius | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 12 |
| avatarSmallWidth | [测试函数](../../tdesign-component/test/components/avatar/t_avatar_test.dart#L909) | 4 |
| buttonBorderRadius | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 16 |
| buttonDangerActiveBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDangerBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDangerColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonDangerOutlineActiveBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDangerOutlineActiveBorderColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDangerOutlineBorderColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDangerOutlineColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonDangerTextActiveBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDangerTextColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonDefaultBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDefaultColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonDefaultDisabledBg | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDefaultDisabledColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDefaultOutlineActiveBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDefaultOutlineActiveBorderColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDefaultOutlineBorderColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonDefaultOutlineColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonDefaultOutlineDisabledColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonDefaultTextActiveBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonExtraSmallFont | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonGhostDangerBorderColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonGhostDangerColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonGhostDisabledColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 12 |
| buttonGhostPrimaryBorderColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonGhostPrimaryColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonLargeFont | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonLightBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonLightColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonLightDisabledBg | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonLightDisabledColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonLightOutlineActiveBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonLightOutlineActiveBorderColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonLightOutlineBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonLightOutlineBorderColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonLightOutlineColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonLightOutlineDisabledColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonLightTextActiveBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonLightTextColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonMediumFont | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonPrimaryActiveBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonPrimaryBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonPrimaryColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonPrimaryDisabledBg | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonPrimaryDisabledColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonPrimaryOutlineActiveBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonPrimaryOutlineActiveBorderColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonPrimaryOutlineBorderColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonPrimaryOutlineColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonPrimaryOutlineDisabledColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonPrimaryTextActiveBgColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonPrimaryTextColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 8 |
| buttonPrimaryTextDisabledColor | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| buttonSmallFont | [测试函数](../../tdesign-component/test/components/button/t_button_test.dart#L3059) | 4 |
| emptyDescriptionColor | [测试函数](../../tdesign-component/test/components/empty/t_empty_test.dart#L107) | 8 |
| emptyDescriptionFont | [测试函数](../../tdesign-component/test/components/empty/t_empty_test.dart#L107) | 8 |
| emptyIconColor | [测试函数](../../tdesign-component/test/components/empty/t_empty_test.dart#L107) | 4 |
| inputBgColor | [测试函数](../../tdesign-component/test/components/input/t_input_test.dart#L1019) | 4 |
| inputDefaultTextColor | [测试函数](../../tdesign-component/test/components/input/t_input_test.dart#L1019) | 4 |
| inputDisabledTextColor | [测试函数](../../tdesign-component/test/components/input/t_input_test.dart#L1019) | 8 |
| inputPlaceholderTextColor | [测试函数](../../tdesign-component/test/components/input/t_input_test.dart#L1019) | 4 |
| inputPlaceholderTextFont | [测试函数](../../tdesign-component/test/components/input/t_input_test.dart#L1019) | 4 |
| inputPrefixIconColor | [测试函数](../../tdesign-component/test/components/input/t_input_test.dart#L1019) | 4 |
| inputSuffixIconColor | [测试函数](../../tdesign-component/test/components/input/t_input_test.dart#L1019) | 4 |
| linkDangerActiveColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkDangerColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkDangerDisabledColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkDefaultActiveColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkDefaultColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkDefaultDisabledColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkPrimaryActiveColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkPrimaryColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkPrimaryDisabledColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkSuccessActiveColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkSuccessColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkSuccessDisabledColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkWarningActiveColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkWarningColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| linkWarningDisabledColor | [测试函数](../../tdesign-component/test/components/link/t_link_test.dart#L258) | 8 |
| progressCircleInnerBgColor | [测试函数](../../tdesign-component/test/components/progress/t_progress_test.dart#L1193) | 4 |
| progressCircleLabelFont | [测试函数](../../tdesign-component/test/components/progress/t_progress_test.dart#L1193) | 4 |
| progressCircleWidth | [测试函数](../../tdesign-component/test/components/progress/t_progress_test.dart#L1193) | 4 |
| progressInnerBgColor | [测试函数](../../tdesign-component/test/components/progress/t_progress_test.dart#L1193) | 12 |
| progressLineStrokeWidth | [测试函数](../../tdesign-component/test/components/progress/t_progress_test.dart#L1193) | 4 |
| progressStrokeCircleWidth | [测试函数](../../tdesign-component/test/components/progress/t_progress_test.dart#L1193) | 4 |
| progressStrokePlumpWidth | [测试函数](../../tdesign-component/test/components/progress/t_progress_test.dart#L1193) | 4 |
| progressTrackBgColor | [测试函数](../../tdesign-component/test/components/progress/t_progress_test.dart#L1193) | 12 |
| switchCheckedColor | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 8 |
| switchCheckedDisabledColor | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 8 |
| switchDotDisabledColor | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 8 |
| switchDotSize | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 10 |
| switchHeight | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 12 |
| switchLabelCheckedColor | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 8 |
| switchLabelFontSize | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 4 |
| switchLabelLargeFontSize | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 4 |
| switchLabelSmallFontSize | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 4 |
| switchLargeHeight | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 12 |
| switchLargeRadius | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 12 |
| switchLoadingColor | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 4 |
| switchRadius | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 12 |
| switchSmallHeight | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 12 |
| switchSmallRadius | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 12 |
| switchUncheckedDisabledColor | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 8 |
| switchWidth | [测试函数](../../tdesign-component/test/components/switch/t_switch_test.dart#L665) | 12 |

## 冻结源码无消费者

- buttonIconSpacer：声明存在，但本次冻结源码的编译CSS和其他源文件均未找到消费；保留声明，后续源版本变化重审。
- inputErrorTextColor：声明存在，但本次冻结源码的编译CSS和其他源文件均未找到消费；保留声明，后续源版本变化重审。
- inputSuccessTextColor：声明存在，但本次冻结源码的编译CSS和其他源文件均未找到消费；保留声明，后续源版本变化重审。
- inputWarningTextColor：声明存在，但本次冻结源码的编译CSS和其他源文件均未找到消费；保留声明，后续源版本变化重审。
- progressCircleIconSize：声明存在，但本次冻结源码的编译CSS和其他源文件均未找到消费；保留声明，后续源版本变化重审。
