---
title: Input 输入框
description: 用于在预设的一组选项中执行单项选择，并呈现选择结果。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_input_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_input_page.dart)

### 1 组件类型

基础输入框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeBasic(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: 'Label Text',
          controller: controller[0],
          backgroundColor: Colors.white,
          hintText: 'Please enter text',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[0].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeRequire(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          required: true,
          controller: controller[1],
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[1].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeOptional(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          controller: controller[2],
          backgroundColor: Colors.white,
          hintText: '请输入文字(选填)',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[2].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypePureInput(BuildContext context) {
    return Column(
      children: [
        TDInput(
          controller: controller[3],
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[3].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeAdditionalDesc(BuildContext context) {
    return TDInput(
      type: TDInputType.normal,
      leftLabel: '标签文字',
      controller: controller[4],
      hintText: '请输入文字',
      additionInfo: '辅助说明',
      backgroundColor: Colors.white,
      onChanged: (text) {
        setState(() {});
      },
      onClearTap: () {
        controller[4].clear();
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

带字数限制输入框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeTextLimit(BuildContext context) {
    return Column(
      children: [
        TDInput(
          type: TDInputType.normal,
          leftLabel: '标签文字',
          controller: controller[5],
          hintText: '请输入文字',
          maxLength: 10,
          additionInfo: '最大输入10个字符',
          backgroundColor: Colors.white,
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[5].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeTextLimitChinese2(BuildContext context) {
    return TDInput(
      type: TDInputType.normal,
      leftLabel: '标签文字',
      controller: controller[6],
      hintText: '请输入文字',
      inputFormatters: [Chinese2Formatter(10)],
      additionInfo: '最大输入10个字符，汉字算两个',
      backgroundColor: Colors.white,
      onChanged: (text) {
        setState(() {});
      },
      onClearTap: () {
        controller[6].clear();
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

带操作输入框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeWithHandleIconOne(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          controller: controller[7],
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          rightBtn: Icon(
            TDIcons.error_circle_filled,
            color: TDTheme.of(context).fontGyColor3,
          ),
          onBtnTap: () {
            TDToast.showText('点击右侧按钮', context: context);
          },
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[7].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeWithHandleIconTwo(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          controller: controller[8],
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          rightBtn: Container(
            alignment: Alignment.center,
            width: 73,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: TDTheme.of(context).brandNormalColor,
            ),
            child: const TDButton(
              text: '操作按钮',
              size: TDButtonSize.extraSmall,
              theme: TDButtonTheme.primary,
            ),
          ),
          onBtnTap: () {
            TDToast.showText('点击操作按钮', context: context);
          },
          needClear: false,
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeWithHandleIconThree(BuildContext context) {
    return TDInput(
      leftLabel: '标签文字',
      controller: controller[9],
      backgroundColor: Colors.white,
      hintText: '请输入文字',
      rightBtn: Icon(
        TDIcons.user_avatar,
        color: TDTheme.of(context).fontGyColor3,
      ),
      onBtnTap: () {
        TDToast.showText('点击操作按钮', context: context);
      },
      onChanged: (text) {
        setState(() {});
      },
      onClearTap: () {
        controller[9].clear();
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

带图标输入框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeWithLeftIconLeftLabel(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftIcon: const Icon(TDIcons.app),
          leftLabel: '标签文字',
          controller: controller[10],
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[10].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeWithLeftIcon(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftIcon: const Icon(TDIcons.app),
          controller: controller[11],
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[11].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  

特定类型输入框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _specialTypePassword(BuildContext context) {
    return Column(
      children: [
        TDInput(
          type: TDInputType.normal,
          controller: controller[12],
          obscureText: !browseOn,
          leftLabel: '输入密码',
          hintText: '请输入密码',
          backgroundColor: Colors.white,
          rightBtn: browseOn
              ? Icon(
                  TDIcons.browse,
                  color: TDTheme.of(context).fontGyColor3,
                )
              : Icon(
                  TDIcons.browse_off,
                  color: TDTheme.of(context).fontGyColor3,
                ),
          onBtnTap: () {
            setState(() {
              browseOn = !browseOn;
            });
          },
          needClear: false,
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _specialTypeVerifyCode(BuildContext context) {
    return Column(
      children: [
        TDInput(
          type: TDInputType.normal,
          size: TDInputSize.small,
          controller: controller[13],
          leftLabel: '验证码',
          hintText: '输入验证码',
          backgroundColor: Colors.white,
          rightBtn: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 0.5,
                height: 24,
                color: TDTheme.of(context).grayColor3,
              ),
              const SizedBox(
                width: 16,
              ),
              Image.network(
                'https://img2018.cnblogs.com/blog/736399/202001/736399-20200108170302307-1377487770.jpg',
                width: 72,
                height: 36,
              )
            ],
          ),
          needClear: false,
          onBtnTap: () {
            TDToast.showText('点击更换验证码', context: context);
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _specialTypePhoneNumber(BuildContext context) {
    return Column(
      children: [
        TDInput(
          type: TDInputType.normal,
          controller: controller[14],
          leftLabel: '手机号',
          hintText: '输入手机号',
          backgroundColor: Colors.white,
          rightBtn: SizedBox(
            width: 98,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 0.5,
                    height: 24,
                    color: TDTheme.of(context).grayColor3,
                  ),
                ),
                _countdownTime > 0
                    ? TDText(
                        '${countDownText}(${_countdownTime}秒)',
                        textColor: TDTheme.of(context).fontGyColor4,
                      )
                    : TDText(confirmText, textColor: TDTheme.of(context).brandNormalColor),
              ],
            ),
          ),
          needClear: false,
          onBtnTap: () {
            if (_countdownTime == 0) {
              TDToast.showText('点击了发送验证码', context: context);
              setState(() {
                _countdownTime = 60;
              });
              startCountdownTimer();
            }
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _specialTypePrice(BuildContext context) {
    return Column(
      children: [
        TDInput(
          type: TDInputType.special,
          controller: controller[15],
          leftLabel: '价格',
          hintText: '0.00',
          backgroundColor: Colors.white,
          textAlign: TextAlign.end,
          rightWidget: TDText('元', textColor: TDTheme.of(context).fontGyColor1),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _specialTypeNumber(BuildContext context) {
    return TDInput(
      type: TDInputType.special,
      controller: controller[16],
      leftLabel: '数量',
      hintText: '填写个数',
      backgroundColor: Colors.white,
      textAlign: TextAlign.end,
      rightWidget: TDText('个', textColor: TDTheme.of(context).fontGyColor1),
    );
  }</pre>

</td-code-block>
                                  


      
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">暂无演示代码</pre>

</td-code-block>
                
### 1 组件状态

输入框状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _inputStatusAdditionInfo(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          controller: controller[17],
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          additionInfo: '错误提示说明',
          additionInfoColor: TDTheme.of(context).errorColor6,
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[17].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _inputStatusReadOnly(BuildContext context) {
    return TDInput(
      leftLabel: '标签文字',
      readOnly: true,
      // 不可编辑文字 则不必带入controller
      backgroundColor: Colors.white,
      hintText: '不可编辑文字',
    );
  }</pre>

</td-code-block>
                                  

信息超长状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _inputStatusLongLabel(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftInfoWidth: 80,
          spacer: TDInputSpacer(iconLabelSpace: 4),
          leftLabel: '标签超长时最多十个字',
          controller: controller[18],
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[18].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _inputStatusLongInput(BuildContext context) {
    return TDInput(
      type: TDInputType.normal,
      leftLabel: '标签文字',
      controller: controller[19],
      backgroundColor: Colors.white,
      hintText: '输入文字超长不超过两行输入文字超长不超过两行',
      hintTextStyle: TextStyle(
        color: TDTheme.of(context).fontGyColor1,
      ),
      maxLines: 2,
    );
  }</pre>

</td-code-block>
                                  
### 1 组件样式

内容位置
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _contentLeft(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '左对齐',
          controller: controller[23],
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[23].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _contentCenter(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '居中',
          controller: controller[24],
          backgroundColor: Colors.white,
          contentAlignment: TextAlign.center,
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[24].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  


            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _contentRight(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '右对齐',
          controller: controller[25],
          backgroundColor: Colors.white,
          contentAlignment: TextAlign.end,
          hintText: '请输入文字',
          onChanged: (text) {
            setState(() {});
          },
          onClearTap: () {
            controller[25].clear();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }</pre>

</td-code-block>
                                  

竖排样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _verticalStyle(BuildContext context) {
    return TDInput(
      spacer: TDInputSpacer(iconLabelSpace: 0),
      type: TDInputType.twoLine,
      leftLabel: '标签文字',
      controller: controller[20],
      hintText: '请输入文字',
      backgroundColor: Colors.white,
      rightBtn: Icon(
        TDIcons.error_circle_filled,
        color: TDTheme.of(context).fontGyColor3,
      ),
      onBtnTap: () {
        TDToast.showText('点击右侧按钮', context: context);
      },
      onChanged: (text) {
        setState(() {});
      },
      onClearTap: () {
        controller[20].clear();
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

非通栏样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _cardStyle(BuildContext context) {
    return TDInput(
      type: TDInputType.cardStyle,
      width: MediaQuery.of(context).size.width - 32,
      leftLabel: '标签文字',
      controller: controller[21],
      hintText: '请输入文字',
      backgroundColor: Colors.white,
      onChanged: (text) {
        setState(() {});
      },
      onClearTap: () {
        controller[21].clear();
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  

标签外置样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _labelOutStyle(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: TDInput(
        type: TDInputType.cardStyle,
        cardStyle: TDCardStyle.topText,
        width: MediaQuery.of(context).size.width - 32,
        cardStyleTopText: '标签文字',
        controller: controller[22],
        hintText: '请输入文字',
        rightBtn: Icon(
          TDIcons.error_circle_filled,
          color: TDTheme.of(context).fontGyColor3,
        ),
        onBtnTap: () {
          TDToast.showText('点击右侧按钮', context: context);
        },
        onChanged: (text) {
          setState(() {});
        },
        onClearTap: () {
          controller[22].clear();
          setState(() {});
        },
      ),
    );
  }</pre>

</td-code-block>
                                  

自定义样式输入框
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _customStyle(BuildContext context) {
    return TDInput(
      leftLabel: '标签文字',
      controller: controller[26],
      backgroundColor: TDTheme.of(context).grayColor12,
      leftLabelStyle: TextStyle(color: TDTheme.of(context).fontWhColor1),
      textStyle: TextStyle(color: TDTheme.of(context).fontWhColor1),
      hintText: '请输入文字',
      hintTextStyle: TextStyle(color: TDTheme.of(context).fontWhColor3),
      onChanged: (text) {
        setState(() {});
      },
      clearBtnColor: TDTheme.of(context).fontWhColor3,
      onClearTap: () {
        controller[26].clear();
        setState(() {});
      },
    );
  }</pre>

</td-code-block>
                                  


## API
### TDInput
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| width | double? | - | 输入框宽度(TDCardStyle时必须设置该参数) |
| textStyle | TextStyle? | - | 文本颜色 |
| backgroundColor | Color? | - | 输入框背景色 |
| decoration | Decoration? | - | 输入框样式 |
| leftIcon | Widget? | - | 带图标的输入框 |
| leftLabel | String? | - | 输入框左侧文案 |
| leftLabelStyle | TextStyle? | - | 左侧标签样式 设置该值是若出现像素溢出，请设置letterSpacing: 0 |
| leftLabelSpace | double? | - | 输入框左侧文案间距 |
| required | bool? | - | 是否必填标志（红色*） |
| readOnly | bool | false | 是否只读 |
| autofocus | bool | false | 是否自动获取焦点 |
| obscureText | bool | false | 是否隐藏输入的文字，一般用在密码输入框中 |
| onEditingComplete | VoidCallback? | - | 点击键盘完成按钮时触发的回调 |
| onSubmitted | ValueChanged<String>? | - | 点击键盘完成按钮时触发的回调, 参数值为输入的内容 |
| hintText | String? | - | 提示文案 |
| inputType | TextInputType? | - | 键盘类型，数字、字母 |
| onChanged | ValueChanged<String>? | - | 输入文本变化时回调 |
| inputFormatters | List<TextInputFormatter>? | - | 显示输入内容，如限制长度(LengthLimitingTextInputFormatter(6)) |
| inputDecoration | InputDecoration? | - | 自定义输入框样式，默认圆角 |
| maxLines | int | 1 | 最大输入行数 |
| focusNode | FocusNode? | - | 获取或者取消焦点使用 |
| controller | TextEditingController? | - | controller 用户获取或者赋值输入内容 |
| cursorColor | Color? | - | 游标颜色 |
| rightBtn | Widget? | - | 右侧按钮 |
| hintTextStyle | TextStyle? | - | 提示文本颜色，默认为文本颜色 |
| onBtnTap | GestureTapCallback? | - | 右侧按钮点击 |
| labelWidget | Widget? | - | leftLabel右侧组件，支持自定义 |
| leftInfoWidth | double? | - | 输入框左侧的宽度（输入框有16dp的左侧padding，因而左侧部分不用考虑这16dp） |
| leftContentSpace | double? | - | 输入框内容左侧间距 |
| textInputBackgroundColor | Color? | - | 文本框背景色 |
| contentPadding | EdgeInsetsGeometry? | - | textInput内边距 |
| type | TDInputType | TDInputType.normal | 输入框类型 |
| size | TDInputSize | TDInputSize.large | 输入框规格 |
| maxLength | int? | 500 | 最大字数限制 |
| additionInfo | String? | '' | 错误提示信息 |
| additionInfoColor | Color? | - | 错误提示颜色 |
| textAlign | TextAlign? | - | 文字对齐方向 |
| clearIconSize | double? | - | 清除按钮图标大小 |
| onClearTap | GestureTapCallback? | - | 右侧删除点击 |
| needClear | bool | true | 是否需要右侧按钮变为删除 |
| clearBtnColor | Color? | - | 右侧删除按钮颜色 |
| contentAlignment | TextAlign | TextAlign.start | 内容对齐方向 |
| rightWidget | Widget? | - | 右侧自定义组件 特殊类型时生效 |
| showBottomDivider | bool | true | 是否展示底部分割线 |
| cardStyle | TDCardStyle? | - | 卡片默认样式 |
| cardStyleTopText | String? | - | 卡片模式上方文字 |
| inputAction | TextInputAction? | - | 键盘动作类型 |
| spacer | TDInputSpacer | - | 组件各模块间间距 |
| cardStyleBottomText | String? | - | 卡片模式下方文字 |
| onTapOutside | TapRegionCallback? | - | 点击输入框外部区域回调 |


  