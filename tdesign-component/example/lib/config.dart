import 'package:flutter/material.dart';

import 'base/example_base.dart';
import 'page/sidebar/t_sidebar_page.dart';
import 'page/sidebar/t_sidebar_page_anchor.dart';
import 'page/sidebar/t_sidebar_page_custom.dart';
import 'page/sidebar/t_sidebar_page_icon.dart';
import 'page/sidebar/t_sidebar_page_loading.dart';
import 'page/sidebar/t_sidebar_page_outline.dart';
import 'page/sidebar/t_sidebar_page_pagination.dart';
import 'page/sidebar/t_sidebar_page_unselected_color.dart';
import 'page/t_action_sheet_page.dart';
import 'page/t_avatar_page.dart';
import 'page/t_backtop_page.dart';
import 'page/t_badge_page.dart';
import 'page/t_button_page.dart';
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
import 'page/t_rate_page.dart';
import 'page/t_refresh_page.dart';
import 'page/t_result_page.dart';
import 'page/t_search_bar_page.dart';
import 'page/t_skeleton_page.dart';
import 'page/t_slider_page.dart';
import 'page/t_stepper_page.dart';
import 'page/t_steps_page.dart';
import 'page/t_swipe_cell_page.dart';
import 'page/t_swiper_page.dart';
import 'page/t_switch_page.dart';
import 'page/t_tab_bar_page.dart';
import 'page/t_table_page.dart';
import 'page/t_tabs_page.dart';
import 'page/t_tag_page.dart';
import 'page/t_text_page.dart';
import 'page/t_textarea_page.dart';
import 'page/t_time_counter_page.dart';
import 'page/t_toast_page.dart';
import 'page/t_tree_select_page.dart';
import 'page/t_upload_page.dart';

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
    ExamplePageModel(
        text: 'Divider 分割线 (V1.0)',
        name: 'divider',
        pageBuilder: _wrapInheritedTheme((context) => const TDividerPage())),
    ExamplePageModel(
        text: 'Fab 悬浮按钮 (V1.0)',
        name: 'fab',
        pageBuilder: _wrapInheritedTheme((context) => const TFabPage())),
    ExamplePageModel(
        text: 'Link 链接 (V1.0)',
        name: 'link',
        pageBuilder: _wrapInheritedTheme((context) => const TLinkViewPage())),
    ExamplePageModel(
        text: 'Text 文本 (V1.0)',
        name: 'text',
        pageBuilder: _wrapInheritedTheme((context) => const TTextPage())),
    ExamplePageModel(
        text: 'Icon 图标 (V1.0)',
        name: 'icon',
        pageBuilder: _wrapInheritedTheme((context) => const TIconPage())),
  ],
  '导航': [
    ExamplePageModel(
        text: 'BackTop 返回顶部 (V1.0)',
        name: 'backtop',
        pageBuilder: _wrapInheritedTheme((context) => const TBackTopPage())),
    ExamplePageModel(
        text: 'NavBar 导航栏 (V1.0)',
        name: 'navbar',
        pageBuilder: _wrapInheritedTheme((context) => const TNavBarPage())),
    ExamplePageModel(
        text: 'Tabs 选项卡 (V1.0)',
        name: 'tabs',
        pageBuilder: _wrapInheritedTheme((context) => const TTabsPage())),
    ExamplePageModel(
        text: 'TabBar 标签栏 (V1.0)',
        name: 'tabBar',
        pageBuilder: _wrapInheritedTheme((context) => const TTabBarPage())),
    ExamplePageModel(
        text: 'Drawer 抽屉 (V1.0)',
        name: 'drawer',
        pageBuilder: _wrapInheritedTheme((context) => const TDrawerPage())),
    ExamplePageModel(
        text: 'Steps 步骤条 (V1.0)',
        name: 'steps',
        pageBuilder: _wrapInheritedTheme((context) => const TStepsPage())),
    ExamplePageModel(
        text: 'Indexes 索引 (V1.0)',
        name: 'indexes',
        pageBuilder: _wrapInheritedTheme((context) => const TIndexesPage())),
    ExamplePageModel(
        text: 'SideBar 侧边栏 (V1.0)',
        name: 'sidebar',
        pageBuilder: _wrapInheritedTheme((context) => const TSideBarPage())),
  ],
  '输入': [
    ExamplePageModel(
        text: 'Input 输入框 (V1.0)',
        name: 'input',
        pageBuilder: _wrapInheritedTheme((context) => const TInputViewPage())),
    ExamplePageModel(
        text: 'Textarea 多行输入 (V1.0)',
        name: 'textarea',
        pageBuilder: _wrapInheritedTheme((context) => const TTextareaPage())),
    ExamplePageModel(
        text: 'Switch 开关 (V1.0)',
        name: 'switch',
        pageBuilder: _wrapInheritedTheme((context) => const TSwitchPage())),
    ExamplePageModel(
        text: 'Checkbox 复选框 (V1.0)',
        name: 'checkbox',
        pageBuilder: _wrapInheritedTheme((context) => const TCheckboxPage())),
    ExamplePageModel(
        text: 'Radio 单选框 (V1.0)',
        name: 'radio',
        pageBuilder: _wrapInheritedTheme((context) => const TRadioPage())),
    ExamplePageModel(
        text: 'Slider 滑块 (V1.0)',
        name: 'slider',
        pageBuilder: _wrapInheritedTheme((context) => const TSliderPage())),
    ExamplePageModel(
        text: 'Search 搜索框 (V1.0)',
        name: 'search',
        pageBuilder: _wrapInheritedTheme((context) => const TSearchBarPage())),
    ExamplePageModel(
        text: 'Stepper 步进器 (V1.0)',
        name: 'stepper',
        pageBuilder: _wrapInheritedTheme((context) => const TStepperPage())),
    ExamplePageModel(
        text: 'Form 表单 (V1.0)',
        name: 'form',
        pageBuilder: _wrapInheritedTheme((context) => const TFormPage())),
    ExamplePageModel(
        text: 'Rate 评分 (V1.0)',
        name: 'rate',
        pageBuilder: _wrapInheritedTheme((context) => const TRatePage())),
    ExamplePageModel(
        text: 'Upload 上传 (V1.0)',
        name: 'upload',
        pageBuilder: _wrapInheritedTheme((context) => const TUploadPage())),
    ExamplePageModel(
        text: 'Picker 选择器 (V1.0)',
        name: 'picker',
        pageBuilder: _wrapInheritedTheme((context) => const TPickerPage())),
    ExamplePageModel(
        text: 'DateTimePicker 日期时间 (V1.0)',
        name: 'dateTimePicker',
        pageBuilder:
            _wrapInheritedTheme((context) => const TDateTimePickerPage())),
    ExamplePageModel(
        text: 'Calendar 日历 (V1.0)',
        name: 'calendar',
        pageBuilder: _wrapInheritedTheme((context) => const TCalendarPage())),
    ExamplePageModel(
        text: 'Cascader 级联选择 (V1.0)',
        name: 'cascader',
        pageBuilder: _wrapInheritedTheme((context) => const TCascaderPage())),
    ExamplePageModel(
        text: 'TreeSelect 树形选择 (V1.0)',
        name: 'treeSelect',
        pageBuilder: _wrapInheritedTheme((context) => const TTreeSelectPage())),
  ],
  '数据展示': [
    ExamplePageModel(
        text: 'Image 图片 (V1.0)',
        name: 'image',
        pageBuilder: _wrapInheritedTheme((context) => const TImagePage())),
    ExamplePageModel(
        text: 'Progress 进度条 (V1.0)',
        name: 'progress',
        pageBuilder: _wrapInheritedTheme((context) => const TProgressPage())),
    ExamplePageModel(
        text: 'Badge 徽标 (V1.0)',
        name: 'badge',
        pageBuilder: _wrapInheritedTheme((context) => const TBadgePage())),
    ExamplePageModel(
        text: 'Tag 标签 (V1.0)',
        name: 'tag',
        pageBuilder: _wrapInheritedTheme((context) => const TTagPage())),
    ExamplePageModel(
        text: 'Cell 单元格 (V1.0)',
        name: 'cell',
        pageBuilder: _wrapInheritedTheme((context) => const TCellPage())),
    ExamplePageModel(
        text: 'Collapse 折叠面板 (V1.0)',
        name: 'collapse',
        pageBuilder: _wrapInheritedTheme((context) => const TCollapsePage())),
    ExamplePageModel(
        text: 'Avatar 头像 (V1.0)',
        name: 'avatar',
        pageBuilder: _wrapInheritedTheme((context) => const TAvatarPage())),
    ExamplePageModel(
        text: 'Empty 空状态 (V1.0)',
        name: 'empty',
        pageBuilder: _wrapInheritedTheme((context) => const TEmptyPage())),
    ExamplePageModel(
        text: 'Result 结果 (V1.0)',
        name: 'result',
        pageBuilder: _wrapInheritedTheme((context) => const TResultPage())),
    ExamplePageModel(
        text: 'Footer 页脚 (V1.0)',
        name: 'footer',
        pageBuilder: _wrapInheritedTheme((context) => const TFooterPage())),
    ExamplePageModel(
        text: 'Skeleton 骨架屏 (V1.0)',
        name: 'skeleton',
        pageBuilder: _wrapInheritedTheme((context) => const TSkeletonPage())),
    ExamplePageModel(
        text: 'TimeCounter 计时 (V1.0)',
        name: 'timeCounter',
        pageBuilder:
            _wrapInheritedTheme((context) => const TTimeCounterPage())),
    ExamplePageModel(
        text: 'Swiper 轮播 (V1.0)',
        name: 'swiper',
        pageBuilder: _wrapInheritedTheme((context) => const TSwiperPage())),
    ExamplePageModel(
        text: 'ImageViewer 图片预览 (V1.0)',
        name: 'imageViewer',
        pageBuilder:
            _wrapInheritedTheme((context) => const TImageViewerPage())),
    ExamplePageModel(
        text: 'Table 表格 (V1.0)',
        name: 'table',
        pageBuilder: _wrapInheritedTheme((context) => const TTablePage())),
  ],
  '反馈': [
    ExamplePageModel(
        text: 'Loading 加载 (V1.0)',
        name: 'loading',
        pageBuilder: _wrapInheritedTheme((context) => const TLoadingPage())),
    ExamplePageModel(
        text: 'Refresh 下拉刷新 (V1.0)',
        name: 'refresh',
        pageBuilder:
            _wrapInheritedTheme((context) => const TPullDownRefreshPage())),
    ExamplePageModel(
        text: 'NoticeBar 公告栏 (V1.0)',
        name: 'noticeBar',
        pageBuilder: _wrapInheritedTheme((context) => const TNoticeBarPage())),
    ExamplePageModel(
        text: 'SwipeCell 滑动单元格 (V1.0)',
        name: 'swipeCell',
        pageBuilder: _wrapInheritedTheme((context) => const TSwipeCellPage())),
    ExamplePageModel(
        text: 'Dialog 弹窗 (V1.0)',
        name: 'dialog',
        pageBuilder: _wrapInheritedTheme((context) => const TDialogPage())),
    ExamplePageModel(
        text: 'Popup 弹出层 (V1.0)',
        name: 'popup',
        pageBuilder: _wrapInheritedTheme((context) => const TPopupPage())),
    ExamplePageModel(
        text: 'ActionSheet 动作面板 (V1.0)',
        name: 'actionSheet',
        pageBuilder:
            _wrapInheritedTheme((context) => const TActionSheetPage())),
    ExamplePageModel(
        text: 'Message 消息通知 (V1.0)',
        name: 'message',
        pageBuilder: _wrapInheritedTheme((context) => const TMessagePage())),
    ExamplePageModel(
        text: 'Toast 轻提示 (V1.0)',
        name: 'toast',
        pageBuilder: _wrapInheritedTheme((context) => const TToastPage())),
    ExamplePageModel(
        text: 'Popover 气泡弹出 (V1.0)',
        name: 'popover',
        pageBuilder: _wrapInheritedTheme((context) => const TPopoverPage())),
    ExamplePageModel(
        text: 'DropdownMenu 下拉菜单 (V1.0)',
        name: 'dropdownMenu',
        pageBuilder:
            _wrapInheritedTheme((context) => const TDropdownMenuPage())),
  ],
};

// 保持 examples 顺序与 Web 组件导航一致。
void sortExampleMap() {
  for (final pages in exampleMap.values) {
    pages.sort((a, b) => a.name.compareTo(b.name));
  }
}

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
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarUnSelectedColorPage()))
];
