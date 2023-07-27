import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

///
/// 搜索框的样式
///
enum TDSearchStyle {
  square, // 方形
  round, // 圆形
}

///
/// 搜索框对齐方式
///
enum TDSearchAlignment {
  left, // 默认头部对齐
  center, // 居中
}

typedef TDSearchBarEvent = void Function(String value);
typedef TDSearchBarCallBack = void Function();

class TDSearchBar extends StatefulWidget {
  const TDSearchBar({
    Key? key,
    this.placeHolder,
    this.style = TDSearchStyle.square,
    this.alignment = TDSearchAlignment.left,
    this.onTextChanged,
    this.onSubmitted,
    this.onEditComplete,
    this.autoHeight = false,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.autoFocus = false,
    this.mediumStyle = false,
    this.needCancel = false,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  /// 预设文案
  final String? placeHolder;

  /// 样式
  final TDSearchStyle? style;

  /// 对齐方式，居中或这头部对齐
  final TDSearchAlignment? alignment;

  /// 背景颜色
  final Color? backgroundColor;

  /// 是否自动计算高度
  final bool autoHeight;

  /// 内部填充
  final EdgeInsets padding;

  /// 是否自动获取焦点
  final bool autoFocus;

  /// 是否在导航栏中的样式
  final bool mediumStyle;

  /// 是否需要取消按钮
  final bool needCancel;

  /// 文字改变回调
  final TDSearchBarEvent? onTextChanged;

  /// 提交回调
  final TDSearchBarEvent? onSubmitted;

  /// 编辑完成回调
  final TDSearchBarCallBack? onEditComplete;

  @override
  State<StatefulWidget> createState() => _TDSearchBarState();
}

enum _TDSearchBarStatus {
  unFocus,
  animatingToFocus,
  focused,
  animatingToUnFocus
}

class _TDSearchBarState extends State<TDSearchBar>
    with TickerProviderStateMixin {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  final GlobalKey _textFieldKey = GlobalKey();
  final GlobalKey _phKey = GlobalKey();

  late AnimationController _animationController;
  Animation<Offset>? _animation;
  bool clearBtnHide = true;
  bool cancelBtnHide = true;
  late _TDSearchBarStatus _status;
  @override
  void initState() {
    super.initState();
    _status = widget.autoFocus
        ? _TDSearchBarStatus.focused
        : _TDSearchBarStatus.unFocus;
    controller.addListener(() {
      var clearVisible = controller.text.isNotEmpty;
      _updateClearBtnVisible(clearVisible);
    });
    focusNode.addListener(() {
      setState(() {
        _status = focusNode.hasFocus
            ? _TDSearchBarStatus.focused
            : _TDSearchBarStatus.unFocus;
      });
      _updateCancelBtnVisible(focusNode.hasFocus);
    });
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          if (_status == _TDSearchBarStatus.animatingToFocus) {
            _status = _TDSearchBarStatus.focused;
            focusNode.requestFocus();
          } else if (_status == _TDSearchBarStatus.animatingToUnFocus) {
            _status = _TDSearchBarStatus.unFocus;
          }
        });
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   var phBox = _phKey.currentContext?.findRenderObject() as RenderBox?;
    //   if (phBox != null) {
    //     setState(() {
    //       if (widget.alignment != TDSearchAlignment.center) {
    //         return;
    //       }
    //       var dx = (phBox.size.width / 2 - 24) / phBox.size.width;
    //       if (dx < 0) {
    //         return;
    //       }

    //       _animation ??= Tween(begin: Offset.zero, end: Offset(-dx, 0))
    //           .animate(_animationController);
    //     });
    //   }
    // });
  }

  void _updateClearBtnVisible(bool visible) {
    setState(() {
      clearBtnHide = !visible;
    });
  }

  void _updateCancelBtnVisible(bool visible) {
    setState(() {
      cancelBtnHide = !visible;
    });
  }

  Font? getSize(BuildContext context) {
    return widget.mediumStyle
        ? TDTheme.of(context).fontBodyMedium
        : TDTheme.of(context).fontBodyLarge;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      height: widget.autoHeight ? double.infinity : 56,
      color: widget.backgroundColor,
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    color: TDTheme.of(context).grayColor1,
                    borderRadius: BorderRadius.circular(
                        widget.style == TDSearchStyle.square ? 4 : 28)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Icon(
                      TDIcons.search,
                      size: widget.mediumStyle ? 20 : 24,
                      color: TDTheme.of(context).fontGyColor3,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 3)),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 1),// 为了适配TextField与Text的差异，后续需要做通用适配
                        child: TextField(
                          key: _textFieldKey,
                          controller: controller,
                          autofocus: widget.autoFocus,
                          cursorColor: TDTheme.of(context).brandNormalColor,
                          cursorWidth: 1,
                          cursorHeight: widget.mediumStyle ? 16 : 18,
                          textAlign: widget.alignment == TDSearchAlignment.center
                              ? TextAlign.center
                              : TextAlign.left,
                          focusNode: focusNode,
                          onChanged: widget.onTextChanged,
                          onSubmitted: widget.onSubmitted,
                          style: TextStyle(
                              fontSize: getSize(context)?.size,
                              color: TDTheme.of(context).fontGyColor1),
                          decoration: InputDecoration(
                            hintText: (_status != _TDSearchBarStatus.focused)
                                ? ''
                                : widget.placeHolder,
                            hintStyle: TextStyle(
                                fontSize: getSize(context)?.size,
                                color: TDTheme.of(context).fontGyColor3),
                            border: InputBorder.none,
                            isCollapsed: true,
                            filled: true,
                            fillColor: TDTheme.of(context).grayColor1,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 9)),
                    Offstage(
                      offstage: clearBtnHide,
                      child: GestureDetector(
                          onTap: () {
                            controller.clear();
                            if (widget.onTextChanged != null) {
                              widget.onTextChanged!('');
                            }
                          },
                          child: Icon(
                            TDIcons.close_circle_filled,
                            size: widget.mediumStyle ? 17 : 21,
                            color: TDTheme.of(context).fontGyColor3,
                          )),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 9)),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: cancelBtnHide || !widget.needCancel,
              child: GestureDetector(
                onTap: () {
                  controller.clear();
                  if (widget.onTextChanged != null) {
                    widget.onTextChanged!('');
                  }
                  if (_animation == null) {
                    focusNode.unfocus();
                    setState(() {
                      _status = _TDSearchBarStatus.unFocus;
                    });
                    return;
                  }
                  setState(() {
                    _status = _TDSearchBarStatus.animatingToUnFocus;
                  });
                  focusNode.unfocus();
                  _animationController.reverse(
                      from: _animationController.upperBound);
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text('取消',
                      style: TextStyle(
                          fontSize: getSize(context)?.size,
                          color: TDTheme.of(context).brandNormalColor)),
                ),
              ),
            ),
          ],
        ),
        Offstage(
          offstage: (_status == _TDSearchBarStatus.focused ||
              controller.text.isNotEmpty),
          child: GestureDetector(
              onTap: () {
                if (_status == _TDSearchBarStatus.animatingToFocus ||
                    _status == _TDSearchBarStatus.animatingToUnFocus) {
                  return;
                }
                if (_animation == null) {
                  focusNode.requestFocus();
                  setState(() {
                    _status = _TDSearchBarStatus.focused;
                  });
                  return;
                }
                setState(() {
                  _status = _TDSearchBarStatus.animatingToFocus;
                  _animationController.forward();
                });
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: TDTheme.of(context).grayColor1,
                      borderRadius: BorderRadius.circular(
                          widget.style == TDSearchStyle.square ? 4 : 28),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 12, right: 12),
                    alignment: Alignment.centerLeft,
                    child: _getPlaceHolderWidgets(),
                  )
                ],
              )),
        ),
      ]),
    );
  }

  Widget _getPlaceHolderWidgets() {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints box) {
      if (_animation != null) {
        return Row(
          children: [
            Icon(
              TDIcons.search,
              size: widget.mediumStyle ? 20 : 24,
              color: TDTheme.of(context).fontGyColor3,
            ),
            Expanded(
                child: SlideTransition(
              position: _animation!,
              child: Row(
                key: _phKey,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: (widget.mediumStyle ? 20 : 24) / 2,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment:
                        widget.alignment == TDSearchAlignment.left
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: box.maxWidth - 51,
                        ),
                        child: TDText(
                          widget.placeHolder,
                          font: getSize(context),
                          textColor: TDTheme.of(context).fontGyColor3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          forceVerticalCenter: true,
                        ),
                      )
                    ],
                  )),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ),
            ))
          ],
        );
      } else {
        return Row(
          key: _phKey,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              TDIcons.search,
              size: widget.mediumStyle ? 20 : 24,
              color: TDTheme.of(context).fontGyColor3,
            ),
            const SizedBox(
              width: 3,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: widget.alignment == TDSearchAlignment.left
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: box.maxWidth - 51,
                  ),
                  child: TDText(
                    widget.placeHolder,
                    font: getSize(context),
                    textColor: TDTheme.of(context).fontGyColor3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )),
            const SizedBox(
              width: 6,
            ),
          ],
        );
      }
    });
  }
}
