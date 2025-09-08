import 'package:flutter/material.dart';

import 'base/example_base.dart';
import 'page/sidebar/td_sidebar_page.dart';
import 'page/sidebar/td_sidebar_page_anchor.dart';
import 'page/sidebar/td_sidebar_page_custom.dart';
import 'page/sidebar/td_sidebar_page_icon.dart';
import 'page/sidebar/td_sidebar_page_loading.dart';
import 'page/sidebar/td_sidebar_page_outline.dart';
import 'page/sidebar/td_sidebar_page_pagination.dart';
import 'page/sidebar/td_sidebar_page_unselected_color.dart';
import 'page/td_action_sheet_page.dart';
import 'page/td_avatar_page.dart';
import 'page/td_backtop_page.dart';
import 'page/td_badge_page.dart';
import 'page/td_bottom_tab_bar_page.dart';
import 'page/td_button_page.dart';
import 'page/td_calendar_page.dart';
import 'page/td_cascader_page.dart';
import 'page/td_cell_page.dart';
import 'page/td_checkbox_page.dart';
import 'page/td_collapse_page.dart';
import 'page/td_date_picker_page.dart';
import 'page/td_dialog_page.dart';
import 'page/td_divider_page.dart';
import 'page/td_drawer_page.dart';
import 'page/td_dropdown_menu_page.dart';
import 'page/td_empty_page.dart';
import 'page/td_fab_page.dart';
import 'page/td_font_page.dart';
import 'page/td_footer_page.dart';
import 'page/td_icon_page.dart';
import 'page/td_image_page.dart';
import 'page/td_image_viewer_page.dart';
import 'page/td_indexes_page.dart';
import 'page/td_input_page.dart';
import 'page/td_form_page.dart';
import 'page/td_link_page.dart';
import 'page/td_loading_page.dart';
import 'page/td_message_page.dart';
import 'page/td_navbar_page.dart';
import 'page/td_notice_bar_page.dart';
import 'page/td_picker_page.dart';
import 'page/td_popover_page.dart';
import 'page/td_popup_page.dart';
import 'page/td_progress_page.dart';
import 'page/td_radio_page.dart';
import 'page/td_radius_page.dart';
import 'page/td_rate_page.dart';
import 'page/td_refresh_page.dart';
import 'page/td_result_page.dart';
import 'page/td_search_bar_page.dart';
import 'page/td_shadows_page.dart';
import 'page/td_skeleton_page.dart';
import 'page/td_slider_page.dart';
import 'page/td_stepper_page.dart';
import 'page/td_steps_page.dart';
import 'page/td_swipe_cell_page.dart';
import 'page/td_steps_page.dart';
import 'page/td_swiper_page.dart';
import 'page/td_switch_page.dart';
import 'page/td_table_page.dart';
import 'page/td_tabs_page.dart';
import 'page/td_tag_page.dart';
import 'page/td_text_page.dart';
import 'page/td_textarea_page.dart';
import 'page/td_theme_page.dart';
import 'page/td_time_counter_page.dart';
import 'page/td_toast_page.dart';
import 'page/td_tree_select_page.dart';
import 'page/td_upload_page.dart';
import 'page/todo_page.dart';

PageBuilder _wrapInheritedTheme(WidgetBuilder builder) {
  return (context, model) {
    return ExamplePageInheritedTheme(model: model, child: builder(context));
  };
}

/// 新增的示例页面，在此增加模型即可,会自动注册增加按钮。示例页面编写参考TDTextPage()
List<ExamplePageModel> examplePageList = [];

Map<String, List<ExamplePageModel>> exampleMap = {
  '基础': [
    ExamplePageModel(
        text: 'Button 按钮', name: 'button', pageBuilder: _wrapInheritedTheme((context) => const TDButtonPage())),
    ExamplePageModel(
        text: 'Divider 分割线', name: 'divider', pageBuilder: _wrapInheritedTheme((context) => const TDDividerPage())),
    ExamplePageModel(
        text: 'Fab 悬浮按钮', name: 'fab',  pageBuilder: _wrapInheritedTheme((context) => const TDFabPage())),
    ExamplePageModel(text: 'Icon 图标', name: 'icon', pageBuilder: _wrapInheritedTheme((context) => const TDIconPage())),
    ExamplePageModel(
        text: 'Link 链接', name: 'link', pageBuilder: _wrapInheritedTheme((context) => const TDLinkViewPage())),
    ExamplePageModel(text: 'Text 文本', name: 'text', pageBuilder: _wrapInheritedTheme((context) => const TDTextPage())),
  ],
  '导航': [
    ExamplePageModel(
        text: 'BackTop 返回顶部',
        name: 'back-top',
        pageName: 'backtop',
        pageBuilder: _wrapInheritedTheme((context) => const TDBackTopPage())),
    ExamplePageModel(
        text: 'Drawer 抽屉',
        name: 'drawer',
        pageBuilder: _wrapInheritedTheme((context) => const TDDrawerPage())),
    ExamplePageModel(
        text: 'Indexes 索引',
        name: 'indexes',
        pageBuilder: _wrapInheritedTheme((context) => const TDIndexesPage())),
    ExamplePageModel(
        text: 'NavBar 导航栏', name: 'navbar', pageBuilder: _wrapInheritedTheme((context) => const TDNavBarPage())),
    ExamplePageModel(
        text: 'SideBar 侧边栏', name: 'side-bar',pageBuilder: _wrapInheritedTheme((context) => const TDSideBarPage())),
    ExamplePageModel(text: 'Steps 步骤条', name: 'steps', pageBuilder: _wrapInheritedTheme((context) => const TDStepsPage())),
    ExamplePageModel(
        text: 'TabBar 标签栏', name: 'tab-bar',
        pageName: 'bottom_tab_bar',pageBuilder: _wrapInheritedTheme((context) => const TDBottomTabBarPage())),
    ExamplePageModel(text: 'Tabs 选项卡', name: 'tabs', pageBuilder: _wrapInheritedTheme((context) => const TDTabsPage())),
  ],
  '输入': [
    ExamplePageModel(
        text: 'Calendar 日历',
        name: 'calendar',
        pageBuilder: _wrapInheritedTheme((context) => const TDCalendarPage())),
    ExamplePageModel(
        text: 'Cascader 级联选择器',
        name: 'cascader',
        pageBuilder: _wrapInheritedTheme((context) => const TDCascaderPage())),
    ExamplePageModel(
        text: 'Checkbox 多选框', name: 'checkbox', pageBuilder: _wrapInheritedTheme((context) => const TDCheckboxPage())),
    ExamplePageModel(
        text: 'DateTimePicker 时间选择器',
        name: 'date-time-picker',
        pageName: 'data_picker',
        pageBuilder: _wrapInheritedTheme((context) => const TDDatePickerPage())),
    ExamplePageModel(
        text: 'Form 表单', name: 'form', pageBuilder: _wrapInheritedTheme((context) => const TDFormPage())),
    ExamplePageModel(
        text: 'Input 输入框', name: 'input', pageBuilder: _wrapInheritedTheme((context) => const TDInputViewPage())),
    ExamplePageModel(
        text: 'Picker 选择器', name: 'picker', pageBuilder: _wrapInheritedTheme((context) => const TDPickerPage())),
    ExamplePageModel(
        text: 'Radio 单选框', name: 'radio', pageBuilder: _wrapInheritedTheme((context) => const TDRadioPage())),
    ExamplePageModel(
        text: 'Rate 评分', name: 'rate', pageBuilder: _wrapInheritedTheme((context) => const TDRatePage())),
    ExamplePageModel(
        text: 'Search 搜索框', name: 'search', pageBuilder: _wrapInheritedTheme((context) => const TDSearchBarPage())),
    ExamplePageModel(
        text: 'Slider 滑动选择器', name: 'slider', pageBuilder: _wrapInheritedTheme((context) => const TDSliderPage())),
    ExamplePageModel(
        text: 'Stepper 步进器', name: 'stepper', pageBuilder: _wrapInheritedTheme((context) => const TDStepperPage())),
    ExamplePageModel(
        text: 'Switch 开关', name: 'switch', pageBuilder: _wrapInheritedTheme((context) => const TDSwitchPage())),
    ExamplePageModel(
        text: 'Textarea 多行文本框',
        name: 'textarea',
        pageBuilder: _wrapInheritedTheme((context) => const TDTextareaPage())),
    ExamplePageModel(
        text: 'TreeSelect 树形选择器',
        name: 'tree-select',
        pageName: 'tree_select',
        pageBuilder: _wrapInheritedTheme((context) => const TDTreeSelectPage())),
    ExamplePageModel(
        text: 'Upload 上传',
        name: 'upload',
        pageBuilder: _wrapInheritedTheme((context) => const TDUploadPage())),
  ],
  '数据展示': [
    ExamplePageModel(
        text: 'Avatar 头像', name: 'avatar', pageBuilder: _wrapInheritedTheme((context) => const TDAvatarPage())),
    ExamplePageModel(
        text: 'Badge 徽标', name: 'badge', pageBuilder: _wrapInheritedTheme((context) => const TDBadgePage())),
    ExamplePageModel(
        text: 'Cell 单元格', name: 'cell', pageBuilder: _wrapInheritedTheme((context) => const TDCellPage())),
    ExamplePageModel(
        text: 'TimeCounter 计时器',
        name: 'time-counter',
        pageBuilder: _wrapInheritedTheme((context) => const TDTimeCounterPage())),
    ExamplePageModel(
        text: 'Collapse 折叠面板',
        name: 'collapse',
        pageBuilder: _wrapInheritedTheme((context) => const TDCollapsePage())),
    ExamplePageModel(
        text: 'Empty 空状态', name: 'empty', pageBuilder: _wrapInheritedTheme((context) => const TDEmptyPage())),
    ExamplePageModel(
        text: 'Footer 页脚', name: 'footer', pageBuilder: _wrapInheritedTheme((context) => const TDFooterPage())),
    ExamplePageModel(
        text: 'Grid 宫格', name: 'grid', isTodo: true, pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Image 图片', name: 'image', pageBuilder: _wrapInheritedTheme((context) => const TDImagePage())),
    ExamplePageModel(
        text: 'ImageViewer 图片预览',
        name: 'image-viewer',
        pageName: 'image_viewer',
        pageBuilder: _wrapInheritedTheme((context) => const TDImageViewerPage())),
    ExamplePageModel(
        text: 'Progress 进度条',
        name: 'progress',
        pageBuilder: _wrapInheritedTheme((context) => const TDProgressPage())),
    ExamplePageModel(
        text: 'Result 结果',
        name: 'result',
        pageBuilder: _wrapInheritedTheme((context) => const TDResultPage())),
    ExamplePageModel(
        text: 'Skeleton 骨架屏',
        name: 'skeleton',
        pageBuilder: _wrapInheritedTheme((context) => const TDSkeletonPage())),
    ExamplePageModel(
        text: 'Sticky 吸顶',
        name: 'sticky',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(
        text: 'Swiper 轮播图', name: 'swiper', pageBuilder: _wrapInheritedTheme((context) => const TDSwiperPage())),
    ExamplePageModel(text: 'Table 表格', name: 'table', pageBuilder: _wrapInheritedTheme((context) => const TDTablePage())),
    ExamplePageModel(text: 'Tag 标签', name: 'tag', pageBuilder: _wrapInheritedTheme((context) => const TDTagPage())),
  ],
  '反馈': [
    ExamplePageModel( 
        text: 'ActionSheet 动作面板',
        name: 'action-sheet',
        pageName: 'action_sheet',
        pageBuilder: _wrapInheritedTheme((context) => const TDActionSheetPage())),
    ExamplePageModel(
        text: 'Dialog 对话框', name: 'dialog', pageBuilder: _wrapInheritedTheme((context) => const TDDialogPage())),
    ExamplePageModel(
        text: 'DropdownMenu 下拉菜单',
        name: 'dropdown-menu',
        pageName: 'dropdown_menu',
        pageBuilder: _wrapInheritedTheme((context) => const TDDropdownMenuPage())),
    ExamplePageModel(
        text: 'Loading 加载', name: 'loading', pageBuilder: _wrapInheritedTheme((context) => const TDLoadingPage())),
    ExamplePageModel(
        text: 'Message 全局提示',
        name: 'message',
        pageBuilder: _wrapInheritedTheme((context) => const TDMessagePage())),
    ExamplePageModel(
        text: 'NoticeBar 消息提醒', name: 'notice-bar', pageBuilder: _wrapInheritedTheme((context) => const TDNoticeBarPage())),
    ExamplePageModel(
        text: 'Overlay 遮罩层',
        name: 'overlay',
        isTodo: true,
        pageBuilder: _wrapInheritedTheme((context) => const TodoPage())),
    ExamplePageModel(text: 'Popover 弹出气泡', name: 'popover', pageBuilder: _wrapInheritedTheme((context) => const TDPopoverPage())),
    ExamplePageModel(
        text: 'Popup 弹出层', name: 'popup', pageBuilder: _wrapInheritedTheme((context) => const TDPopupPage())),
    ExamplePageModel(
        text: 'PullDownRefresh 下拉刷新',
        name: 'pull-down-refresh',
        pageName: 'refresh',
        pageBuilder: _wrapInheritedTheme((context) => const TdPullDownRefreshPage())),
    ExamplePageModel(
        text: 'Swipecell 滑动操作',
        name: 'swipe-cell',
        pageName: 'swipe_cell',
        pageBuilder: _wrapInheritedTheme((context) => const TDSwipeCellPage())),
    ExamplePageModel(
        text: 'Toast 轻提示', name: 'toast', pageBuilder: _wrapInheritedTheme((context) => const TDToastPage())),
  ],
  '主题': [
    ExamplePageModel(
        text: '颜色', name: 'theme_colors', pageBuilder: _wrapInheritedTheme((context) => const TDThemeColorsPage())),
    ExamplePageModel(text: '字体', name: 'font', pageBuilder: _wrapInheritedTheme((context) => const TDFontPage())),
    ExamplePageModel(text: '圆角', name: 'radius', pageBuilder: _wrapInheritedTheme((context) => const TDRadiusPage())),
    ExamplePageModel(text: '阴影', name: 'shadows', pageBuilder: _wrapInheritedTheme((context) => const TDShadowsPage())),
  ],
};

List<ExamplePageModel> sideBarExamplePage = [
  ExamplePageModel(
      text: 'SideBar 切页',
      name: 'SideBarPagination',
      isTodo: false,
      showAction: false,
      pageBuilder: _wrapInheritedTheme((context) => const TDSideBarPaginationPage())),
  ExamplePageModel(
      text: 'SideBar 锚点',
      name: 'SideBarAnchor',
      isTodo: false,
      pageBuilder: _wrapInheritedTheme((context) => const TDSideBarAnchorPage())),
  ExamplePageModel(
      text: 'SideBar 带图标',
      name: 'SideBarIcon',
      isTodo: false,
      pageBuilder: _wrapInheritedTheme((context) => const TDSideBarIconPage())),
  ExamplePageModel(
      text: 'SideBar 非通栏选项样式',
      name: 'SideBarOutline',
      isTodo: false,
      pageBuilder: _wrapInheritedTheme((context) => const TDSideBarOutlinePage())),
  ExamplePageModel(
      text: 'SideBar 自定义样式',
      name: 'SideBarCustom',
      isTodo: false,
      pageBuilder: _wrapInheritedTheme((context) => const TDSideBarCustomPage())),
  ExamplePageModel(
      text: 'SideBar 延迟加载',
      name: 'SideBarLoading',
      isTodo: false,
      pageBuilder: _wrapInheritedTheme((context) => const TDSideBarLoadingPage())),
  ExamplePageModel(
      text: 'SideBar 自定义未选中颜色',
      name: 'SideBarUnselectedColor',
      isTodo: false,
      pageBuilder: _wrapInheritedTheme((context) => const TDSideBarUnSelectedColorPage()))
];
