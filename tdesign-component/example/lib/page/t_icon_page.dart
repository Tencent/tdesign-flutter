import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TIconPage extends StatefulWidget {
  const TIconPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TIconPageState();
}

class _TIconPageState extends State<TIconPage> {
  bool showBorder = false;

  List<MapEntry<String, IconData>> iconList = [];

  var isLoading = false;

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
            title: 'v1.0 新特性',
            children: [
              ExampleItem(desc: 'TIcon 基础用法:', builder: _buildBasicTIcon),
              ExampleItem(desc: '指定 size 和 color:', builder: _buildSizedTIcon),
              ExampleItem(
                  desc: 'TIcon.fromName 通过名称:', builder: _buildFromName),
              ExampleItem(
                  desc: 'v1.0 Theme 默认 size/color:', builder: _buildThemeDemo),
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

  @Demo(group: 'icon')
  Widget _buildBasicTIcon(BuildContext context) {
    // v1.0 新增：TIcon Widget（Material Icon 薄包装）
    return const Row(
      children: [
        TIcon(TIcons.home_filled),
        SizedBox(width: 16),
        TIcon(TIcons.setting),
        SizedBox(width: 16),
        TIcon(TIcons.notification),
      ],
    );
  }

  @Demo(group: 'icon')
  Widget _buildSizedTIcon(BuildContext context) {
    // 构造器参数 size/color 直接生效
    return Row(
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

  @Demo(group: 'icon')
  Widget _buildFromName(BuildContext context) {
    // 通过图标名查找（内部查找 TIcons.allIconsMap）
    return Row(
      children: [
        TIcon.fromName('home_filled'),
        const SizedBox(width: 16),
        TIcon.fromName('heart_filled', color: context.tTheme.errorNormalColor),
        const SizedBox(width: 16),
        TIcon.fromName('star_filled', color: context.tTheme.warningNormalColor),
      ],
    );
  }

  @Demo(group: 'icon')
  Widget _buildThemeDemo(BuildContext context) {
    // v1.0 新增：通过 TIconThemeData 统一控制子树 TIcon 默认 size 和 color
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
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

  @Demo(group: 'icon')
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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

  @Demo(group: 'icon')
  Widget _showAllIcons(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.topLeft,
            child: const Wrap(
              children: [
                TText('筛选Icon请前往TDesign官网(长按网址可复制):'),
                SelectableText('https://tdesign.tencent.com/icons')
              ],
            ),
          ),
          TSearchBar(
            hintText: '搜索',
            onSubmitted: (text) {
              setState(() {
                iconList = [];
                isLoading = true;
              });
              Future.delayed(const Duration(milliseconds: 30), () {
                var list = <MapEntry<String, IconData>>[];
                TIcons.allIconsMap.forEach((key, value) {
                  if (key.contains(text)) {
                    list.add(MapEntry(key, value));
                  }
                });
                if (!mounted) {
                  return;
                }
                setState(() {
                  iconList = list;
                  isLoading = false;
                });
              });
            },
            onClearPressed: () {
              setState(() {
                iconList = TIcons.allIconsMap.entries.toList();
              });
            },
          ),
          TCell(
            title: const Text('显示边框'),
            note: TSwitch(
              value: showBorder,
              onChanged: (value) {
                setState(() {
                  showBorder = value;
                });
              },
            ),
          ),
          Builder(builder: (context) {
            if (iconList.isEmpty) {
              return Container(
                alignment: Alignment.center,
                child: isLoading ? const TText('加载中...') : const TText('暂无内容'),
              );
            }

            var width = MediaQuery.of(context).size.width * 0.4;

            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: Wrap(
                      spacing: 16,
                      runSpacing: 18,
                      children: iconList.map((item) {
                        return SizedBox(
                          width: width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: showBorder
                                      ? context.tTheme.brandDisabledColor
                                      : Colors.transparent,
                                ),
                                child: TIcon(item.value, size: 32),
                              ),
                              TText(item.key)
                            ],
                          ),
                        );
                      }).toList()),
                ));
          })
        ],
      ),
    );
  }
}
