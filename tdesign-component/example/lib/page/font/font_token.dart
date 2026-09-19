part of 'font_page.dart';

extension _FontTokenModule on TFontPage {
  ExampleModule get _fontTokenModule => ExampleModule(
    title: 'Token',
    children: [
      ExampleItem(
        ignoreCode: true,
        builder: (context) {
          var children = <Widget>[];
          context.tTheme.fontMap.forEach((key, value) {
            children.add(
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.tTheme.componentBorderColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: TText(
                  '@$key:${value.size.toInt()}px',
                  font: value,

                  /// link类型的示例添加下划线
                  style: TextStyle(
                    decoration: key.contains('Link')
                        ? TextDecoration.underline
                        : null,
                    decorationColor: context.tTheme.textColorPrimary,
                  ),
                ),
              ),
            );
          });
          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: children,
          );
        },
      ),
    ],
  );
}
