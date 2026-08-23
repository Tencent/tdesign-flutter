import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' hide TIcons;
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';
import 'package:url_launcher/link.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TIconPage extends StatefulWidget {
  const TIconPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIconPageState();
}

class _TIconPageState extends State<TIconPage> {
  List<MapEntry<String, IconData>> iconList = [];

  @override
  void initState() {
    super.initState();

    iconList = TIcons.allIconsMap.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tTitle(),
        desc: 'Icon 作为UI构成中重要的元素，一定程度上影响UI界面整体呈现出的风格。',
        exampleCodeGroup: 'icon',
        children: [
          ExampleModule(
            title: '主题与图标',
            children: [
              ExampleItem(desc: 'TIcon 基础用法:', builder: _buildBasicTIcon),
              ExampleItem(desc: '指定 size 和 color:', builder: _buildSizedTIcon),
              ExampleItem(
                  desc: 'TIcon.fromName 通过名称:', builder: _buildFromName),
              ExampleItem(
                  desc: 'Theme 默认 size/color:', builder: _buildThemeDemo),
              ExampleItem(desc: '构造器优先级覆盖 Theme:', builder: _buildPriorityDemo),
            ],
          ),
          ExampleModule(
            title: 'icon示例',
            children: [
              ExampleItem(
                desc: 'icon数量: ${TIcons.allIconsMap.length}',
                builder: _showAllIcons,
              )
            ],
          )
        ]);
  }

  @ExampleCode(group: 'icon')
  Widget _buildBasicTIcon(BuildContext context) {
    // TIcon Widget（Material Icon 薄包装）
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TIcon(TIcons.home_filled),
        SizedBox(width: 16),
        TIcon(TIcons.setting),
        SizedBox(width: 16),
        TIcon(TIcons.notification),
      ],
    );
  }

  @ExampleCode(group: 'icon')
  Widget _buildSizedTIcon(BuildContext context) {
    // 构造器参数 size/color 直接生效
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TIcon(TIcons.home_filled,
            size: 32, color: context.tTheme.brandNormalColor),
        const SizedBox(width: 16),
        TIcon(TIcons.setting, size: 28, color: context.tTheme.errorNormalColor),
        const SizedBox(width: 16),
        TIcon(TIcons.notification,
            size: 24, color: context.tTheme.warningNormalColor),
      ],
    );
  }

  @ExampleCode(group: 'icon')
  Widget _buildFromName(BuildContext context) {
    // 通过图标名查找（内部查找 TIcons.allIconsMap）
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TIcon.fromName('home_filled'),
        const SizedBox(width: 16),
        TIcon.fromName('heart_filled', color: context.tTheme.errorNormalColor),
        const SizedBox(width: 16),
        TIcon.fromName('star_filled', color: context.tTheme.warningNormalColor),
      ],
    );
  }

  @ExampleCode(group: 'icon')
  Widget _buildThemeDemo(BuildContext context) {
    // 通过 TIconThemeData 统一控制子树 TIcon 默认 size 和 color
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          ...Theme.of(context).extensions.values,
          TIconThemeData(
            size: 36,
            color: context.tTheme.brandNormalColor,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TIcon(TIcons.home_filled),
              SizedBox(width: 16),
              TIcon(TIcons.setting),
              SizedBox(width: 16),
              TIcon(TIcons.notification),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '↑ 继承 TIconThemeData 默认 size=36 和品牌色',
            style: TextStyle(
              fontSize: 12,
              color: context.tTheme.textColorSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'icon')
  Widget _buildPriorityDemo(BuildContext context) {
    // 优先级链：构造器参数 > TIconThemeData > IconTheme
    // 子树 TIconThemeData 设置 size=36，但构造器指定 size=20 会覆盖
    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [
          ...Theme.of(context).extensions.values,
          TIconThemeData(
            size: 36,
            color: context.tTheme.brandNormalColor,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 构造器 size 覆盖 Theme 的 36
              const TIcon(TIcons.home_filled, size: 20),
              const SizedBox(width: 16),
              // 构造器 color 覆盖 Theme 的品牌色
              TIcon(TIcons.setting, color: context.tTheme.errorNormalColor),
              const SizedBox(width: 16),
              // 无构造器参数，继承 Theme 默认
              const TIcon(TIcons.notification),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '↑ 前两个图标构造器覆盖 Theme，第三个继承 Theme',
            style: TextStyle(
              fontSize: 12,
              color: context.tTheme.textColorSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'icon')
  Widget _showAllIcons(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          RepaintBoundary(
            key: const Key('icon-official-link-section'),
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.topLeft,
              color: context.tTheme.bgColorContainer,
              child: Link(
                key: const Key('icon-official-link'),
                uri: Uri.parse('https://tdesign.tencent.com/icons'),
                target: LinkTarget.blank,
                builder: (context, followLink) => TLink(
                  child: const Text('https://tdesign.tencent.com/icons'),
                  prefixIcon: const Icon(TIcons.link),
                  suffixIcon: const Icon(TIcons.jump),
                  colorScheme: TLinkColorScheme.primary,
                  semanticLabel: '打开 TDesign 图标官网',
                  onPressed: followLink,
                ),
              ),
            ),
          ),
          TSearchBar(
            hintText: '搜索',
            onChanged: (text) {
              final query = text.trim().toLowerCase();
              setState(() {
                iconList = query.isEmpty
                    ? TIcons.allIconsMap.entries.toList()
                    : TIcons.allIconsMap.entries
                        .where((item) => item.key.toLowerCase().contains(query))
                        .toList();
              });
            },
          ),
          Builder(builder: (context) {
            if (iconList.isEmpty) {
              return const SizedBox(
                height: 96,
                child: Center(child: TText('暂无内容')),
              );
            }

            return IconCatalogGrid(
              icons: iconList,
            );
          })
        ],
      ),
    );
  }
}

/// Icon Demo 使用的懒加载网格，避免一次性创建全部图标。
@visibleForTesting
class IconCatalogGrid extends StatelessWidget {
  const IconCatalogGrid({
    super.key,
    required this.icons,
  });

  final List<MapEntry<String, IconData>> icons;

  Future<void> _copyIcon(BuildContext context, String name) async {
    final code = 'TIcon(TIcons.$name)';
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('已复制 $code'),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: GridView.builder(
        key: const Key('icon-catalog-grid'),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 96,
          mainAxisExtent: 64,
          mainAxisSpacing: 15,
        ),
        itemCount: icons.length,
        itemBuilder: (context, index) {
          final item = icons[index];
          return Semantics(
            button: true,
            label: '${item.key} 图标',
            hint: '点击复制代码',
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () => _copyIcon(context, item.key),
              child: Container(
                key: ValueKey('icon-catalog-item-${item.key}'),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TIcon(item.value, size: 24),
                    const SizedBox(height: 4),
                    TText(
                      item.key,
                      font: context.tTheme.fontBodySmall,
                      textColor: context.tTheme.textColorPlaceholder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
