import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_image_page.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_avatar_page.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_badge_page.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_empty_page.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_icon_page.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_input_view_pager.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_picker_page.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_tab_bar_page.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_tag_page.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_toast_page.dart';
import 'package:tdesign_flutter_example/tdesign/page/td_button_page.dart';

import 'page/td_picker_page.dart';
import 'page/td_tab_bar_page.dart';
import 'page/td_tag_page.dart';
import 'page/td_theme_page.dart';

class TdExampleRoute {
  static final Map<String, Function> routes = {
    "AvatarPage": (context) {
      return AvatarPage();
    },
    "BadgePage": (context) {
      return BadgePage();
    },
    "TabBarPage": (context) {
      return TdTabBarPage();
    },
    "ToastPage": (context) {
      return ToastPage();
    },
    "ButtonPage": (context) {
      return ButtonPage();
    },
    "InputViewPage": (context) {
      return const InputViewPage();
    },
    "TagPage": (context) {
      return const TdTagPage();
    },
    "PickerPage": (context) {
      return TdPickerPage();
    },
    "IconPage": (context) {
      return IconPage();
    },
    "EmptyPage": (context) {
      return EmptyPage();
    },
    "ThemePage": (context) {
      return TdThemePage();
    },
    "ImagePage": (context) {
      return ImagePage();
    }
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? 'unknown';
    var pageContentBuilder = routes[name];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute(
            settings: settings,
            builder: (context) {
              return pageContentBuilder(context, arguments: settings.arguments);
            });
        return route;
      } else {
        final Route route = MaterialPageRoute(
            settings: settings,
            builder: (context) => pageContentBuilder(context));
        return route;
      }
    } else {
      return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Center(
                child: Text('error'),
              ));
    }
  }
}
