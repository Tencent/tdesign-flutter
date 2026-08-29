import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_checkbox_page.dart';

import 'demo_page_test_utils.dart';

void main() {
  registerDemoPageTests(
    const DemoPageTestSpec(
      name: 'checkbox',
      title: 'Checkbox 多选框',
      page: TCheckboxPage(),
      expectedTexts: [
        '用于预设的一组选项中执行多项选择，并呈现选择结果。',
        '01 组件类型',
        '纵向多选框',
        '横向多选框',
        '多选标题',
        '上限四字',
        '带全选多选框',
        '02 组件状态',
        '多选框状态',
        '选项禁用-已选',
        '选项禁用-默认',
        '03 组件样式',
        '勾选样式',
        '勾选显示位置',
        '非通栏多选样式',
        '04 组件规格',
        '多选框尺寸规格',
        '横向卡片多选框',
      ],
      componentType: TCheckbox,
      expectedComponentCount: 26,
    ),
  );
}
