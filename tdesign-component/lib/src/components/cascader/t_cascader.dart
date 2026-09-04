import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../icon/t_icon.dart';
import '../text/t_text.dart';
import 't_cascader_theme_data.dart';

/// 级联选项。
///
/// [children] 应按 Flutter Widget 配置的不可变约定使用。数据变化时请创建新的
/// [TCascaderOption] 和列表，不要原地修改已有列表。
class TCascaderOption {
  const TCascaderOption({
    /// 展示文案。
    required this.label,

    /// 选项值。
    required this.value,

    /// 子选项。
    this.children = const [],

    /// 是否禁用。
    this.disabled = false,
  });

  /// 展示文案。
  final String label;

  /// 选项值。
  final Object? value;

  /// 子选项。
  final List<TCascaderOption> children;

  /// 是否禁用。
  final bool disabled;
}

/// 严格受控的级联选择器。
class TCascader extends StatefulWidget {
  const TCascader({
    super.key,

    /// 根选项列表。
    required this.options,

    /// 受控选中路径。
    required this.value,

    /// 选中路径变化回调；为 null 时禁用。
    this.onChanged,

    /// 导航展示形态。
    this.variant = TCascaderVariant.tab,

    /// 未选择层级的占位文案。
    this.placeholder = '请选择',

    /// 各层级的次级标题。
    ///
    /// 组件按内部活动层级读取对应内容，因此调用方无需持有或控制层级状态。
    this.subtitles = const [],
  });

  /// 根选项列表。
  final List<TCascaderOption> options;

  /// 受控选中路径。
  final List<Object?> value;

  /// 选中路径变化回调；为 null 时禁用。
  final ValueChanged<List<Object?>>? onChanged;

  /// 导航展示形态。
  final TCascaderVariant variant;

  /// 未选择层级的占位文案。
  final String placeholder;

  /// 各层级的次级标题。
  final List<String> subtitles;

  @override
  State<TCascader> createState() => _TCascaderState();
}

class _TCascaderState extends State<TCascader> {
  late int _activeLevel;

  bool get _enabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _activeLevel = _initialActiveLevel();
  }

  @override
  void didUpdateWidget(covariant TCascader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.value, widget.value) ||
        oldWidget.options != widget.options) {
      final maxLevel = _availableDepth();
      if (_activeLevel > maxLevel) {
        _activeLevel = maxLevel;
      }
    }
  }

  int _initialActiveLevel() {
    if (widget.value.isEmpty) {
      return 0;
    }
    final selected = _selectedOptions();
    if (selected.isEmpty) {
      return 0;
    }
    return selected.isNotEmpty && selected.last.children.isNotEmpty
        ? selected.length
        : selected.length - 1;
  }

  int _availableDepth() => _selectedOptions().length;

  List<TCascaderOption> _selectedOptions() {
    var options = widget.options;
    final selected = <TCascaderOption>[];
    for (final value in widget.value) {
      final index = options.indexWhere((option) => option.value == value);
      if (index < 0) {
        break;
      }
      final option = options[index];
      selected.add(option);
      options = option.children;
    }
    return selected;
  }

  List<TCascaderOption> _optionsAt(int level) {
    var options = widget.options;
    for (var index = 0; index < level; index++) {
      if (index >= widget.value.length) {
        return const [];
      }
      final selected = options.where(
        (option) => option.value == widget.value[index],
      );
      if (selected.isEmpty) {
        return const [];
      }
      options = selected.first.children;
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    final material = Theme.of(context);
    final theme = material.extension<TCascaderThemeData>();
    final selected = _selectedOptions();
    final options = _optionsAt(_activeLevel);
    final backgroundColor =
        theme?.backgroundColor ??
        material.tExplicitColorScheme?.surface ??
        context.tTheme.bgColorContainer;
    final borderRadius = BorderRadius.circular(
      theme?.borderRadius ?? context.tTheme.radiusDefault,
    );
    return Semantics(
      enabled: _enabled,
      child: AnimatedOpacity(
        opacity: _enabled ? 1 : 0.5,
        duration: const Duration(milliseconds: 150),
        child: AbsorbPointer(
          absorbing: !_enabled,
          child: SizedBox(
            height: theme?.height ?? 360,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavigation(context, selected, theme),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color:
                        theme?.dividerColor ??
                        material.dividerTheme.color ??
                        context.tTheme.componentStrokeColor,
                  ),
                  if (_activeLevel < widget.subtitles.length)
                    _buildSubtitle(context),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      itemBuilder: (context, index) =>
                          _buildOption(context, options[index], theme),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation(
    BuildContext context,
    List<TCascaderOption> selected,
    TCascaderThemeData? theme,
  ) {
    final styles = _resolveTextStyles(context, theme);
    final entries = <_CascaderNavigationEntry>[
      for (var index = 0; index < selected.length; index++)
        _CascaderNavigationEntry(
          label: selected[index].label,
          selected: true,
          active: index == _activeLevel,
          onTap: () => setState(() => _activeLevel = index),
        ),
      if (selected.isEmpty || selected.last.children.isNotEmpty)
        _CascaderNavigationEntry(
          label: widget.placeholder,
          selected: false,
          active: selected.length == _activeLevel,
          onTap: () => setState(() => _activeLevel = selected.length),
        ),
    ];
    if (widget.variant == TCascaderVariant.step) {
      return Padding(
        padding:
            theme?.navigationPadding ??
            EdgeInsets.fromLTRB(
              context.tTheme.spacer16,
              0,
              context.tTheme.spacer16,
              context.tTheme.spacer4,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < entries.length; index++)
              _buildStepNavigationEntry(
                context,
                entries[index],
                styles,
                index,
                entries.length,
              ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: theme?.navigationPadding,
      child: Row(
        children: [
          for (final entry in entries)
            _buildTabNavigationEntry(context, entry, styles),
        ],
      ),
    );
  }

  Widget _buildStepNavigationEntry(
    BuildContext context,
    _CascaderNavigationEntry entry,
    _CascaderTextStyles styles,
    int index,
    int length,
  ) {
    final brandColor = context.tTheme.brandNormalColor;
    return Semantics(
      button: true,
      selected: entry.active,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: entry.onTap,
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              SizedBox(
                width: 8,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (index > 0)
                      Positioned(
                        top: 0,
                        bottom: 26,
                        child: Container(width: 1, color: brandColor),
                      ),
                    if (index < length - 1)
                      Positioned(
                        top: 26,
                        bottom: 0,
                        child: Container(width: 1, color: brandColor),
                      ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: entry.selected
                            ? brandColor
                            : context.tTheme.bgColorContainer,
                        border: Border.all(color: brandColor),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.tTheme.spacer16),
              Expanded(
                child: TText(
                  entry.label,
                  style: entry.active ? styles.active : styles.normal,
                ),
              ),
              TIcon(
                TIcons.chevron_right,
                size: 22,
                color:
                    Theme.of(context).tExplicitIconTheme?.color ??
                    context.tTheme.textColorPlaceholder,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabNavigationEntry(
    BuildContext context,
    _CascaderNavigationEntry entry,
    _CascaderTextStyles styles,
  ) {
    return Semantics(
      button: true,
      selected: entry.active,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: entry.onTap,
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
          decoration: BoxDecoration(
            border: entry.active
                ? Border(
                    bottom: BorderSide(
                      width: 2,
                      color: context.tTheme.brandNormalColor,
                    ),
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: TText(
            entry.label,
            style: entry.active ? styles.active : styles.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final tokenFont = context.tTheme.fontBodyMedium;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.tTheme.spacer16,
        20,
        context.tTheme.spacer16,
        0,
      ),
      child: TText(
        widget.subtitles[_activeLevel],
        style: TextStyle(
          color: context.tTheme.textColorPlaceholder,
          fontSize: tokenFont?.size,
          height: tokenFont?.height,
          fontWeight: tokenFont?.fontWeight,
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    TCascaderOption option,
    TCascaderThemeData? theme,
  ) {
    final styles = _resolveTextStyles(context, theme);
    final selected =
        _activeLevel < widget.value.length &&
        widget.value[_activeLevel] == option.value;
    final isLeaf = option.children.isEmpty;
    final material = Theme.of(context);
    final indicatorColor =
        theme?.indicatorColor ??
        material.tExplicitIconTheme?.color ??
        material.tExplicitColorScheme?.primary ??
        context.tTheme.brandNormalColor;
    final onTap = option.disabled
        ? null
        : () {
            final next = <Object?>[
              ...widget.value.take(_activeLevel),
              option.value,
            ];
            if (option.children.isNotEmpty) {
              setState(() => _activeLevel += 1);
            }
            widget.onChanged?.call(List.unmodifiable(next));
          };
    return Semantics(
      button: true,
      enabled: !option.disabled,
      selected: selected,
      child: GestureDetector(
        key: ValueKey('cascader-${option.value}'),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
            child: Row(
              children: [
                Expanded(
                  child: TText(
                    option.label,
                    style: option.disabled ? styles.disabled : styles.normal,
                  ),
                ),
                if (isLeaf && selected)
                  TIcon(TIcons.check, size: 24, color: indicatorColor)
                else if (!isLeaf)
                  TIcon(
                    TIcons.chevron_right,
                    size: 22,
                    color:
                        material.tExplicitIconTheme?.color ??
                        context.tTheme.textColorPlaceholder,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _CascaderTextStyles _resolveTextStyles(
    BuildContext context,
    TCascaderThemeData? theme,
  ) {
    final material = Theme.of(context);
    final tokenFont = context.tTheme.fontBodyLarge;
    final normal =
        TextStyle(
              color:
                  material.tExplicitColorScheme?.onSurface ??
                  context.tTheme.textColorPrimary,
              fontSize: tokenFont?.size,
              height: tokenFont?.height,
              fontWeight: tokenFont?.fontWeight,
            )
            .merge(material.tExplicitTextTheme?.bodyLarge)
            .merge(context.tExplicitDefaultTextStyle)
            .merge(theme?.textStyle);
    final active = normal
        .copyWith(
          color:
              material.tExplicitColorScheme?.primary ??
              context.tTheme.brandNormalColor,
          fontWeight: FontWeight.w600,
        )
        .merge(theme?.activeTextStyle);
    final disabled = normal
        .copyWith(color: context.tTheme.textDisabledColor)
        .merge(theme?.disabledTextStyle);
    return _CascaderTextStyles(
      normal: normal,
      active: active,
      disabled: disabled,
    );
  }
}

class _CascaderNavigationEntry {
  const _CascaderNavigationEntry({
    required this.label,
    required this.selected,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool active;
  final VoidCallback onTap;
}

class _CascaderTextStyles {
  const _CascaderTextStyles({
    required this.normal,
    required this.active,
    required this.disabled,
  });

  final TextStyle normal;
  final TextStyle active;
  final TextStyle disabled;
}
