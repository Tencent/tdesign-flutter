#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# 基础
# button
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/button" --name TDButton,TDButtonStyle --folder-name button --output "$PARENT_DIR/example/assets/api/" --only-api
# divider
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/divider/td_divider.dart" --name TDDivider --folder-name divider --output "$PARENT_DIR/example/assets/api/" --only-api
# fab
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/fab/td_fab.dart" --name TDFab --folder-name fab --output "$PARENT_DIR/example/assets/api/" --only-api
# icon
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/icon/td_icons.dart" --name TDIcons --folder-name icon --output "$PARENT_DIR/example/assets/api/" --only-api
# link
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/link/td_link.dart" --name TDLink --folder-name link --output "$PARENT_DIR/example/assets/api/" --only-api
# text
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/text/td_text.dart" --name TDText,TDTextSpan,TDTextConfiguration --folder-name text --output "$PARENT_DIR/example/assets/api/" --only-api


# 导航
# back_top
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/backtop/td_backtop.dart" --name TDBackTop --folder-name back-top --output "$PARENT_DIR/example/assets/api/" --only-api
# drawer
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/drawer" --name TDDrawer,TDDrawerWidget,TDDrawerItem,TDDrawerStyle --folder-name drawer --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# indexes
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/indexes" --name TDIndexes,TDIndexesAnchor,TDIndexesList --folder-name indexes --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# navbar
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/navbar/td_nav_bar.dart" --name TDNavBar,TDNavBarItem, --folder-name navbar --output "$PARENT_DIR/example/assets/api/" --only-api
# sidebar
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/sidebar" --name TDSideBar,TDSideBarItem, --folder-name side-bar --output "$PARENT_DIR/example/assets/api/" --only-api
# steps
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/steps" --name TDSteps,TDStepsItemData --folder-name steps --output "$PARENT_DIR/example/assets/api/" --only-api
# tabbar
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/tabbar/td_bottom_tab_bar.dart" --name TDBottomTabBar,BadgeConfig,TDBottomTabBarTabConfig,TDBottomTabBarPopUpBtnConfig,TDBottomTabBarPopUpShapeConfig,PopUpMenuItem --folder-name tab-bar --output "$PARENT_DIR/example/assets/api/" --only-api
# tabs
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/tabs" --name TDTabBar,TDTab,TDTabBarView --folder-name tabs --output "$PARENT_DIR/example/assets/api/" --only-api


# 输入
# calendar
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/calendar" --name TDCalendar,TDCalendarPopup,TDCalendarStyle --folder-name calendar --output "$PARENT_DIR/example/assets/api/" --only-api
# cascader
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/cascader" --name TDMultiCascader --folder-name cascader --output "$PARENT_DIR/example/assets/api/" --only-api

# checkbox
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/checkbox" --name TDCheckbox,TDCheckboxGroup --folder-name checkbox --output "$PARENT_DIR/example/assets/api/" --only-api
# date_picker
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/picker" --name TDPicker,TDDatePicker --folder-name date-time-picker --output "$PARENT_DIR/example/assets/api/" --only-api
# form
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/form" --name TDForm,TDFormItem,TDFormItemType,TDFormValidation --folder-name form --output "$PARENT_DIR/example/assets/api/" --only-api
# input
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/input/td_input.dart" --name TDInput, TDInputSpacer --folder-name input --output "$PARENT_DIR/example/assets/api/" --only-api
# picker
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/picker" --name TDPicker,TDMultiPicker,TDMultiLinkedPicker,MultiLinkedPickerModel --folder-name picker --output "$PARENT_DIR/example/assets/api/" --only-api
# radio
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/radio/td_radio.dart" --name TDRadioStyle,TDRadio,TDRadioGroup --folder-name radio --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# rate
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/rate/td_rate.dart" --name TDRate --folder-name rate --output "$PARENT_DIR/example/assets/api/" --only-api
# search
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/search/td_search_bar.dart" --name TDSearchBar --folder-name search --output "$PARENT_DIR/example/assets/api/" --only-api
# slider
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/slider/td_slider.dart" --name TDSlider,TDRangeSlider,TDSliderThemeData --folder-name slider --output "$PARENT_DIR/example/assets/api/" --only-api
# stepper
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/stepper/td_stepper.dart" --name TDStepper --folder-name stepper --output "$PARENT_DIR/example/assets/api/" --only-api
# switch
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/switch/td_switch.dart" --name TDSwitch --folder-name switch --output "$PARENT_DIR/example/assets/api/" --only-api
# textarea
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/textarea/td_textarea.dart" --name TDTextarea --folder-name textarea --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# tree_select
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/tree/td_tree_select.dart" --name TDTreeSelect,TDSelectOption --folder-name tree-select --output "$PARENT_DIR/example/assets/api/" --only-api

# upload
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/upload/td_upload.dart" --name TDUpload --folder-name upload --output "$PARENT_DIR/example/assets/api/" --only-api


# 数据展示
# avatar
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/avatar/td_avatar.dart" --name TDAvatar --folder-name avatar --output "$PARENT_DIR/example/assets/api/" --only-api
# badge
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/badge/td_badge.dart" --name TDBadge --folder-name badge --output "$PARENT_DIR/example/assets/api/" --only-api
# cell
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/cell" --name TDCell,TDCellGroup,TDCellStyle --folder-name cell --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# timeCounter
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/time_counter" --name TDTimeCounter,TDTimeCounterController,TDTimeCounterStyle --folder-name time-counter --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# collapse
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/collapse" --name TDCollapse --folder-name collapse --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments

# empty
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/empty/td_empty.dart" --name TDEmpty --folder-name empty --output "$PARENT_DIR/example/assets/api/" --only-api
# footer
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/footer/td_footer.dart" --name TDFooter,TDFooterType --folder-name footer --output "$PARENT_DIR/example/assets/api/" --only-api

# grid
# image
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/image/td_image.dart" --name TDImage --folder-name image --output "$PARENT_DIR/example/assets/api/" --only-api
# imageViewer
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/image_viewer" --name TDImageViewer,TDImageViewerWidget, --folder-name image-viewer --output "$PARENT_DIR/example/assets/api/" --only-api
# progress
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/progress/td_progress.dart" --name TDProgress --folder-name progress --output "$PARENT_DIR/example/assets/api/" --only-api
# result
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/result/td_result.dart" --name TDResult --folder-name result --output "$PARENT_DIR/example/assets/api/" --only-api
# skeleton
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/skeleton" --name TDSkeleton,TDSkeletonRowColStyle,TDSkeletonRowCol,TDSkeletonRowColObjStyle,TDSkeletonRowColObj --folder-name skeleton --output "$PARENT_DIR/example/assets/api/" --only-api

# sticky
# swiper
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/swiper" --name TDSwiperPagination,TDPageTransformer --folder-name swiper --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# table
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/table" --name TDTable,TDTableCol,TDTableEmpty --folder-name table --output "$PARENT_DIR/example/assets/api/" --only-api
# tag
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/tag" --name TDTag,TDSelectTag,TDTagStyle --folder-name tag --output "$PARENT_DIR/example/assets/api/" --only-api



# 反馈
# action_sheet
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/action_sheet" --name TDActionSheetItem,TDActionSheet --folder-name action-sheet --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# dialog
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/dialog" --name TDAlertDialog,TDConfirmDialog,TDDialogButtonOptions,TDDialogButtonStyle,TDDialogScaffold,TDDialogTitle,TDDialogContent,TDDialogInfoWidget,HorizontalNormalButtons,HorizontalTextButtons,TDDialogButton,TDDialogImagePosition,TDImageDialog,TDInputDialog --folder-name dialog --output "$PARENT_DIR/example/assets/api/" --only-api
# dropdown_menu
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/dropdown_menu" --name TDDropdownMenu,TDDropdownMenuDirection,TDDropdownItem,TDDropdownItemOption,TDDropdownItemController --folder-name dropdown-menu --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# loading
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/loading/td_loading.dart" --name TDLoading --folder-name loading --output "$PARENT_DIR/example/assets/api/" --only-api
# message
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/message/td_message.dart" --name TDMessage,MessageTheme,MessageMarquee,MessageLink --folder-name message --output "$PARENT_DIR/example/assets/api/" --only-api
# noticeBar
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/notice_bar" --name TDNoticeBar,TDNoticeBarStyle --folder-name notice-bar --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# overlay
# popover
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/popover" --name TDPopover,TDPopoverWidget --folder-name popover --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# popup
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/popup" --name TDSlidePopupRoute,TDPopupBottomDisplayPanel,TDPopupBottomConfirmPanel,TDPopupCenterPanel --folder-name popup --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# refresh
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/refresh/td_refresh_header.dart" --name TDRefreshHeader --folder-name pull-down-refresh --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# swipecell
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/swipe_cell" --name TDSwipeAction,TDSwipeAutoClose,TDSwipeCell,TDSwipePanel --folder-name swipe-cell --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# toast
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/toast/td_toast.dart" --name TDToast --folder-name toast --output "$PARENT_DIR/example/assets/api/" --only-api


# 其他
# theme
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/theme/td_theme.dart" --name TDTheme,TDThemeData --folder-name theme --output "$PARENT_DIR/example/assets/api/" --only-api
# radius
