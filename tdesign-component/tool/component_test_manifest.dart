class ComponentTestManifest {
  const ComponentTestManifest({
    required this.name,
    required this.coverageTargets,
    required this.componentTests,
    this.exampleTests = const [],
    required this.visualTests,
  });

  final String name;
  final List<String> coverageTargets;
  final List<String> componentTests;
  final List<String> exampleTests;
  final List<VisualTestManifest> visualTests;
}

class VisualTestManifest {
  const VisualTestManifest({
    required this.name,
    required this.workingDirectory,
    required this.testFiles,
    this.arguments = const [],
  });

  final String name;
  final String workingDirectory;
  final List<String> testFiles;
  final List<String> arguments;
}

const sharedExampleTests = ['test/widget_test.dart'];

const componentTestManifests = <ComponentTestManifest>[
  ComponentTestManifest(
    name: 'action_sheet',
    coverageTargets: ['lib/src/components/action_sheet/'],
    componentTests: [
      'test/components/action_sheet/t_action_sheet_grid_test.dart',
      'test/components/action_sheet/t_action_sheet_item_widget_test.dart',
      'test/components/action_sheet/t_action_sheet_list_test.dart',
      'test/components/action_sheet/t_action_sheet_test.dart',
    ],
    exampleTests: ['test/action_sheet_page_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'ActionSheet Demo',
        workingDirectory: 'example',
        testFiles: ['test/action_sheet_page_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'badge',
    coverageTargets: ['lib/src/components/badge/'],
    componentTests: ['test/components/badge/t_badge_test.dart'],
    exampleTests: ['test/badge_page_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Badge Component',
        workingDirectory: '.',
        testFiles: ['test/components/badge/t_badge_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'backtop',
    coverageTargets: ['lib/src/components/backtop/'],
    componentTests: [
      'test/components/backtop/t_backtop_test.dart',
      'test/components/backtop/t_backtop_theme_test.dart',
      'test/components/backtop/t_backtop_widget_test.dart',
    ],
    exampleTests: ['test/backtop_demo_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'BackTop Component',
        workingDirectory: '.',
        testFiles: [
          'test/components/backtop/t_backtop_golden_test.dart',
          'test/components/navigation_components_golden_test.dart',
        ],
      ),
      VisualTestManifest(
        name: 'BackTop Demo',
        workingDirectory: 'example',
        testFiles: ['test/backtop_demo_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'button',
    coverageTargets: ['lib/src/components/button/'],
    componentTests: [
      'test/components/button/t_button_test.dart',
      'test/components/button/t_button_theme_priority_test.dart',
      'test/components/button/t_button_theme_test.dart',
      'test/components/button/t_button_widget_test.dart',
    ],
    visualTests: [
      VisualTestManifest(
        name: 'Button Demo',
        workingDirectory: 'example',
        testFiles: ['test/button_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'picker',
    coverageTargets: ['lib/src/components/picker/'],
    componentTests: [
      'test/components/picker/picker_consumers_theme_test.dart',
      'test/components/picker/t_picker_theme_test.dart',
      'test/components/picker/t_picker_types_test.dart',
      'test/components/picker/t_picker_widget_test.dart',
      'test/components/picker/wheel_column_test.dart',
      'test/components/date_time_picker/t_date_time_picker_wheel_test.dart',
    ],
    exampleTests: ['test/picker_demo_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Picker Demo',
        workingDirectory: 'example',
        testFiles: ['test/picker_demo_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'date_time_picker',
    coverageTargets: ['lib/src/components/date_time_picker/'],
    componentTests: [
      'test/components/picker/picker_consumers_theme_test.dart',
      'test/components/date_time_picker/t_date_time_picker_test.dart',
      'test/components/date_time_picker/t_date_time_picker_wheel_test.dart',
      'test/t_date_time_picker_test.dart',
    ],
    exampleTests: ['test/date_time_picker_demo_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'DateTimePicker Demo',
        workingDirectory: 'example',
        testFiles: ['test/date_time_picker_demo_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'calendar',
    coverageTargets: ['lib/src/components/calendar/'],
    componentTests: [
      'test/components/calendar/t_calendar_body_test.dart',
      'test/components/calendar/t_calendar_cell_test.dart',
      'test/components/calendar/t_calendar_theme_test.dart',
      'test/components/calendar/t_calendar_widget_test.dart',
      'test/t_calendar_lunar_test.dart',
      'test/t_calendar_on_change_init_test.dart',
      'test/t_calendar_test.dart',
    ],
    exampleTests: ['test/calendar_demo_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Calendar States',
        workingDirectory: '.',
        testFiles: ['test/components/calendar/t_calendar_golden_test.dart'],
      ),
      VisualTestManifest(
        name: 'Calendar Demo',
        workingDirectory: 'example',
        testFiles: ['test/calendar_demo_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'tag',
    coverageTargets: ['lib/src/components/tag/'],
    componentTests: [
      'test/components/tag/t_select_tag_test.dart',
      'test/components/tag/t_tag_test.dart',
    ],
    exampleTests: ['test/tag_page_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Tag Demo',
        workingDirectory: 'example',
        testFiles: ['test/tag_page_test.dart'],
        arguments: ['--exclude-tags', 'demo'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'popover',
    coverageTargets: ['lib/src/components/popover/'],
    componentTests: ['test/components/popover/t_popover_test.dart'],
    exampleTests: [
      'test/popover_demo_test.dart',
      'test/popover_page_test.dart',
    ],
    visualTests: [
      VisualTestManifest(
        name: 'Popover Demo',
        workingDirectory: 'example',
        testFiles: ['test/popover_demo_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'checkbox',
    coverageTargets: ['lib/src/components/checkbox/'],
    componentTests: [
      'test/components/checkbox/t_check_box_group_test.dart',
      'test/components/checkbox/t_checkbox_test.dart',
    ],
    visualTests: [
      VisualTestManifest(
        name: 'Checkbox Demo',
        workingDirectory: 'example',
        testFiles: ['test/checkbox_page_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'divider',
    coverageTargets: ['lib/src/components/divider/'],
    componentTests: ['test/components/divider/t_divider_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Divider Demo',
        workingDirectory: 'example',
        testFiles: ['test/divider_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'dialog',
    coverageTargets: ['lib/src/components/dialog/'],
    componentTests: ['test/components/dialog/t_dialog_test.dart'],
    exampleTests: ['test/dialog_page_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Dialog Demo',
        workingDirectory: 'example',
        testFiles: ['test/dialog_page_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'dropdown_menu',
    coverageTargets: ['lib/src/components/dropdown_menu/'],
    componentTests: [
      'test/components/dropdown_menu/t_dropdown_item_test.dart',
      'test/components/dropdown_menu/t_dropdown_menu_test.dart',
    ],
    exampleTests: ['test/dropdown_menu_page_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'DropdownMenu Demo',
        workingDirectory: 'example',
        testFiles: ['test/dropdown_menu_page_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'fab',
    coverageTargets: ['lib/src/components/fab/'],
    componentTests: [
      'test/components/fab/t_fab_layout_test.dart',
      'test/components/fab/t_fab_test.dart',
    ],
    visualTests: [
      VisualTestManifest(
        name: 'Fab Demo',
        workingDirectory: 'example',
        testFiles: ['test/fab_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'refresh',
    coverageTargets: [
      'lib/src/components/refresh/t_pull_down_refresh.dart',
      'lib/src/components/refresh/t_pull_down_refresh_controller.dart',
      'lib/src/components/refresh/t_pull_down_refresh_texts.dart',
    ],
    componentTests: ['test/components/refresh/t_refresh_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'PullDownRefresh Demo',
        workingDirectory: 'example',
        testFiles: ['test/pull_down_refresh_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'rate',
    coverageTargets: ['lib/src/components/rate/'],
    componentTests: ['test/components/rate/t_rate_test.dart'],
    exampleTests: ['test/rate_demo_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Rate Demo',
        workingDirectory: 'example',
        testFiles: ['test/rate_demo_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'tabs',
    coverageTargets: [
      'lib/src/components/tabs/t_horizontal_tab_bar.dart',
      'lib/src/components/tabs/t_tab.dart',
      'lib/src/components/tabs/t_tab_bar.dart',
      'lib/src/components/tabs/t_tab_bar_theme_data.dart',
      'lib/src/components/tabs/t_tab_bar_view.dart',
    ],
    componentTests: [
      'test/components/tabs/t_horizontal_tab_bar_test.dart',
      'test/components/tabs/t_tab_bar_test.dart',
      'test/components/tabs/t_tab_test.dart',
    ],
    exampleTests: ['test/tabs_page_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Tabs Component',
        workingDirectory: '.',
        testFiles: [
          'test/components/tabs/t_tab_golden_test.dart',
          'test/components/navigation_components_golden_test.dart',
        ],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'icon',
    coverageTargets: ['lib/src/components/icon/'],
    componentTests: ['test/components/icon/t_icon_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Icon Demo',
        workingDirectory: 'example',
        testFiles: ['test/icon_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'link',
    coverageTargets: ['lib/src/components/link/'],
    componentTests: [
      'test/components/link/t_link_resolve_test.dart',
      'test/components/link/t_link_test.dart',
      'test/components/link/t_link_theme_test.dart',
      'test/components/link/t_link_widget_test.dart',
    ],
    visualTests: [
      VisualTestManifest(
        name: 'Link Demo',
        workingDirectory: 'example',
        testFiles: ['test/link_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'loading',
    coverageTargets: ['lib/src/components/loading/'],
    componentTests: ['test/components/loading/t_loading_test.dart'],
    exampleTests: ['test/loading_demo_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Loading Demo',
        workingDirectory: 'example',
        testFiles: ['test/loading_demo_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'message',
    coverageTargets: ['lib/src/components/message/'],
    componentTests: ['test/components/message/t_message_test.dart'],
    exampleTests: ['test/message_demo_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Message Demo',
        workingDirectory: 'example',
        testFiles: ['test/message_demo_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'notice_bar',
    coverageTargets: ['lib/src/components/notice_bar/'],
    componentTests: ['test/components/notice_bar/t_notice_bar_test.dart'],
    exampleTests: ['test/notice_bar_page_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'NoticeBar Demo',
        workingDirectory: 'example',
        testFiles: ['test/notice_bar_page_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'popup',
    coverageTargets: ['lib/src/components/popup/'],
    componentTests: [
      'test/components/popup/t_feedback_theme_data_test.dart',
      'test/components/popup/t_popup_options_contract_test.dart',
      'test/components/popup/t_popup_theme_test.dart',
      'test/components/popup/t_popup_widget_test.dart',
      'test/t_popup_coverage_test.dart',
      'test/t_popup_layout_test.dart',
      'test/t_popup_options_test.dart',
      'test/t_popup_route_test.dart',
      'test/t_popup_test.dart',
    ],
    exampleTests: ['test/popup_demo_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Popup Demo',
        workingDirectory: 'example',
        testFiles: ['test/popup_demo_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'radio',
    coverageTargets: ['lib/src/components/radio/'],
    componentTests: [
      'test/components/radio/t_radio_test.dart',
      'test/components/radio/t_radio_theme_contract_test.dart',
    ],
    exampleTests: ['test/radio_page_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Radio Demo',
        workingDirectory: 'example',
        testFiles: ['test/radio_page_golden_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'text',
    coverageTargets: ['lib/src/components/text/'],
    componentTests: [
      'test/components/text/t_font_loader_test.dart',
      'test/components/text/t_text_resolve_test.dart',
      'test/components/text/t_text_test.dart',
    ],
    visualTests: [
      VisualTestManifest(
        name: 'Text Demo',
        workingDirectory: 'example',
        testFiles: ['test/text_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'search',
    coverageTargets: ['lib/src/components/search/'],
    componentTests: ['test/components/search/t_search_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Search Demo',
        workingDirectory: 'example',
        testFiles: ['test/search_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'switch',
    coverageTargets: ['lib/src/components/switch/'],
    componentTests: [
      'test/components/switch/t_switch_test.dart',
      'test/components/switch/t_cupertino_switch_test.dart',
    ],
    visualTests: [
      VisualTestManifest(
        name: 'Switch Demo',
        workingDirectory: 'example',
        testFiles: ['test/switch_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'upload',
    coverageTargets: ['lib/src/components/upload/'],
    componentTests: ['test/components/upload/t_upload_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Upload Demo',
        workingDirectory: 'example',
        testFiles: ['test/upload_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'form',
    coverageTargets: ['lib/src/components/form/'],
    componentTests: ['test/components/form/t_form_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Form Demo',
        workingDirectory: 'example',
        testFiles: ['test/form_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'input',
    coverageTargets: ['lib/src/components/input/'],
    componentTests: [
      'test/components/input/t_input_test.dart',
      'test/components/input/t_input_theme_test.dart',
    ],
    visualTests: [
      VisualTestManifest(
        name: 'Input Demo',
        workingDirectory: 'example',
        testFiles: ['test/input_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'textarea',
    coverageTargets: ['lib/src/components/textarea/'],
    componentTests: ['test/components/textarea/t_textarea_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Textarea Demo',
        workingDirectory: 'example',
        testFiles: ['test/textarea_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'toast',
    coverageTargets: ['lib/src/components/toast/'],
    componentTests: ['test/components/toast/t_toast_test.dart'],
    visualTests: [
      VisualTestManifest(
        name: 'Toast Demo',
        workingDirectory: 'example',
        testFiles: ['test/toast_demo_test.dart'],
      ),
    ],
  ),
  ComponentTestManifest(
    name: 'swipe_cell',
    coverageTargets: ['lib/src/components/swipe_cell/'],
    componentTests: [
      'test/components/swipe_cell/t_swipe_cell_auto_extent_test.dart',
      'test/components/swipe_cell/t_swipe_cell_inherited_test.dart',
      'test/components/swipe_cell/t_swipe_cell_test.dart',
    ],
    visualTests: [
      VisualTestManifest(
        name: 'SwipeCell Demo',
        workingDirectory: 'example',
        testFiles: ['test/swipe_cell_demo_test.dart'],
      ),
    ],
  ),
];
