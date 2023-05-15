import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDInputViewPage extends StatefulWidget {
  const TDInputViewPage({Key? key}) : super(key: key);

  @override
  _TDInputViewPageState createState() => _TDInputViewPageState();
}

class _TDInputViewPageState extends State<TDInputViewPage> {
  String inputText = '请输入...';
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        backgroundColor: const Color(0xFFF0F2F5),
        title: tdTitle(),
        desc: '用于在预设的一组选项中执行单项选择，并呈现选择结果。',
        exampleCodeGroup: 'input',
        children: [
          ExampleModule(
            title: '组件类型',
            children: [
              ExampleItem(desc: '基础文本框', builder: _basicTypeBasic),
              ExampleItem(builder: _basicTypeRequire),
              ExampleItem(builder: _basicTypeOptional),
              ExampleItem(builder: _basicTypePureInput),
              ExampleItem(builder: _basicTypeAdditionalDesc),
              ExampleItem(desc: '带操作输入框', builder: _basicTypeWithHandleIconOne),
              ExampleItem(builder: _basicTypeWithHandleIconTwo),
              ExampleItem(builder: _basicTypeWithHandleIconThree),
              ExampleItem(
                  desc: '带图标输入框', builder: _basicTypeWithLeftIconLeftLabel),
              ExampleItem(builder: _basicTypeWithLeftIcon),
              ExampleItem(desc: '特定类型输入框', builder: _specialTypePassword),
              ExampleItem(builder: _specialTypeVerifyCode),
              ExampleItem(builder: _specialTypePhoneNumber),
              ExampleItem(builder: _specialTypePrice),
              ExampleItem(builder: _specialTypeNumber),
            ],
          ),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '输入框状态', builder: _inputStatusAdditionInfo),
            ExampleItem(builder: _inputStatusReadOnly),
            ExampleItem(desc: '信息超长状态', builder: _inputStatusLongLabel),
            ExampleItem(builder: _inputStatusLongInput),
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(desc: '竖排样式', builder: _verticalStyle),
            ExampleItem(desc: '非通栏样式', builder: _cardStyle),
          ]),
          ExampleModule(title: '特殊样式', children: [
            ExampleItem(desc: '非通栏样式', builder: _labelOutStyle),
          ])
        ]);
  }

  @Demo(group: 'input')
  Widget _basicTypeBasic(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          controller: controller,
          backgroundColor: Colors.white,
          hintText: '请输入文字',
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeRequire(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          required: true,
          controller: controller,
          backgroundColor: Colors.white,
          hintText: '请输入文字',
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeOptional(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          controller: controller,
          backgroundColor: Colors.white,
          hintText: '请输入文字(选填)',
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypePureInput(BuildContext context) {
    return Column(
      children: [
        TDInput(
          controller: controller,
          backgroundColor: Colors.white,
          hintText: '请输入文字',
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeAdditionalDesc(BuildContext context) {
    return TDInput(
      type: TDInputType.normal,
      leftLabel: '标签文字',
      controller: controller,
      hintText: '请输入文字',
      addtionInfo: '辅助说明',
      backgroundColor: Colors.white,
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeWithHandleIconOne(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          controller: controller,
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          rightBtn: Icon(
            TDIcons.error_circle_filled,
            color: TDTheme.of(context).fontGyColor3,
          ),
          onBtnTap: () {
            TDToast.showText('点击右侧按钮', context: context);
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeWithHandleIconTwo(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          controller: controller,
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          rightBtn: Container(
            alignment: Alignment.center,
            width: 72,
            height: 28,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: TDTheme.of(context).brandNormalColor),
            child: TDText(
              '操作按钮',
              font: TDTheme.of(context).fontBodyMedium,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          onBtnTap: () {
            TDToast.showText('点击操作按钮', context: context);
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeWithHandleIconThree(BuildContext context) {
    return TDInput(
      leftLabel: '标签文字',
      controller: controller,
      backgroundColor: Colors.white,
      hintText: '请输入文字',
      rightBtn: const Icon(TDIcons.calendar),
      onBtnTap: () {
        TDToast.showText('点击操作按钮', context: context);
      },
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeWithLeftIconLeftLabel(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftIcon: const Icon(TDIcons.app),
          leftLabel: '标签文字',
          controller: controller,
          backgroundColor: Colors.white,
          hintText: '请输入文字',
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _basicTypeWithLeftIcon(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftIcon: const Icon(TDIcons.app),
          controller: controller,
          backgroundColor: Colors.white,
          hintText: '请输入文字',
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _specialTypePassword(BuildContext context) {
    return Column(
      children: [
        TDInput(
          type: TDInputType.normal,
          controller: controller,
          obscureText: true,
          leftLabel: '输入密码',
          hintText: '请输入密码',
          backgroundColor: Colors.white,
          rightBtn: Icon(
            TDIcons.close_circle_filled,
            color: TDTheme.of(context).fontGyColor3,
          ),
          onBtnTap: () {
            controller.clear();
          },
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  @Demo(group: 'input')
  Widget _specialTypeVerifyCode(BuildContext context) {
    return Column(
      children: [
        TDInput(
          type: TDInputType.normal,
          size: TDInputSize.small,
          controller: controller,
          leftLabel: '验证码',
          hintText: '输入验证码',
          backgroundColor: Colors.white,
          rightBtn: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 0.5,
                height: 36,
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
          onBtnTap: () {
            TDToast.showText('点击更换验证码', context: context);
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _specialTypePhoneNumber(BuildContext context) {
    return Column(
      children: [
        TDInput(
          type: TDInputType.normal,
          controller: controller,
          leftLabel: '手机号',
          hintText: '请输入手机号码',
          backgroundColor: Colors.white,
          rightBtn: Row(
            children: [
              Container(
                width: 0.5,
                height: 24,
                color: TDTheme.of(context).grayColor3,
              ),
              const SizedBox(
                width: 16,
              ),
              TDText('发送验证码', textColor: TDTheme.of(context).brandNormalColor),
            ],
          ),
          onBtnTap: () {
            TDToast.showText('点击了发送验证码', context: context);
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _specialTypePrice(BuildContext context) {
    return Column(
      children: [
        TDInput(
          type: TDInputType.special,
          controller: controller,
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
  }

  @Demo(group: 'input')
  Widget _specialTypeNumber(BuildContext context) {
    return TDInput(
      type: TDInputType.special,
      controller: controller,
      leftLabel: '数量',
      hintText: '输入数量',
      backgroundColor: Colors.white,
      textAlign: TextAlign.end,
      rightWidget: TDText('个', textColor: TDTheme.of(context).fontGyColor1),
    );
  }

  @Demo(group: 'input')
  Widget _inputStatusAdditionInfo(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签文字',
          controller: controller,
          backgroundColor: Colors.white,
          hintText: '请输入文字',
          addtionInfo: '辅助说明',
          addtionInfoColor: TDTheme.of(context).errorColor6,
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _inputStatusReadOnly(BuildContext context) {
    return TDInput(
      leftLabel: '标签文字',
      readOnly: true,
      // 不可编辑文字 则不必带入controller
      //controller: controller,
      backgroundColor: Colors.white,
      hintText: '不可编辑文字',
    );
  }

  @Demo(group: 'input')
  Widget _inputStatusLongLabel(BuildContext context) {
    return Column(
      children: [
        TDInput(
          leftLabel: '标签超长时最多十个字',
          controller: controller,
          backgroundColor: Colors.white,
          hintText: '请输入文字',
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  @Demo(group: 'input')
  Widget _inputStatusLongInput(BuildContext context) {
    return TDInput(
      type: TDInputType.normal,
      leftLabel: '标签文字',
      controller: controller,
      backgroundColor: Colors.white,
      hintText: '输入文字超长不超过两行输入文字超长不超过两行',
      hintTextStyle: TextStyle(
        color: TDTheme.of(context).fontGyColor1,
      ),
      maxLines: 2,
    );
  }

  @Demo(group: 'input')
  Widget _verticalStyle(BuildContext context) {
    return TDInput(
      type: TDInputType.twoLine,
      leftLabel: '标签文字',
      controller: controller,
      hintText: '请输入文字',
      backgroundColor: Colors.white,
      rightBtn: Icon(
        TDIcons.error_circle_filled,
        color: TDTheme.of(context).fontGyColor3,
      ),
      onBtnTap: () {
        TDToast.showText('点击右侧按钮', context: context);
      },
    );
  }

  @Demo(group: 'input')
  Widget _cardStyle(BuildContext context) {
    return TDInput(
      type: TDInputType.cardStyle,
      width: MediaQuery.of(context).size.width - 32,
      leftLabel: '标签文字',
      controller: controller,
      hintText: '请输入文字',
      backgroundColor: Colors.white,
    );
  }

  @Demo(group: 'input')
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
        controller: controller,
        hintText: '请输入文字',
        rightBtn: Icon(
          TDIcons.error_circle_filled,
          color: TDTheme.of(context).fontGyColor3,
        ),
        onBtnTap: () {
          TDToast.showText('点击右侧按钮', context: context);
        },
      ),
    );
  }
}
