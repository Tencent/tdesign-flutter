import 'package:flutter/material.dart';

import 'base/example_base.dart';
import 'page/t_button_page.dart';
import 'page/t_divider_page.dart';
import 'page/t_fab_page.dart';
import 'page/t_icon_page.dart';
import 'page/t_link_page.dart';
import 'page/t_text_page.dart';

PageBuilder _wrapInheritedTheme(WidgetBuilder builder) {
  return (context, model) {
    return ExamplePageInheritedTheme(model: model, child: builder(context));
  };
}

/// 新增的示例页面，在此增加模型即可,会自动注册增加按钮。示例页面编写参考 TTextPage()
List<ExamplePageModel> examplePageList = [];

// TEMPORARY MIGRATION COMPATIBILITY:
// 当前正式 PR 只迁入 CI / Theme / 基础组件及其 demo，先限制 example 入口只注册
// button / divider / fab / icon / link / text。后续组件迁移完成后再恢复全量 demo。
Map<String, List<ExamplePageModel>> exampleMap = {
  '基础': [
    ExamplePageModel(
        text: 'Button 按钮',
        name: 'button',
        pageBuilder: _wrapInheritedTheme((context) => const TButtonPage())),
    ExamplePageModel(
        text: 'Divider 分割线',
        name: 'divider',
        pageBuilder: _wrapInheritedTheme((context) => const TDividerPage())),
    ExamplePageModel(
        text: 'Fab 悬浮按钮',
        name: 'fab',
        pageBuilder: _wrapInheritedTheme((context) => const TFabPage())),
    ExamplePageModel(
        text: 'Icon 图标',
        name: 'icon',
        pageBuilder: _wrapInheritedTheme((context) => const TIconPage())),
    ExamplePageModel(
        text: 'Link 链接',
        name: 'link',
        pageBuilder: _wrapInheritedTheme((context) => const TLinkViewPage())),
    ExamplePageModel(
        text: 'Text 文本',
        name: 'text',
        pageBuilder: _wrapInheritedTheme((context) => const TTextPage())),
  ],
};

// TEMPORARY MIGRATION COMPATIBILITY:
// Sidebar demo 暂未迁入本 PR，先保留空列表以兼容现有首页/路由初始化代码。
// 后续 Sidebar 组件迁移时删除该兼容并恢复对应 demo 注册。
List<ExamplePageModel> sideBarExamplePage = [];
