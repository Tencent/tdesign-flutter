import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

class TSearchBarPage extends StatefulWidget {
  const TSearchBarPage({super.key});

  @override
  State<TSearchBarPage> createState() => _TSearchBarPageState();
}

class _TSearchBarPageState extends State<TSearchBarPage> {
  static const _allResults = <String>[
    'tdesign-vue',
    'tdesign-react',
    'tdesign-miniprogram',
    'tdesign-angular',
    'tdesign-mobile-vue',
    'tdesign-mobile-react',
  ];

  final _resultController = TextEditingController();
  final _actionController = TextEditingController();
  var _results = const <String>[];
  var _resultFocused = false;
  var _resultSelected = false;
  var _showAction = false;

  @override
  void dispose() {
    _resultController.dispose();
    _actionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于用户输入搜索信息，并进行页面内容搜索。',
      backgroundColor: context.tTheme.bgColorPage,
      exampleCodeGroup: 'search',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础搜索框', center: false, builder: _buildBase),
            ExampleItem(desc: '字数限制', center: false, builder: _buildMaxLength),
            ExampleItem(
              desc: '获取焦点后显示取消按钮',
              center: false,
              builder: _buildAction,
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '搜索框形状', center: false, builder: _buildShape),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '默认状态其他对齐方式',
              center: false,
              builder: _buildCenter,
            ),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'search')
  Widget _buildBase(BuildContext context) {
    return Column(
      children: [
        const _SearchDemoSurface(child: TSearchBar(hintText: '搜索预设文案')),
        const SizedBox(height: 16),
        _SearchDemoSurface(
          child: Column(
            children: [
              TSearchBar(
                controller: _resultController,
                hintText: '输入tdesign，有预览结果',
                onChanged: _filterResults,
                onFocusChanged: _handleResultFocusChanged,
              ),
              ..._results.map(
                (result) => TCell(
                  title: _highlightResult(result),
                  onTap: () => _selectResult(result),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'search')
  Widget _buildMaxLength(BuildContext context) {
    return const Column(
      children: [
        _SearchDemoSurface(
          child: TSearchBar(hintText: '最大输入10个字符', maxLength: 10),
        ),
        SizedBox(height: 16),
        _SearchDemoSurface(
          child: TSearchBar(hintText: '最大输入10个字符，汉字算两个', maxCharacter: 10),
        ),
      ],
    );
  }

  @ExampleCode(group: 'search')
  Widget _buildAction(BuildContext context) {
    return _SearchDemoSurface(
      child: TSearchBar(
        controller: _actionController,
        hintText: '搜索预设文案',
        textAlignment: TSearchBarAlignment.center,
        actionText: _showAction ? '取消' : null,
        onFocusChanged: (focused) => setState(() => _showAction = focused),
        onActionPressed: () {
          _actionController.clear();
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() => _showAction = false);
        },
      ),
    );
  }

  @ExampleCode(group: 'search')
  Widget _buildShape(BuildContext context) {
    return const Column(
      children: [
        _SearchDemoSurface(child: TSearchBar(hintText: '搜索预设文案')),
        SizedBox(height: 16),
        _SearchDemoSurface(
          child: TSearchBar(
            hintText: '搜索预设文案',
            variant: TSearchBarVariant.round,
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'search')
  Widget _buildCenter(BuildContext context) {
    return const _SearchDemoSurface(
      child: TSearchBar(
        hintText: '搜索预设文案',
        textAlignment: TSearchBarAlignment.center,
      ),
    );
  }

  void _filterResults(String value) {
    setState(() {
      _resultSelected = false;
      _results = _resultFocused
          ? _allResults.where((item) => item.contains(value)).toList()
          : const [];
    });
  }

  void _handleResultFocusChanged(bool focused) {
    setState(() {
      _resultFocused = focused;
      _results = focused && !_resultSelected
          ? _allResults
                .where((item) => item.contains(_resultController.text))
                .toList()
          : const [];
    });
  }

  void _selectResult(String result) {
    setState(() {
      _resultController.text = result;
      _resultSelected = true;
      _results = const [];
    });
  }

  Widget _highlightResult(String result) {
    final query = _resultController.text;
    final start = result.indexOf(query);
    if (query.isEmpty || start < 0) {
      return Text(result);
    }
    final end = start + query.length;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: result.substring(0, start)),
          TextSpan(
            text: result.substring(start, end),
            style: TextStyle(color: context.tTheme.brandNormalColor),
          ),
          TextSpan(text: result.substring(end)),
        ],
      ),
    );
  }
}

class _SearchDemoSurface extends StatelessWidget {
  const _SearchDemoSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.tTheme.bgColorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: child,
      ),
    );
  }
}
