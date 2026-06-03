import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TTagPage extends StatelessWidget {
  const TTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tTitle(context),
        desc: '用于表明主体的类目，属性或状态',
        exampleCodeGroup: 'tag',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
                desc: '基础标签',
                ignoreCode: true,
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      CodeWrapper(builder: _buildSimpleFillTag),
                      const SizedBox(
                        width: 16,
                      ),
                      CodeWrapper(builder: _buildSimpleOutlineTag),
                    ],
                  );
                }),
            ExampleItem(
                desc: '圆弧标签',
                ignoreCode: true,
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      CodeWrapper(builder: _buildCircleFillTag),
                      const SizedBox(
                        width: 16,
                      ),
                      CodeWrapper(builder: _buildCircleOutlineTag),
                    ],
                  );
                }),
            ExampleItem(
                desc: 'Mark标签',
                ignoreCode: true,
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      CodeWrapper(builder: _buildMarkFillTag),
                      const SizedBox(
                        width: 16,
                      ),
                      CodeWrapper(builder: _buildMarkOutlineTag),
                    ],
                  );
                }),
            ExampleItem(
                desc: '带图标的标签',
                ignoreCode: true,
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      CodeWrapper(builder: _buildIconFillTag),
                      const SizedBox(
                        width: 16,
                      ),
                      CodeWrapper(builder: _buildIconOutlineTag),
                    ],
                  );
                }),
            ExampleItem(
                desc: '可关闭的标签',
                ignoreCode: true,
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      CodeWrapper(builder: _buildCloseFillTag),
                      const SizedBox(
                        width: 16,
                      ),
                      CodeWrapper(builder: _buildCloseOutlineTag),
                    ],
                  );
                }),
            ExampleItem(
                desc: '可选中的标签',
                ignoreCode: true,
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child:
                        Wrap(spacing: 8, direction: Axis.vertical, children: [
                      // 非浅色填充
                      Row(
                        children: [
                          const SizedBox(
                            width: 80,
                            child: TText('dark'),
                          ),
                          CodeWrapper(builder: _buildDarkSelectTags)
                        ],
                      ),
                      // 浅色填充
                      Row(
                        children: [
                          const SizedBox(
                            width: 80,
                            child: TText('light'),
                          ),
                          CodeWrapper(builder: _buildLightSelectTags)
                        ],
                      ),
                      // 非浅色描边
                      Row(
                        children: [
                          const SizedBox(
                            width: 80,
                            child: TText('outline'),
                          ),
                          CodeWrapper(builder: _buildOutlineSelectTags)
                        ],
                      ),
                      // 浅色描边
                      Row(
                        children: [
                          const SizedBox(
                            width: 80,
                            child: TText('light-outline'),
                          ),
                          CodeWrapper(builder: _buildLightOutlineSelectTags)
                        ],
                      ),
                    ]),
                  );
                }),
          ]),
          ExampleModule(title: '组件状态（主题）', children: [
            ExampleItem(
                desc: '展示型标签',
                ignoreCode: true,
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: Wrap(
                      spacing: 8,
                      direction: Axis.vertical,
                      children: [
                        // 浅色填充
                        CodeWrapper(builder: _buildLightShowTags),

                        // 非浅色填充
                        CodeWrapper(builder: _buildDarkShowTags),

                        // 非浅色描边
                        CodeWrapper(builder: _buildOutlineShowTags),

                        // 浅色描边
                        CodeWrapper(builder: _buildLightOutlineShowTags),
                      ],
                    ),
                  );
                }),
          ]),
          ExampleModule(title: '组件尺寸', children: [
            ExampleItem(
                ignoreCode: true,
                builder: (context) {
                  return Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child:
                        Wrap(spacing: 8, direction: Axis.vertical, children: [
                      // 不带关闭
                      CodeWrapper(builder: _buildAllSizeTags),
                      // 带关闭
                      CodeWrapper(builder: _buildAllSizeCloseTags),
                    ]),
                  );
                })
          ])
        ],
        test: [
          ExampleItem(
              desc: '非浅色填充的各主题展示',
              ignoreCode: true,
              builder: (context) {
                return const Wrap(
                  spacing: 8,
                  children: [
                    TTag(
                      '标签文字',
                    ),
                    TTag(
                      '标签文字',
                      theme: TTagTheme.primary,
                    ),
                    TTag(
                      '标签文字',
                      theme: TTagTheme.warning,
                    ),
                    TTag(
                      '标签文字',
                      theme: TTagTheme.danger,
                    ),
                    TTag(
                      '标签文字',
                      theme: TTagTheme.success,
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: '浅色填充的各主题展示',
              ignoreCode: true,
              builder: (context) {
                return const Wrap(
                  spacing: 8,
                  children: [
                    TTag(
                      '标签文字',
                      isLight: true,
                    ),
                    TTag(
                      '标签文字',
                      isLight: true,
                      theme: TTagTheme.primary,
                    ),
                    TTag(
                      '标签文字',
                      isLight: true,
                      theme: TTagTheme.warning,
                    ),
                    TTag(
                      '标签文字',
                      isLight: true,
                      theme: TTagTheme.danger,
                    ),
                    TTag(
                      '标签文字',
                      isLight: true,
                      theme: TTagTheme.success,
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: '非浅色描边的各主题展示',
              ignoreCode: true,
              builder: (context) {
                return const Wrap(
                  spacing: 8,
                  children: [
                    TTag(
                      '标签文字',
                      isOutline: true,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      theme: TTagTheme.primary,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      theme: TTagTheme.warning,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      theme: TTagTheme.danger,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      theme: TTagTheme.success,
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: '浅色描边的各主题展示',
              ignoreCode: true,
              builder: (context) {
                return const Wrap(
                  spacing: 8,
                  children: [
                    TTag(
                      '标签文字',
                      isOutline: true,
                      isLight: true,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      isLight: true,
                      theme: TTagTheme.primary,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      isLight: true,
                      theme: TTagTheme.warning,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      isLight: true,
                      theme: TTagTheme.danger,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      isLight: true,
                      theme: TTagTheme.success,
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: '各主题关闭图标颜色不会变',
              ignoreCode: true,
              builder: (context) {
                return const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TTag(
                      '标签文字',
                      isOutline: true,
                      needCloseIcon: true,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      needCloseIcon: true,
                      theme: TTagTheme.primary,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      needCloseIcon: true,
                      theme: TTagTheme.warning,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      needCloseIcon: true,
                      theme: TTagTheme.danger,
                    ),
                    TTag(
                      '标签文字',
                      isOutline: true,
                      needCloseIcon: true,
                      theme: TTagTheme.success,
                    ),
                    TTag(
                      '标签文字',
                      needCloseIcon: true,
                    ),
                    TTag(
                      '标签文字',
                      needCloseIcon: true,
                      theme: TTagTheme.primary,
                    ),
                    TTag(
                      '标签文字',
                      needCloseIcon: true,
                      theme: TTagTheme.warning,
                    ),
                    TTag(
                      '标签文字',
                      needCloseIcon: true,
                      theme: TTagTheme.danger,
                    ),
                    TTag(
                      '标签文字',
                      needCloseIcon: true,
                      theme: TTagTheme.success,
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: '带图标可关闭的标签',
              ignoreCode: true,
              builder: (context) {
                return const Row(
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    TTag(
                      '标签文字',
                      icon: TIcons.discount,
                      needCloseIcon: true,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    TTag(
                      '标签文字',
                      icon: TIcons.discount,
                      needCloseIcon: true,
                      isOutline: true,
                    ),
                  ],
                );
              }),
          ExampleItem(
              desc: '各尺寸测试',
              ignoreCode: true,
              builder: (context) {
                return Wrap(spacing: 8, direction: Axis.vertical, children: [
                  // 带图标和关闭
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: const Wrap(spacing: 8, runSpacing: 8, children: [
                      TTag(
                        '加大尺寸',
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        size: TTagSize.extraLarge,
                      ),
                      TTag(
                        '大尺寸',
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        size: TTagSize.large,
                      ),
                      TTag(
                        '中尺寸',
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        size: TTagSize.medium,
                      ),
                      TTag(
                        '小尺寸',
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        size: TTagSize.small,
                      ),
                    ]),
                  ),
                  // 带图标和关闭,描边
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: const Wrap(spacing: 8, runSpacing: 8, children: [
                      TTag(
                        '加大尺寸',
                        isOutline: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        size: TTagSize.extraLarge,
                      ),
                      TTag(
                        '大尺寸',
                        isOutline: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        size: TTagSize.large,
                      ),
                      TTag(
                        '中尺寸',
                        isOutline: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        size: TTagSize.medium,
                      ),
                      TTag(
                        '小尺寸',
                        isOutline: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        size: TTagSize.small,
                      ),
                    ]),
                  ),
                ]);
              }),
          ExampleItem(
              desc: '可选各状态测试',
              ignoreCode: true,
              builder: (context) {
                return Wrap(spacing: 8, direction: Axis.vertical, children: [
                  // Normal
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: const Wrap(spacing: 8, runSpacing: 8, children: [
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        shape: TTagShape.mark,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isSelected: true,
                        shape: TTagShape.mark,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        disableSelect: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: TTagShape.mark,
                      ),
                    ]),
                  ),
                  // Light
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: const Wrap(spacing: 8, runSpacing: 8, children: [
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isLight: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isLight: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        shape: TTagShape.mark,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isLight: true,
                        isSelected: true,
                        shape: TTagShape.mark,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        icon: TIcons.discount,
                        isLight: true,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isLight: true,
                        disableSelect: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isLight: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: TTagShape.mark,
                      ),
                    ]),
                  ),
                  // Outline
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: const Wrap(spacing: 8, runSpacing: 8, children: [
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        shape: TTagShape.mark,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        isSelected: true,
                        shape: TTagShape.mark,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        icon: TIcons.discount,
                        isOutline: true,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        disableSelect: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: TTagShape.mark,
                      ),
                    ]),
                  ),
                  // Outline-Light
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: const Wrap(spacing: 8, runSpacing: 8, children: [
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        shape: TTagShape.mark,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        isSelected: true,
                        shape: TTagShape.mark,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        icon: TIcons.discount,
                        isOutline: true,
                        isLight: true,
                        needCloseIcon: true,
                        isSelected: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        disableSelect: true,
                      ),
                      TSelectTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        disableSelect: true,
                        shape: TTagShape.mark,
                      ),
                    ]),
                  ),
                ]);
              }),
          ExampleItem(
              desc: '展示各状态测试',
              ignoreCode: true,
              builder: (context) {
                return Wrap(spacing: 8, direction: Axis.vertical, children: [
                  // Normal
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: const Wrap(spacing: 8, runSpacing: 8, children: [
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        shape: TTagShape.mark,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        shape: TTagShape.round,
                        disable: true,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: TTagShape.mark,
                      ),
                    ]),
                  ),
                  // Light
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: const Wrap(spacing: 8, runSpacing: 8, children: [
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isLight: true,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isLight: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        shape: TTagShape.mark,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        shape: TTagShape.round,
                        isLight: true,
                        disable: true,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isLight: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: TTagShape.mark,
                      ),
                    ]),
                  ),
                  // Outline
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: const Wrap(spacing: 8, runSpacing: 8, children: [
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        shape: TTagShape.mark,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        shape: TTagShape.round,
                        isOutline: true,
                        disable: true,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: TTagShape.mark,
                      ),
                    ]),
                  ),
                  // Outline-Light
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    child: const Wrap(spacing: 8, runSpacing: 8, children: [
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        shape: TTagShape.mark,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        shape: TTagShape.round,
                        isOutline: true,
                        isLight: true,
                        disable: true,
                      ),
                      TTag(
                        'Tag',
                        theme: TTagTheme.primary,
                        isOutline: true,
                        isLight: true,
                        icon: TIcons.discount,
                        needCloseIcon: true,
                        disable: true,
                        shape: TTagShape.mark,
                      ),
                    ]),
                  ),
                ]);
              }),
        ]);
  }

  @Demo(group: 'tag')
  TTag _buildSimpleOutlineTag(BuildContext context) {
    return const TTag(
      '标签文字',
      isOutline: true,
    );
  }

  @Demo(group: 'tag')
  TTag _buildSimpleFillTag(BuildContext context) {
    return const TTag('标签文字');
  }

  @Demo(group: 'tag')
  Widget _buildCircleFillTag(BuildContext context) {
    return const TTag(
      '标签文字',
      shape: TTagShape.round,
    );
  }

  @Demo(group: 'tag')
  Widget _buildCircleOutlineTag(BuildContext context) {
    return const TTag(
      '标签文字',
      shape: TTagShape.round,
      isOutline: true,
    );
  }

  @Demo(group: 'tag')
  Widget _buildMarkFillTag(BuildContext context) {
    return const TTag(
      '标签文字',
      shape: TTagShape.mark,
    );
  }

  @Demo(group: 'tag')
  Widget _buildMarkOutlineTag(BuildContext context) {
    return const TTag(
      '标签文字',
      shape: TTagShape.mark,
      isOutline: true,
    );
  }

  @Demo(group: 'tag')
  Widget _buildIconFillTag(BuildContext context) {
    return const TTag(
      '标签文字',
      icon: TIcons.discount,
    );
  }

  @Demo(group: 'tag')
  Widget _buildIconOutlineTag(BuildContext context) {
    return const TTag(
      '标签文字',
      icon: TIcons.discount,
      isOutline: true,
    );
  }

  @Demo(group: 'tag')
  Widget _buildCloseFillTag(BuildContext context) {
    return TTag(
      '标签文字',
      needCloseIcon: true,
      onCloseTap: () {
        TToast.showText('点击关闭', context: context);
      },
    );
  }

  @Demo(group: 'tag')
  Widget _buildCloseOutlineTag(BuildContext context) {
    return TTag('标签文字', needCloseIcon: true, isOutline: true, onCloseTap: () {
      TToast.showText('点击关闭', context: context);
    });
  }

  @Demo(group: 'tag')
  Widget _buildDarkSelectTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TSelectTag(
        '未选中态',
        theme: TTagTheme.primary,
      ),
      TSelectTag(
        '已选中态',
        theme: TTagTheme.primary,
        isSelected: true,
      ),
      TSelectTag(
        '不可选态',
        theme: TTagTheme.primary,
        disableSelect: true,
      ),
    ]);
  }

  @Demo(group: 'tag')
  Widget _buildLightSelectTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TSelectTag(
        '未选中态',
        theme: TTagTheme.primary,
        isLight: true,
      ),
      TSelectTag(
        '已选中态',
        theme: TTagTheme.primary,
        isLight: true,
        isSelected: true,
      ),
      TSelectTag(
        '不可选态',
        theme: TTagTheme.primary,
        isLight: true,
        disableSelect: true,
      ),
    ]);
  }

  @Demo(group: 'tag')
  Widget _buildOutlineSelectTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TSelectTag(
        '未选中态',
        theme: TTagTheme.primary,
        isOutline: true,
      ),
      TSelectTag(
        '已选中态',
        theme: TTagTheme.primary,
        isOutline: true,
        isSelected: true,
      ),
      TSelectTag(
        '不可选态',
        theme: TTagTheme.primary,
        isOutline: true,
        disableSelect: true,
      ),
    ]);
  }

  @Demo(group: 'tag')
  Widget _buildLightOutlineSelectTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TSelectTag(
        '未选中态',
        theme: TTagTheme.primary,
        isOutline: true,
        isLight: true,
      ),
      TSelectTag(
        '已选中态',
        theme: TTagTheme.primary,
        isOutline: true,
        isLight: true,
        isSelected: true,
      ),
      TSelectTag(
        '不可选态',
        theme: TTagTheme.primary,
        isOutline: true,
        isLight: true,
        disableSelect: true,
      ),
    ]);
  }

  @Demo(group: 'tag')
  Widget _buildLightShowTags(BuildContext context) {
    return const Wrap(
      spacing: 8,
      children: [
        TTag('默认', isLight: true),
        TTag(
          '主要',
          isLight: true,
          theme: TTagTheme.primary,
        ),
        TTag(
          '警告',
          isLight: true,
          theme: TTagTheme.warning,
        ),
        TTag(
          '危险',
          isLight: true,
          theme: TTagTheme.danger,
        ),
        TTag(
          '成功',
          isLight: true,
          theme: TTagTheme.success,
        ),
      ],
    );
  }

  @Demo(group: 'tag')
  Widget _buildDarkShowTags(BuildContext context) {
    return const Wrap(
      spacing: 8,
      children: [
        TTag('默认'),
        TTag(
          '主要',
          theme: TTagTheme.primary,
        ),
        TTag(
          '警告',
          theme: TTagTheme.warning,
        ),
        TTag(
          '危险',
          theme: TTagTheme.danger,
        ),
        TTag(
          '成功',
          theme: TTagTheme.success,
        ),
      ],
    );
  }

  @Demo(group: 'tag')
  Widget _buildOutlineShowTags(BuildContext context) {
    return const Wrap(
      spacing: 8,
      children: [
        TTag('默认', isOutline: true),
        TTag(
          '主要',
          isOutline: true,
          theme: TTagTheme.primary,
        ),
        TTag(
          '警告',
          isOutline: true,
          theme: TTagTheme.warning,
        ),
        TTag(
          '危险',
          isOutline: true,
          theme: TTagTheme.danger,
        ),
        TTag(
          '成功',
          isOutline: true,
          theme: TTagTheme.success,
        ),
      ],
    );
  }

  @Demo(group: 'tag')
  Widget _buildLightOutlineShowTags(BuildContext context) {
    return const Wrap(
      spacing: 8,
      children: [
        TTag('默认', isOutline: true, isLight: true),
        TTag(
          '主要',
          isOutline: true,
          isLight: true,
          theme: TTagTheme.primary,
        ),
        TTag(
          '警告',
          isOutline: true,
          isLight: true,
          theme: TTagTheme.warning,
        ),
        TTag(
          '危险',
          isOutline: true,
          isLight: true,
          theme: TTagTheme.danger,
        ),
        TTag(
          '成功',
          isOutline: true,
          isLight: true,
          theme: TTagTheme.success,
        ),
      ],
    );
  }

  @Demo(group: 'tag')
  Widget _buildAllSizeTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TTag(
        '加大尺寸',
        size: TTagSize.extraLarge,
      ),
      TTag(
        '大尺寸',
        size: TTagSize.large,
      ),
      TTag(
        '中尺寸',
        size: TTagSize.medium,
      ),
      TTag(
        '小尺寸',
        size: TTagSize.small,
      ),
    ]);
  }

  @Demo(group: 'tag')
  Widget _buildAllSizeCloseTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TTag(
        '加大尺寸',
        needCloseIcon: true,
        size: TTagSize.extraLarge,
      ),
      TTag(
        '大尺寸',
        needCloseIcon: true,
        size: TTagSize.large,
      ),
      TTag(
        '中尺寸',
        needCloseIcon: true,
        size: TTagSize.medium,
      ),
      TTag(
        '小尺寸',
        needCloseIcon: true,
        size: TTagSize.small,
      ),
    ]);
  }
}
