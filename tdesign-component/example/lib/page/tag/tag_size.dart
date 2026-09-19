part of 'tag_page.dart';

extension _TagSizeModule on _TTagPageState {
  ExampleModule get _tagSizeModule => ExampleModule(
    title: '组件尺寸',
    children: [
      ExampleItem(
        ignoreCode: true,
        builder: (context) {
          return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 16),
            child: Wrap(
              spacing: 8,
              direction: Axis.vertical,
              children: [CodeWrapper(builder: _buildAllSizeTags)],
            ),
          );
        },
      ),
    ],
  );
}
