import 'package:flutter/material.dart';

import 'base/example_base.dart';
/*
import 'page/sidebar/t_sidebar_page.dart';
import 'page/sidebar/t_sidebar_page_anchor.dart';
import 'page/sidebar/t_sidebar_page_custom.dart';
import 'page/sidebar/t_sidebar_page_icon.dart';
import 'page/sidebar/t_sidebar_page_loading.dart';
import 'page/sidebar/t_sidebar_page_outline.dart';
import 'page/sidebar/t_sidebar_page_pagination.dart';
import 'page/sidebar/t_sidebar_page_unselected_color.dart';
*/
// V1.0 Button 示例
import 'page/t_button_page.dart';
/*
import 'page/t_action_sheet_page.dart';
import 'page/t_avatar_page.dart';
import 'page/t_backtop_page.dart';
import 'page/t_badge_page.dart';
import 'page/t_bottom_tab_bar_page.dart';
import 'page/t_calendar_page.dart';
import 'page/t_cascader_page.dart';
import 'page/t_cell_page.dart';
import 'page/t_checkbox_page.dart';
import 'page/t_collapse_page.dart';
import 'page/t_date_time_picker_page.dart';
import 'page/t_dialog_page.dart';
import 'page/t_divider_page.dart';
import 'page/t_drawer_page.dart';
import 'page/t_dropdown_menu_page.dart';
import 'page/t_empty_page.dart';
import 'page/t_fab_page.dart';
import 'page/t_font_page.dart';
import 'page/t_footer_page.dart';
import 'page/t_form_page.dart';
import 'page/t_icon_page.dart';
import 'page/t_image_page.dart';
import 'page/t_image_viewer_page.dart';
import 'page/t_indexes_page.dart';
import 'page/t_input_page.dart';
import 'page/t_link_page.dart';
import 'page/t_loading_page.dart';
import 'page/t_message_page.dart';
import 'page/t_navbar_page.dart';
import 'page/t_notice_bar_page.dart';
import 'page/t_picker_page.dart';
import 'page/t_popover_page.dart';
import 'page/t_popup_page.dart';
import 'page/t_progress_page.dart';
import 'page/t_radio_page.dart';
import 'page/t_radius_page.dart';
import 'page/t_rate_page.dart';
import 'page/t_refresh_page.dart';
import 'page/t_result_page.dart';
import 'page/t_search_bar_page.dart';
import 'page/t_shadows_page.dart';
import 'page/t_skeleton_page.dart';
import 'page/t_slider_page.dart';
import 'page/t_stepper_page.dart';
import 'page/t_steps_page.dart';
import 'page/t_swipe_cell_page.dart';
import 'page/t_swiper_page.dart';
import 'page/t_switch_page.dart';
import 'page/t_table_page.dart';
import 'page/t_tabs_page.dart';
import 'page/t_tag_page.dart';
import 'page/t_text_page.dart';
import 'page/t_textarea_page.dart';
import 'page/t_theme_page.dart';
import 'page/t_time_counter_page.dart';
import 'page/t_toast_page.dart';
import 'page/t_tree_select_page.dart';
import 'page/t_upload_page.dart';
import 'page/todo_page.dart';
*/

PageBuilder _wrapInheritedTheme(WidgetBuilder builder) {
  return (context, model) {
    return ExamplePageInheritedTheme(model: model, child: builder(context));
  };
}

/// 新增的示例页面，在此增加模型即可,会自动注册增加按钮。示例页面编写参考TTextPage()
List<ExamplePageModel> examplePageList = [];

Map<String, List<ExamplePageModel>> exampleMap = {
  '基础': [
    ExamplePageModel(
        text: 'Button 按钮 (V1.0)',
        name: 'button',
        pageBuilder: _wrapInheritedTheme((context) => const TButtonPage())),
    /*
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
    */
  ],
  // TODO: 其他组件页面待升级至 V1.0 后取消注释
};

/* TODO: 取消注释 sideBarExamplePage 当 sidebar 页面升级至 V1.0
List<ExamplePageModel> sideBarExamplePage = [
  ExamplePageModel(
      text: 'SideBar 切页',
      name: 'SideBarPagination',
      isTodo: false,
      showAction: false,
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarPaginationPage())),
  ExamplePageModel(
      text: 'SideBar 锚点',
      name: 'SideBarAnchor',
      isTodo: false,
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarAnchorPage())),
  ExamplePageModel(
      text: 'SideBar 带图标',
      name: 'SideBarIcon',
      isTodo: false,
      pageBuilder: _wrapInheritedTheme((context) => const TSideBarIconPage())),
  ExamplePageModel(
      text: 'SideBar 非通栏选项样式',
      name: 'SideBarOutline',
      isTodo: false,
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarOutlinePage())),
  ExamplePageModel(
      text: 'SideBar 自定义样式',
      name: 'SideBarCustom',
      isTodo: false,
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarCustomPage())),
  ExamplePageModel(
      text: 'SideBar 延迟加载',
      name: 'SideBarLoading',
      isTodo: false,
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarLoadingPage())),
  ExamplePageModel(
      text: 'SideBar 自定义未选中颜色',
      name: 'SideBarUnselectedColor',
      isTodo: false,
      pageBuilder: _wrapInheritedTheme(
          (context) => const TSideBarUnSelectedColorPage()))
];
*/
