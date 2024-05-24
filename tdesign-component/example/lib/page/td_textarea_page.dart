import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDTextareaPage extends StatefulWidget {
  const TDTextareaPage({Key? key}) : super(key: key);

  @override
  _TDTextareaPageState createState() => _TDTextareaPageState();
}

class _TDTextareaPageState extends State<TDTextareaPage> {
  var controller = <TextEditingController>[];

  @override
  void initState() {
    for (var i = 0; i < 20; i++) {
      controller.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      backgroundColor: const Color(0xFFF0F2F5),
      title: tdTitle(),
      desc: '用于多行文本信息输入。',
      exampleCodeGroup: 'textarea',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础多文本输入框', builder: _basicType),
            ExampleItem(desc: '带标题多文本输入框', builder: _basicTypeByTitle),
            ExampleItem(desc: '自动增高多文本输入框', builder: _autoHeightType),
            ExampleItem(desc: '设置字符数限制', builder: _maxLengthType),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(desc: '禁用状态', builder: _disabledState),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '竖排样式', builder: _verticalStyle),
            ExampleItem(desc: '卡片样式', builder: _cardStyle),
          ],
        ),
        ExampleModule(
          title: '特殊样式',
          children: [
            ExampleItem(desc: '标签外置输入框', builder: _extensionStyle),
            ExampleItem(desc: '自定义标题', builder: _setLabel),
            ExampleItem(desc: '必填和辅助说明', builder: _setStatus),
          ],
        ),
      ],
      test: [
        ExampleItem(desc: '自定义宽度', center: false, builder: _setWidth),
        ExampleItem(desc: '小尺寸', builder: _smallSize),
      ],
    );
  }

  @Demo(group: 'textarea')
  Widget _basicType(BuildContext context) {
    return TDTextarea(
      controller: controller[0],
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _basicTypeByTitle(BuildContext context) {
    return TDTextarea(
      controller: controller[1],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _autoHeightType(BuildContext context) {
    return TDTextarea(
      controller: controller[2],
      hintText: '请输入文字',
      minLines: 1,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _maxLengthType(BuildContext context) {
    return TDTextarea(
      controller: controller[3],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _disabledState(BuildContext context) {
    return TDTextarea(
      controller: controller[4],
      label: '标签文字',
      hintText: '不可编辑文字',
      maxLines: 4,
      minLines: 4,
      readOnly: true,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _verticalStyle(BuildContext context) {
    return TDTextarea(
      controller: controller[5],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      layout: TDTextareaLayout.vertical,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _cardStyle(BuildContext context) {
    return TDTextarea(
      controller: controller[6],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TDTheme.of(context).radiusExtraLarge),
      ),
      margin: EdgeInsets.only(right: TDTheme.of(context).spacer16, left: TDTheme.of(context).spacer16),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _extensionStyle(BuildContext context) {
    return TDTextarea(
      controller: controller[7],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      layout: TDTextareaLayout.vertical,
      bordered: true,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _setWidth(BuildContext context) {
    return TDTextarea(
      controller: controller[8],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      width: 200,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _setLabel(BuildContext context) {
    return TDTextarea(
      controller: controller[9],
      label: '地址信息',
      // labelWidth: 100,
      labelIcon: Icon(
        TDIcons.location,
        size: 20,
        color: TDTheme.of(context).fontGyColor1,
      ),
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _setStatus(BuildContext context) {
    return TDTextarea(
      controller: controller[10],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      layout: TDTextareaLayout.vertical,
      required: true,
      additionInfo: '辅助说明',
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  @Demo(group: 'textarea')
  Widget _smallSize(BuildContext context) {
    return TDTextarea(
      controller: controller[11],
      label: '标签文字',
      hintText: '请输入文字',
      maxLines: 4,
      minLines: 4,
      maxLength: 500,
      indicator: true,
      layout: TDTextareaLayout.vertical,
      size: TDInputSize.small,
      onChanged: (value) {
        setState(() {});
      },
    );
  }
}
