import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';
import '../../base/example_widget.dart';

class TDTagPage extends StatelessWidget {
  const TDTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(title: '标签 Tag', desc: '用于表明主体的类目，属性或状态',
        // padding: EdgeInsets.zero,
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(
                desc: '基础标签',
                builder: (context) {
                  return Row(
                    children: const [
                      SizedBox(
                        width: 16,
                      ),
                      TDTag('标签文字'),
                      SizedBox(
                        width: 16,
                      ),
                      TDTag(
                        '标签文字',
                        isStroke: true,
                      ),
                    ],
                  );
                }),
            ExampleItem(
                desc: '圆弧标签',
                builder: (context) {
                  return Row(
                    children: const [
                      SizedBox(
                        width: 16,
                      ),
                      TDTag(
                        '标签文字',
                        isCircle: true,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      TDTag(
                        '标签文字',
                        isCircle: true,
                        isStroke: true,
                      ),
                    ],
                  );
                }),
            ExampleItem(
                desc: '带图标的标签',
                builder: (context) {
                  return Row(
                    children: const [
                      SizedBox(
                        width: 16,
                      ),
                      TDTag(
                        '标签文字',
                        icon: Icon(
                          TDIcons.discount,
                          size: 14,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      TDTag(
                        '标签文字',
                        icon: Icon(
                          TDIcons.discount,
                          size: 14,
                        ),
                        isStroke: true,
                      ),
                    ],
                  );
                }),
            ExampleItem(
                desc: '可关闭的标签',
                builder: (context) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      TDTag(
                        '标签文字',
                        needCloseIcon: true,
                        onCloseTap: () {
                          TDToast.showText('点击关闭', context: context);
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      TDTag('标签文字', needCloseIcon: true, isStroke: true,
                          onCloseTap: () {
                        TDToast.showText('点击关闭', context: context);
                      }),
                    ],
                  );
                }),
            ExampleItem(
                desc: '可选中的标签', //
                builder: (context) {
                  return Wrap(
                      spacing: 8,
                      direction: Axis.vertical,
                      children: [
                        // 非浅色填充
                        Wrap(
                            spacing: 8,
                            children:const [
                              SizedBox(
                                width: 80,
                                child: TDText('dark'),
                              ),
                              TDSelectTag('未选中态', theme: TDTagTheme.primary,),
                              TDSelectTag('已选中态', theme: TDTagTheme.primary,isSelected: true,),
                              TDSelectTag('不可选态', theme: TDTagTheme.primary,disableSelect: true,),
                            ]),
                        // 浅色填充
                        Wrap(
                            spacing: 8,
                            children:const [
                              SizedBox(
                                width: 80,
                                child: TDText('light'),
                              ),
                              TDSelectTag('未选中态', theme: TDTagTheme.primary,isLight: true, ),
                              TDSelectTag('已选中态', theme: TDTagTheme.primary,isLight: true, isSelected: true,),
                              TDSelectTag('不可选态', theme: TDTagTheme.primary,isLight: true, disableSelect: true,),
                            ]),
                        // 非浅色描边
                        Wrap(
                            spacing: 8,
                            children:const [
                              SizedBox(
                                width: 80,
                                child: TDText('outline'),
                              ),
                              TDSelectTag('未选中态', theme: TDTagTheme.primary,isStroke: true,),
                              TDSelectTag('已选中态', theme: TDTagTheme.primary,isStroke: true,isSelected: true,),
                              TDSelectTag('不可选态', theme: TDTagTheme.primary,isStroke: true,disableSelect: true,),
                            ]),
                        // 浅色描边
                        Wrap(
                            spacing: 8,
                            children:const [
                              SizedBox(
                                width: 80,
                                child: TDText('light-outline'),
                              ),
                              TDSelectTag('未选中态', theme: TDTagTheme.primary,isStroke:true, isLight: true, ),
                              TDSelectTag('已选中态', theme: TDTagTheme.primary,isStroke:true, isLight: true, isSelected: true,),
                              TDSelectTag('不可选态', theme: TDTagTheme.primary,isStroke:true, isLight: true, disableSelect: true,),
                            ]),
                      ]);
                }),
          ]),
          ExampleModule(title: '组件状态（主题）', children: [
            ExampleItem(
                desc: '展示型标签',
                builder: (context) {
                  return Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    children: [
                      // 浅色填充
                      Wrap(
                        spacing: 8,
                        children: const [
                          TDTag('默认', isLight: true),
                          TDTag(
                            '主要',
                            isLight: true,
                            theme: TDTagTheme.primary,
                          ),
                          TDTag(
                            '警告',
                            isLight: true,
                            theme: TDTagTheme.warning,
                          ),
                          TDTag(
                            '危险',
                            isLight: true,
                            theme: TDTagTheme.danger,
                          ),
                          TDTag(
                            '成功',
                            isLight: true,
                            theme: TDTagTheme.success,
                          ),
                        ],
                      ),

                      // 非浅色填充
                      Wrap(
                        spacing: 8,
                        children: const [
                          TDTag('默认'),
                          TDTag(
                            '主要',
                            theme: TDTagTheme.primary,
                          ),
                          TDTag(
                            '警告',
                            theme: TDTagTheme.warning,
                          ),
                          TDTag(
                            '危险',
                            theme: TDTagTheme.danger,
                          ),
                          TDTag(
                            '成功',
                            theme: TDTagTheme.success,
                          ),
                        ],
                      ),

                      // 非浅色描边
                      Wrap(
                        spacing: 8,
                        children: const [
                          TDTag('默认', isStroke: true),
                          TDTag(
                            '主要',
                            isStroke: true,
                            theme: TDTagTheme.primary,
                          ),
                          TDTag(
                            '警告',
                            isStroke: true,
                            theme: TDTagTheme.warning,
                          ),
                          TDTag(
                            '危险',
                            isStroke: true,
                            theme: TDTagTheme.danger,
                          ),
                          TDTag(
                            '成功',
                            isStroke: true,
                            theme: TDTagTheme.success,
                          ),
                        ],
                      ),

                      // 浅色描边
                      Wrap(
                        spacing: 8,
                        children: const [
                          TDTag('默认', isStroke: true, isLight: true),
                          TDTag(
                            '主要',
                            isStroke: true,
                            isLight: true,
                            theme: TDTagTheme.primary,
                          ),
                          TDTag(
                            '警告',
                            isStroke: true,
                            isLight: true,
                            theme: TDTagTheme.warning,
                          ),
                          TDTag(
                            '危险',
                            isStroke: true,
                            isLight: true,
                            theme: TDTagTheme.danger,
                          ),
                          TDTag(
                            '成功',
                            isStroke: true,
                            isLight: true,
                            theme: TDTagTheme.success,
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ]),
          ExampleModule(title: '组件尺寸', children: [
            ExampleItem(builder: (context) {
              return Wrap(spacing: 8, direction: Axis.vertical, children: [
                // 不带关闭
                Wrap(spacing: 8, children: const [
                  TDTag(
                    '加大尺寸',
                    size: TDTagSize.extraLarge,
                  ),
                  TDTag(
                    '大尺寸',
                    size: TDTagSize.large,
                  ),
                  TDTag(
                    '中尺寸',
                    size: TDTagSize.medium,
                  ),
                  TDTag(
                    '小尺寸',
                    size: TDTagSize.small,
                  ),
                ]),
                // 带关闭
                Wrap(spacing: 8, children: const [
                  TDTag(
                    '加大尺寸',
                    needCloseIcon: true,
                    size: TDTagSize.extraLarge,
                  ),
                  TDTag(
                    '大尺寸',
                    needCloseIcon: true,
                    size: TDTagSize.large,
                  ),
                  TDTag(
                    '中尺寸',
                    needCloseIcon: true,
                    size: TDTagSize.medium,
                  ),
                  TDTag(
                    '小尺寸',
                    needCloseIcon: true,
                    size: TDTagSize.small,
                  ),
                ]),
              ]);
            })
          ])
        ], test: [
      ExampleItem(
          desc: '非浅色填充的各主题展示',
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                TDTag(
                  '标签文字',
                ),
                TDTag(
                  '标签文字',
                  theme: TDTagTheme.primary,
                ),
                TDTag(
                  '标签文字',
                  theme: TDTagTheme.warning,
                ),
                TDTag(
                  '标签文字',
                  theme: TDTagTheme.danger,
                ),
                TDTag(
                  '标签文字',
                  theme: TDTagTheme.success,
                ),
              ],
            );
          }),
      ExampleItem(
          desc: '浅色填充的各主题展示',
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                TDTag(
                  '标签文字',
                  isLight: true,
                ),
                TDTag(
                  '标签文字',
                  isLight: true,
                  theme: TDTagTheme.primary,
                ),
                TDTag(
                  '标签文字',
                  isLight: true,
                  theme: TDTagTheme.warning,
                ),
                TDTag(
                  '标签文字',
                  isLight: true,
                  theme: TDTagTheme.danger,
                ),
                TDTag(
                  '标签文字',
                  isLight: true,
                  theme: TDTagTheme.success,
                ),
              ],
            );
          }),
      ExampleItem(
          desc: '非浅色描边的各主题展示',
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                TDTag(
                  '标签文字',
                  isStroke: true,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  theme: TDTagTheme.primary,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  theme: TDTagTheme.warning,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  theme: TDTagTheme.danger,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  theme: TDTagTheme.success,
                ),
              ],
            );
          }),
      ExampleItem(
          desc: '浅色描边的各主题展示',
          builder: (context) {
            return Wrap(
              spacing: 8,
              children: const [
                TDTag(
                  '标签文字',
                  isStroke: true,
                  isLight: true,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  isLight: true,
                  theme: TDTagTheme.primary,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  isLight: true,
                  theme: TDTagTheme.warning,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  isLight: true,
                  theme: TDTagTheme.danger,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  isLight: true,
                  theme: TDTagTheme.success,
                ),
              ],
            );
          }),
      ExampleItem(
          desc: '各主题关闭图标颜色不会变',
          builder: (context) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                TDTag(
                  '标签文字',
                  isStroke: true,
                  needCloseIcon: true,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  needCloseIcon: true,
                  theme: TDTagTheme.primary,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  needCloseIcon: true,
                  theme: TDTagTheme.warning,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  needCloseIcon: true,
                  theme: TDTagTheme.danger,
                ),
                TDTag(
                  '标签文字',
                  isStroke: true,
                  needCloseIcon: true,
                  theme: TDTagTheme.success,
                ),
                TDTag(
                  '标签文字',
                  needCloseIcon: true,
                ),
                TDTag(
                  '标签文字',
                  needCloseIcon: true,
                  theme: TDTagTheme.primary,
                ),
                TDTag(
                  '标签文字',
                  needCloseIcon: true,
                  theme: TDTagTheme.warning,
                ),
                TDTag(
                  '标签文字',
                  needCloseIcon: true,
                  theme: TDTagTheme.danger,
                ),
                TDTag(
                  '标签文字',
                  needCloseIcon: true,
                  theme: TDTagTheme.success,
                ),
              ],
            );
          }),
      ExampleItem(
          desc: '带图标可关闭的标签',
          builder: (context) {
            return Row(
              children: const [
                SizedBox(
                  width: 16,
                ),
                TDTag(
                  '标签文字',
                  icon: Icon(
                    TDIcons.discount,
                    size: 14,
                  ),
                  needCloseIcon: true,
                ),
                SizedBox(
                  width: 16,
                ),
                TDTag(
                  '标签文字',
                  icon: Icon(
                    TDIcons.discount,
                    size: 14,
                  ),
                  needCloseIcon: true,
                  isStroke: true,
                ),
              ],
            );
          }),
      ExampleItem(
          desc: '各尺寸测试',
          builder: (context) {
            return Wrap(spacing: 8, direction: Axis.vertical, children: [
              // 带图标和关闭
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Wrap(spacing: 8, runSpacing: 8, children: const [
                  TDTag(
                    '加大尺寸',
                    icon: Icon(
                      TDIcons.discount,
                      size: 14,
                    ),
                    needCloseIcon: true,
                    size: TDTagSize.extraLarge,
                  ),
                  TDTag(
                    '大尺寸',
                    icon: Icon(
                      TDIcons.discount,
                      size: 14,
                    ),
                    needCloseIcon: true,
                    size: TDTagSize.large,
                  ),
                  TDTag(
                    '中尺寸',
                    icon: Icon(
                      TDIcons.discount,
                      size: 14,
                    ),
                    needCloseIcon: true,
                    size: TDTagSize.medium,
                  ),
                  TDTag(
                    '小尺寸',
                    icon: Icon(
                      TDIcons.discount,
                      size: 14,
                    ),
                    needCloseIcon: true,
                    size: TDTagSize.small,
                  ),
                ]),
              ),
              // 带图标和关闭,描边
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Wrap(spacing: 8, runSpacing: 8, children: const [
                  TDTag(
                    '加大尺寸',
                    isStroke: true,
                    icon: Icon(
                      TDIcons.discount,
                      size: 14,
                    ),
                    needCloseIcon: true,
                    size: TDTagSize.extraLarge,
                  ),
                  TDTag(
                    '大尺寸',
                    isStroke: true,
                    icon: Icon(
                      TDIcons.discount,
                      size: 14,
                    ),
                    needCloseIcon: true,
                    size: TDTagSize.large,
                  ),
                  TDTag(
                    '中尺寸',
                    isStroke: true,
                    icon: Icon(
                      TDIcons.discount,
                      size: 14,
                    ),
                    needCloseIcon: true,
                    size: TDTagSize.medium,
                  ),
                  TDTag(
                    '小尺寸',
                    isStroke: true,
                    icon: Icon(
                      TDIcons.discount,
                      size: 14,
                    ),
                    needCloseIcon: true,
                    size: TDTagSize.small,
                  ),
                ]),
              ),
            ]);
          }),
    ]);
  }
}
