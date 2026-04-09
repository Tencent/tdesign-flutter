import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TFabPage extends StatefulWidget {
  const TFabPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TFabPageState();
}

class _TFabPageState extends State<TFabPage> {
  bool showBorder = false;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(title: tdTitle(), exampleCodeGroup: 'fab', children: [
      ExampleModule(title: '组件类型', children: [
        ExampleItem(desc: 'Icon Fab 纯图标悬浮按钮', builder: _buildPureIconFab),
        ExampleItem(
            desc: 'Icon Fab with Text 图标加文字悬浮按钮', builder: _buildTextFab)
      ]),
      ExampleModule(title: '组件状态', children: [
        ExampleItem(desc: 'Fab Theme 悬浮按钮主题', builder: _buildThemeFab),
        ExampleItem(desc: 'Fab Shape 悬浮按钮形状', builder: _buildShapeFab),
        ExampleItem(desc: 'Fab Size 悬浮按钮尺寸', builder: _buildSizeFab)
      ])
    ]);
  }

  @Demo(group: 'fab')
  Widget _buildPureIconFab(BuildContext context) {
    return _buildRowDemo([
      const TFab(
        theme: TFabTheme.primary,
      )
    ]);
  }

  @Demo(group: 'fab')
  Widget _buildTextFab(BuildContext context) {
    return _buildRowDemo([
      const TFab(
        theme: TFabTheme.primary,
        text: 'Floating',
      )
    ]);
  }

  @Demo(group: 'fab')
  Widget _buildThemeFab(BuildContext context) {
    return _buildRowDemoWidthDescription([
      {
        'component': const TFab(
          theme: TFabTheme.primary,
        ),
        'desc': 'Primary'
      },
      {
        'component': const TFab(
          theme: TFabTheme.defaultTheme,
        ),
        'desc': 'Default'
      },
      {
        'component': const TFab(
          theme: TFabTheme.light,
        ),
        'desc': 'Light'
      },
      {
        'component': const TFab(
          theme: TFabTheme.danger,
        ),
        'desc': 'Danger'
      },
    ]);
  }

  @Demo(group: 'fab')
  Widget _buildShapeFab(BuildContext context) {
    return _buildRowDemoWidthDescription([
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          shape: TFabShape.circle,
        ),
        'desc': 'Circle'
      },
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          shape: TFabShape.square,
        ),
        'desc': 'Square'
      },
    ]);
  }

  @Demo(group: 'fab')
  Widget _buildSizeFab(BuildContext context) {
    return _buildRowDemoWidthDescription([
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          size: TFabSize.large,
        ),
        'desc': 'Large'
      },
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          size: TFabSize.medium,
        ),
        'desc': 'Medium'
      },
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          size: TFabSize.small,
        ),
        'desc': 'Small'
      },
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          size: TFabSize.extraSmall,
        ),
        'desc': 'extraSmall'
      },
    ]);
  }

  Widget _buildRowDemo(List<TFab> fabs) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
      ),
      child: Row(
        children: fabs
            .map((fab) => Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: fab,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildRowDemoWidthDescription(List<Map<String, dynamic>> fabs) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 4, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: fabs
            .map(
              (fab) => Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // spacing: 24,
                  children: [
                    SizedBox(
                      height: 48,
                      child: Column(children: [fab['component']]),
                    ),
                    const SizedBox(height: 24),
                    TText(
                      fab['desc'],
                      style: const TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
