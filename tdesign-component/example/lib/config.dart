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
import 'page/t_pull_down_refresh_page.dart';
import 'page/t_radio_page.dart';
import 'page/t_rate_page.dart';
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
        text: 'Link 链接',
        name: 'link',
        pageBuilder: _wrapInheritedTheme((context) => const TLinkViewPage())),
    ExamplePageModel(
        text: 'Text 文本',
        name: 'text',
        pageBuilder: _wrapInheritedTheme((context) => const TTextPage())),
    ExamplePageModel(
        text: 'Icon 图标',
        name: 'icon',
        pageBuilder: _wrapInheritedTheme((context) => const TIconPage())),
  ],
  '导航': [
    ExamplePageModel(
        text: 'BackTop 返回顶部',
        name: 'backtop',
        pageBuilder: _wrapInheritedTheme((context) => const TBackTopPage())),
    ExamplePageModel(
        text: 'Drawer 抽屉',
        name: 'drawer',
        pageBuilder: _wrapInheritedTheme((context) => const TDrawerPage())),
    ExamplePageModel(
        text: 'Indexes 索引',
        name: 'indexes',
        pageBuilder: _wrapInheritedTheme((context) => const TIndexesPage())),
    ExamplePageModel(
        text: 'NavBar 导航栏',
        name: 'navbar',
        pageBuilder: _wrapInheritedTheme((context) => const TNavBarPage())),
    ExamplePageModel(
        text: 'SideBar 侧边栏',
        name: 'sidebar',
        pageBuilder: _wrapInheritedTheme((context) => const TSideBarPage())),
    ExamplePageModel(
        text: 'Steps 步骤条',
        name: 'steps',
        pageBuilder: _wrapInheritedTheme((context) => const TStepsPage())),
    ExamplePageModel(
        text: 'TabBar 标签栏',
        name: 'tabBar',
        pageBuilder: _wrapInheritedTheme((context) => const TTabBarPage())),
    ExamplePageModel(
        text: 'Tabs 选项卡',
        name: 'tabs',
        pageBuilder: _wrapInheritedTheme((context) => const TTabsPage())),
  ],
  '输入': [
    ExamplePageModel(
        text: 'Calendar 日历',
        name: 'calendar',
        pageBuilder: _wrapInheritedTheme((context) => const TCalendarPage())),
    ExamplePageModel(
        text: 'Cascader 级联选择',
        name: 'cascader',
        pageBuilder: _wrapInheritedTheme((context) => const TCascaderPage())),
    ExamplePageModel(
        text: 'Checkbox 复选框',
        name: 'checkbox',
        pageBuilder: _wrapInheritedTheme((context) => const TCheckboxPage())),
    ExamplePageModel(
        text: 'DateTimePicker 日期时间',
        name: 'dateTimePicker',
        pageBuilder:
            _wrapInheritedTheme((context) => const TDateTimePickerPage())),
    ExamplePageModel(
        text: 'Form 表单',
        name: 'form',
        pageBuilder: _wrapInheritedTheme((context) => const TFormPage())),
    ExamplePageModel(
        text: 'Input 输入框',
        name: 'input',
        pageBuilder: _wrapInheritedTheme((context) => const TInputViewPage())),
    ExamplePageModel(
        text: 'Picker 选择器',
        name: 'picker',
        pageBuilder: _wrapInheritedTheme((context) => const TPickerPage())),
    ExamplePageModel(
        text: 'Radio 单选框',
        name: 'radio',
        pageBuilder: _wrapInheritedTheme((context) => const TRadioPage())),
    ExamplePageModel(
        text: 'Rate 评分',
        name: 'rate',
        pageBuilder: _wrapInheritedTheme((context) => const TRatePage())),
    ExamplePageModel(
        text: 'Search 搜索框',
        name: 'search',
        pageBuilder: _wrapInheritedTheme((context) => const TSearchBarPage())),
    ExamplePageModel(
        text: 'Slider 滑块',
        name: 'slider',
        pageBuilder: _wrapInheritedTheme((context) => const TSliderPage())),
    ExamplePageModel(
        text: 'Stepper 步进器',
        name: 'stepper',
        pageBuilder: _wrapInheritedTheme((context) => const TStepperPage())),
    ExamplePageModel(
        text: 'Switch 开关',
        name: 'switch',
        pageBuilder: _wrapInheritedTheme((context) => const TSwitchPage())),
    ExamplePageModel(
        text: 'Textarea 多行输入',
        name: 'textarea',
        pageBuilder: _wrapInheritedTheme((context) => const TTextareaPage())),
    ExamplePageModel(
        text: 'TreeSelect 树形选择',
        name: 'treeSelect',
        pageBuilder: _wrapInheritedTheme((context) => const TTreeSelectPage())),
    ExamplePageModel(
        text: 'Upload 上传',
        name: 'upload',
        pageBuilder: _wrapInheritedTheme((context) => const TUploadPage())),
  ],
  '数据展示': [
    ExamplePageModel(
        text: 'Avatar 头像',
        name: 'avatar',
        pageBuilder: _wrapInheritedTheme((context) => const TAvatarPage())),
    ExamplePageModel(
        text: 'Badge 徽标',
        name: 'badge',
        pageBuilder: _wrapInheritedTheme((context) => const TBadgePage())),
    ExamplePageModel(
        text: 'Cell 单元格',
        name: 'cell',
        pageBuilder: _wrapInheritedTheme((context) => const TCellPage())),
    ExamplePageModel(
        text: 'Collapse 折叠面板',
        name: 'collapse',
        pageBuilder: _wrapInheritedTheme((context) => const TCollapsePage())),
    ExamplePageModel(
        text: 'Empty 空状态',
        name: 'empty',
        pageBuilder: _wrapInheritedTheme((context) => const TEmptyPage())),
    ExamplePageModel(
        text: 'Footer 页脚',
        name: 'footer',
        pageBuilder: _wrapInheritedTheme((context) => const TFooterPage())),
    ExamplePageModel(
        text: 'Image 图片',
        name: 'image',
        pageBuilder: _wrapInheritedTheme((context) => const TImagePage())),
    ExamplePageModel(
        text: 'ImageViewer 图片预览',
        name: 'imageViewer',
        pageBuilder:
            _wrapInheritedTheme((context) => const TImageViewerPage())),
    ExamplePageModel(
        text: 'Progress 进度条',
        name: 'progress',
        pageBuilder: _wrapInheritedTheme((context) => const TProgressPage())),
    ExamplePageModel(
        text: 'Result 结果',
        name: 'result',
        pageBuilder: _wrapInheritedTheme((context) => const TResultPage())),
    ExamplePageModel(
        text: 'Skeleton 骨架屏',
        name: 'skeleton',
        pageBuilder: _wrapInheritedTheme((context) => const TSkeletonPage())),
    ExamplePageModel(
        text: 'Swiper 轮播',
        name: 'swiper',
        pageBuilder: _wrapInheritedTheme((context) => const TSwiperPage())),
    ExamplePageModel(
        text: 'Table 表格',
        name: 'table',
        pageBuilder: _wrapInheritedTheme((context) => const TTablePage())),
    ExamplePageModel(
        text: 'Tag 标签',
        name: 'tag',
        pageBuilder: _wrapInheritedTheme((context) => const TTagPage())),
    ExamplePageModel(
        text: 'TimeCounter 计时',
        name: 'timeCounter',
        pageBuilder:
            _wrapInheritedTheme((context) => const TTimeCounterPage())),
  ],
  '反馈': [
    ExamplePageModel(
        text: 'ActionSheet 动作面板',
        name: 'actionSheet',
        pageBuilder:
            _wrapInheritedTheme((context) => const TActionSheetPage())),
    ExamplePageModel(
        text: 'Dialog 弹窗',
        name: 'dialog',
        pageBuilder: _wrapInheritedTheme((context) => const TDialogPage())),
    ExamplePageModel(
        text: 'DropdownMenu 下拉菜单',
        name: 'dropdownMenu',
        pageBuilder:
            _wrapInheritedTheme((context) => const TDropdownMenuPage())),
    ExamplePageModel(
        text: 'Loading 加载',
        name: 'loading',
        pageBuilder: _wrapInheritedTheme((context) => const TLoadingPage())),
    ExamplePageModel(
        text: 'Message 消息通知',
        name: 'message',
        pageBuilder: _wrapInheritedTheme((context) => const TMessagePage())),
    ExamplePageModel(
        text: 'NoticeBar 公告栏',
        name: 'noticeBar',
        pageBuilder:
            _wrapInheritedTheme((context) => const TNoticeBarPage())),
    ExamplePageModel(
        text: 'Popover 气泡弹出',
        name: 'popover',
        pageBuilder: _wrapInheritedTheme((context) => const TPopoverPage())),
    ExamplePageModel(
        text: 'Popup 弹出层',
        name: 'popup',
        pageBuilder: _wrapInheritedTheme((context) => const TPopupPage())),
    ExamplePageModel(
        text: 'PullDownRefresh 下拉刷新',
        name: 'pullDownRefresh',
        pageBuilder:
            _wrapInheritedTheme((context) => const TPullDownRefreshPage())),
    ExamplePageModel(
        text: 'SwipeCell 滑动操作',
        name: 'swipeCell',
        pageBuilder: _wrapInheritedTheme((context) => const TSwipeCellPage())),
    ExamplePageModel(
        text: 'Toast 轻提示',
        name: 'toast',
        pageBuilder: _wrapInheritedTheme((context) => const TToastPage())),
  ],
};

List<ExamplePageModel> sideBarExamplePage = [
  ExamplePageModel(
      text: 'SideBar 切页',
      name: 'SideBarPagination',
      showAction: false,
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarPaginationPage())),
  ExamplePageModel(
      text: 'SideBar 锚点',
      name: 'SideBarAnchor',
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarAnchorPage())),
  ExamplePageModel(
      text: 'SideBar 带图标',
      name: 'SideBarIcon',
      pageBuilder: _wrapInheritedTheme((context) => const TSideBarIconPage())),
  ExamplePageModel(
      text: 'SideBar 非通栏选项样式',
      name: 'SideBarOutline',
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarOutlinePage())),
  ExamplePageModel(
      text: 'SideBar 自定义样式',
      name: 'SideBarCustom',
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarCustomPage())),
  ExamplePageModel(
      text: 'SideBar 延迟加载',
      name: 'SideBarLoading',
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarLoadingPage())),
  ExamplePageModel(
      text: 'SideBar 自定义未选中颜色',
      name: 'SideBarUnselectedColor',
      pageBuilder:
          _wrapInheritedTheme((context) => const TSideBarUnSelectedColorPage()))
];
