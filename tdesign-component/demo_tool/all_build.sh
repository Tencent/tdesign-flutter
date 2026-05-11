#!/bin/bash

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# 基础
# button
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/button" --name TButton,TButtonStyle --folder-name button --output "$PARENT_DIR/example/assets/api/" --only-api
# divider
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/divider/t_divider.dart" --name TDivider --folder-name divider --output "$PARENT_DIR/example/assets/api/" --only-api
# fab
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/fab/t_fab.dart" --name TFab --folder-name fab --output "$PARENT_DIR/example/assets/api/" --only-api
# icon
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/icon/t_icons.dart" --name TIcons --folder-name icon --output "$PARENT_DIR/example/assets/api/" --only-api
# link
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/link/t_link.dart" --name TLink --folder-name link --output "$PARENT_DIR/example/assets/api/" --only-api
# text
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/text/t_text.dart" --name TText,TTextSpan,TTextConfiguration --folder-name text --output "$PARENT_DIR/example/assets/api/" --only-api


# 导航
# back_top
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/backtop/t_backtop.dart" --name TBackTop --folder-name back-top --output "$PARENT_DIR/example/assets/api/" --only-api
# drawer
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/drawer" --name TDrawer,TDrawerWidget,TDrawerItem --folder-name drawer --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# indexes
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/indexes" --name TIndexes,TIndexesAnchor,TIndexesList --folder-name indexes --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# navbar
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/navbar/t_nav_bar.dart" --name TNavBar,TNavBarItem, --folder-name navbar --output "$PARENT_DIR/example/assets/api/" --only-api
# sidebar
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/sidebar" --name TSideBar,TSideBarItem, --folder-name side-bar --output "$PARENT_DIR/example/assets/api/" --only-api
# steps
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/steps" --name TSteps,TStepsItemData --folder-name steps --output "$PARENT_DIR/example/assets/api/" --only-api
# tabbar
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/tabbar/t_bottom_tab_bar.dart" --name TBottomTabBar,BadgeConfig,TBottomTabBarTabConfig,TBottomTabBarPopUpBtnConfig,TBottomTabBarPopUpShapeConfig,PopUpMenuItem --folder-name tab-bar --output "$PARENT_DIR/example/assets/api/" --only-api
# tabs
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/tabs" --name TTabBar,TTab,TTabBarView --folder-name tabs --output "$PARENT_DIR/example/assets/api/" --only-api


# 输入
# calendar
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/calendar" --name TCalendar,TCalendarPopup,TCalendarStyle,TCalendarDataSource,TLunarInfo,TCalendarDateType --folder-name calendar --output "$PARENT_DIR/example/assets/api/" --only-api
# cascader
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/cascader" --name TMultiCascader --folder-name cascader --output "$PARENT_DIR/example/assets/api/" --only-api

# checkbox
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/checkbox" --name TCheckbox,TCheckboxGroup --folder-name checkbox --output "$PARENT_DIR/example/assets/api/" --only-api
# picker
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/picker" --name TPicker,TPickerOption,TPickerValue,TPickerLoadEvent,TPickerColumns,TPickerLinked,TPickerItems,TPickerKeys --folder-name picker --output "$PARENT_DIR/example/assets/api/" --only-api
# form
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/form" --name TForm,TFormItem,TFormItemType,TFormValidation --folder-name form --output "$PARENT_DIR/example/assets/api/" --only-api
# input
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/input/t_input.dart" --name TInput, TInputSpacer --folder-name input --output "$PARENT_DIR/example/assets/api/" --only-api
# radio
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/radio/t_radio.dart" --name TRadioStyle,TRadio,TRadioGroup --folder-name radio --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# rate
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/rate/t_rate.dart" --name TRate --folder-name rate --output "$PARENT_DIR/example/assets/api/" --only-api
# search
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/search/t_search_bar.dart" --name TSearchBar --folder-name search --output "$PARENT_DIR/example/assets/api/" --only-api
# slider
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/slider/t_slider.dart" --name TSlider,TRangeSlider,TSliderThemeData --folder-name slider --output "$PARENT_DIR/example/assets/api/" --only-api
# stepper
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/stepper/t_stepper.dart" --name TStepper --folder-name stepper --output "$PARENT_DIR/example/assets/api/" --only-api
# switch
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/switch/t_switch.dart" --name TSwitch --folder-name switch --output "$PARENT_DIR/example/assets/api/" --only-api
# textarea
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/textarea/t_textarea.dart" --name TTextarea --folder-name textarea --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# tree_select
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/tree/t_tree_select.dart" --name TTreeSelect,TSelectOption --folder-name tree-select --output "$PARENT_DIR/example/assets/api/" --only-api

# upload
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/upload/t_upload.dart" --name TUpload --folder-name upload --output "$PARENT_DIR/example/assets/api/" --only-api


# 数据展示
# avatar
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/avatar/t_avatar.dart" --name TAvatar --folder-name avatar --output "$PARENT_DIR/example/assets/api/" --only-api
# badge
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/badge/t_badge.dart" --name TBadge --folder-name badge --output "$PARENT_DIR/example/assets/api/" --only-api
# cell
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/cell" --name TCell,TCellGroup,TCellStyle --folder-name cell --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# timeCounter
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/time_counter" --name TTimeCounter,TTimeCounterController,TTimeCounterStyle --folder-name time-counter --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# collapse
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/collapse" --name TCollapse --folder-name collapse --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments

# empty
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/empty/t_empty.dart" --name TEmpty --folder-name empty --output "$PARENT_DIR/example/assets/api/" --only-api
# footer
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/footer/t_footer.dart" --name TFooter,TFooterType --folder-name footer --output "$PARENT_DIR/example/assets/api/" --only-api

# grid
# image
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/image/t_image.dart" --name TImage --folder-name image --output "$PARENT_DIR/example/assets/api/" --only-api
# imageViewer
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/image_viewer" --name TImageViewer,TImageViewerWidget, --folder-name image-viewer --output "$PARENT_DIR/example/assets/api/" --only-api
# progress
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/progress/t_progress.dart" --name TProgress --folder-name progress --output "$PARENT_DIR/example/assets/api/" --only-api
# result
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/result/t_result.dart" --name TResult --folder-name result --output "$PARENT_DIR/example/assets/api/" --only-api
# skeleton
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/skeleton" --name TSkeleton,TSkeletonRowColStyle,TSkeletonRowCol,TSkeletonRowColObjStyle,TSkeletonRowColObj --folder-name skeleton --output "$PARENT_DIR/example/assets/api/" --only-api

# sticky
# swiper
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/swiper" --name TSwiperPagination,TPageTransformer --folder-name swiper --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# table
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/table" --name TTable,TTableCol,TTableEmpty --folder-name table --output "$PARENT_DIR/example/assets/api/" --only-api
# tag
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/tag" --name TTag,TSelectTag,TTagStyle --folder-name tag --output "$PARENT_DIR/example/assets/api/" --only-api



# 反馈
# action_sheet
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/action_sheet" --name TActionSheetItem,TActionSheet --folder-name action-sheet --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# dialog
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/dialog" --name TAlertDialog,TConfirmDialog,TDialogButtonOptions,TDialogButtonStyle,TDialogScaffold,TDialogTitle,TDialogContent,TDialogInfoWidget,HorizontalNormalButtons,HorizontalTextButtons,TDialogButton,TDialogImagePosition,TImageDialog,TInputDialog --folder-name dialog --output "$PARENT_DIR/example/assets/api/" --only-api
# dropdown_menu
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/dropdown_menu" --name TDropdownMenu,TDropdownMenuDirection,TDropdownItem,TDropdownItemOption,TDropdownItemController --folder-name dropdown-menu --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# loading
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/loading/t_loading.dart" --name TLoading --folder-name loading --output "$PARENT_DIR/example/assets/api/" --only-api
# message
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/message/t_message.dart" --name TMessage,MessageTheme,MessageMarquee,MessageLink --folder-name message --output "$PARENT_DIR/example/assets/api/" --only-api
# noticeBar
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/notice_bar" --name TNoticeBar,TNoticeBarStyle --folder-name notice-bar --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# overlay
# popover
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/popover" --name TPopover,TPopoverWidget --folder-name popover --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# popup
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/popup" --name TSlidePopupRoute,TPopupBottomDisplayPanel,TPopupBottomConfirmPanel,TPopupCenterPanel --folder-name popup --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# refresh
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/refresh/t_refresh_header.dart" --name TRefreshHeader --folder-name pull-down-refresh --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# swipecell
dart run tdesign_flutter_tools:main generate --folder "$PARENT_DIR/lib/src/components/swipe_cell" --name TSwipeAction,TSwipeAutoClose,TSwipeCell,TSwipePanel --folder-name swipe-cell --output "$PARENT_DIR/example/assets/api/" --only-api --get-comments
# toast
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/components/toast/t_toast.dart" --name TToast --folder-name toast --output "$PARENT_DIR/example/assets/api/" --only-api


# 其他
# theme
dart run tdesign_flutter_tools:main generate --file "$PARENT_DIR/lib/src/theme/t_theme.dart" --name TTheme,TThemeData --folder-name theme --output "$PARENT_DIR/example/assets/api/" --only-api
# radius
