part of 'tag_page.dart';

extension _TagTypeModule on _TTagPageState {
  ExampleModule get _tagTypeModule => ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(
        desc: '基础标签',
        ignoreCode: true,
        builder: (context) {
          return Row(
            children: [
              const SizedBox(width: 16),
              CodeWrapper(builder: _buildSimpleFillTag),
              const SizedBox(width: 16),
              CodeWrapper(builder: _buildSimpleOutlineTag),
            ],
          );
        },
      ),
      ExampleItem(
        desc: '圆弧标签',
        ignoreCode: true,
        builder: (context) {
          return Row(
            children: [
              const SizedBox(width: 16),
              CodeWrapper(builder: _buildCircleFillTag),
              const SizedBox(width: 16),
              CodeWrapper(builder: _buildCircleOutlineTag),
            ],
          );
        },
      ),
      ExampleItem(
        desc: 'Mark标签',
        ignoreCode: true,
        builder: (context) {
          return Row(
            children: [
              const SizedBox(width: 16),
              CodeWrapper(builder: _buildMarkFillTag),
              const SizedBox(width: 16),
              CodeWrapper(builder: _buildMarkOutlineTag),
            ],
          );
        },
      ),
      ExampleItem(
        desc: '带图标的标签',
        ignoreCode: true,
        builder: (context) {
          return Row(
            children: [
              const SizedBox(width: 16),
              CodeWrapper(builder: _buildIconFillTag),
              const SizedBox(width: 16),
              CodeWrapper(builder: _buildIconOutlineTag),
            ],
          );
        },
      ),
      ExampleItem(
        desc: '超长省略文本标签',
        ignoreCode: true,
        builder: (context) {
          return Row(
            children: [
              SizedBox(width: context.tTheme.spacer16),
              CodeWrapper(
                builder: _buildLongTextTag,
                methodName: '_buildLongTextTag',
              ),
            ],
          );
        },
      ),
      ExampleItem(
        desc: '可关闭的标签',
        ignoreCode: true,
        builder: (context) {
          return Row(
            children: [
              const SizedBox(width: 16),
              CodeWrapper(builder: _buildCloseFillTag),
              const SizedBox(width: 16),
              CodeWrapper(builder: _buildCloseOutlineTag),
            ],
          );
        },
      ),
    ],
  );
}
