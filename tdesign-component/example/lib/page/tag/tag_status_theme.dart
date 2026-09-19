part of 'tag_page.dart';

extension _TagStatusThemeModule on _TTagPageState {
  ExampleModule get _tagStatusThemeModule => ExampleModule(
    title: '组件状态（主题）',
    children: [
      ExampleItem(
        desc: '填充型各主题',
        ignoreCode: true,
        builder: (context) {
          return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 16),
            child: Wrap(
              spacing: 8,
              direction: Axis.vertical,
              children: [
                CodeWrapper(builder: _buildDarkShowTags),
                CodeWrapper(builder: _buildLightShowTags),
              ],
            ),
          );
        },
      ),
      ExampleItem(
        desc: '描边型各主题',
        ignoreCode: true,
        builder: (context) {
          return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 16),
            child: Wrap(
              spacing: 8,
              direction: Axis.vertical,
              children: [
                CodeWrapper(builder: _buildOutlineShowTags),
                CodeWrapper(builder: _buildLightOutlineShowTags),
              ],
            ),
          );
        },
      ),
    ],
  );
}
