part of 'steps_page.dart';

extension _StepsTypeModule on _TStepsPageState {
  ExampleModule get _stepsTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: 'Horizontal Default Steps 水平默认步骤条',
        padding: _stepsItemPadding,
        builder: _buildHorizontalDefault,
        methodName: '_buildHorizontalDefault',
      ),
      ExampleItem(
        desc: 'Horizontal Icon Steps 水平图标步骤条',
        padding: _stepsItemPadding,
        builder: _buildHorizontalIcon,
        methodName: '_buildHorizontalIcon',
      ),
      ExampleItem(
        desc: 'Horizontal Dot Steps 水平简略步骤条',
        padding: _stepsItemPadding,
        builder: _buildHorizontalDot,
        methodName: '_buildHorizontalDot',
      ),
      ExampleItem(
        desc: 'Vertical Default Steps 垂直默认步骤条',
        padding: _stepsItemPadding,
        builder: _buildVerticalDefault,
        methodName: '_buildVerticalDefault',
      ),
      ExampleItem(
        desc: 'Vertical Icon Steps 垂直图标步骤条',
        padding: _stepsItemPadding,
        builder: _buildVerticalIcon,
        methodName: '_buildVerticalIcon',
      ),
      ExampleItem(
        desc: 'Vertical Dot Steps 垂直简略步骤条',
        padding: _stepsItemPadding,
        builder: _buildVerticalDot,
        methodName: '_buildVerticalDot',
      ),
      ExampleItem(
        desc: 'Customize Steps Content 自定义步骤条内容',
        padding: _stepsItemPadding,
        builder: _buildCustomContent,
        methodName: '_buildCustomContent',
      ),
    ],
  );
}
