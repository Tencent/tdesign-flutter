import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'navbar')
class SearchNavbarExample extends StatelessWidget {
  const SearchNavbarExample({super.key});

  Widget _searchNavbar(BuildContext context) {
    return TNavBar(
      key: const Key('navbar-demo-search'),
      centerTitle: false,
      titleMargin: 0,
      title: Theme(
        data: Theme.of(context).mergeExtension(
          const TSearchBarThemeData(variant: TSearchBarVariant.round),
        ),
        child: TSearchBar(
          hintText: '搜索预设文案',
          onChanged: (String text) {
            print('input：$text');
          },
        ),
      ),
      actions: [
        TNavBarItem(
          icon: TIcons.home,
          iconSize: 24,
          onTap: () => TToast.showText('点击了首页', context: context),
        ),
        TNavBarItem(
          icon: TIcons.ellipsis,
          iconSize: 24,
          onTap: () => TToast.showText('点击了更多', context: context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _searchNavbar(context);
  }
}
