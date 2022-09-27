import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../../td_export.dart';

typedef TDSearchBarEvent = void Function(String value);
typedef TDSearchBarCallBack = void Function();

class TDSearchBar extends StatefulWidget {
  final String? placeHolder;
  final Color? backgroundColor;
  final bool autoFocus;
  final TDSearchBarEvent? onTextChanged;
  final TDSearchBarEvent? onSubmitted;
  final TDSearchBarCallBack? onEditComplete;

  const TDSearchBar({
    Key? key,
    this.placeHolder,
    this.onTextChanged,
    this.onSubmitted,
    this.onEditComplete,
    this.autoFocus = false,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDSearchBarState();
}

enum _TDSearchBarStatus {
  unFocus,
  animatingToFocus,
  focused,
  animatingToUnFocus
}

class _TDSearchBarState extends State<TDSearchBar> with TickerProviderStateMixin {
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
    _status = widget.autoFocus ? _TDSearchBarStatus.focused : _TDSearchBarStatus.unFocus;
    controller.addListener(() {
      var clearVisible = controller.text.isNotEmpty;
      _updateClearBtnVisible(clearVisible);
    });
    focusNode.addListener(() {
      setState(() {
        _status = focusNode.hasFocus ? _TDSearchBarStatus.focused : _TDSearchBarStatus.unFocus;
      });
      _updateCancelBtnVisible(focusNode.hasFocus);
    });
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        setState(() {
          if(_status == _TDSearchBarStatus.animatingToFocus) {
            _status = _TDSearchBarStatus.focused;
            focusNode.requestFocus();
          } else if(_status == _TDSearchBarStatus.animatingToUnFocus) {
            _status = _TDSearchBarStatus.unFocus;
          }
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var box = _textFieldKey.currentContext?.findRenderObject() as RenderBox?;
      var phBox = _phKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && phBox != null) {
        setState(() {
          var dx = (box.size.width / 2 + 16.5 - phBox.size.width / 2) / phBox.size.width;
          if(dx < 0) {
            return;
          }
          _animation ??=
              Tween(begin: Offset.zero, end: Offset(-dx, 0))
                  .animate(_animationController);
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      height: 56,
      color: widget.backgroundColor,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: TDTheme.of(context).grayColor1,
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      Visibility(
                        visible: _status == _TDSearchBarStatus.focused || controller.text.isNotEmpty,
                        child: Icon(
                          TDIcons.search,
                          size: 24,
                          color: TDTheme.of(context).fontGyColor3,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 3)),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          key: _textFieldKey,
                          controller: controller,
                          autofocus: widget.autoFocus,
                          cursorColor: TDTheme.of(context).brandColor8,
                          cursorWidth: 1,
                          cursorHeight: 18,
                          focusNode: focusNode,
                          onChanged: widget.onTextChanged,
                          onSubmitted: widget.onSubmitted,
                          style: TextStyle(
                              fontSize: TDTheme.of(context).fontM?.size,
                              color: TDTheme.of(context).fontGyColor1),
                          decoration: InputDecoration(
                            hintText:(_status != _TDSearchBarStatus.focused) ? '' : widget.placeHolder,
                            hintStyle: TextStyle(
                                fontSize: TDTheme.of(context).fontM?.size,
                                color: TDTheme.of(context).fontGyColor3),
                            border: InputBorder.none,
                            isCollapsed: true,
                            filled: true,
                            fillColor: TDTheme.of(context).grayColor1,
                          ),
                          maxLines: 1,
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
                              size: 21,
                              color: TDTheme.of(context).fontGyColor3,
                            )),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 9)),
                    ],),),),
              Offstage(
                offstage: cancelBtnHide,
                child: GestureDetector(
                  onTap: () {
                    controller.clear();
                    if (widget.onTextChanged != null) {
                      widget.onTextChanged!('');
                    }
                    if(_animation == null) {
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
                    _animationController.reverse(from: _animationController.upperBound);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text('取消',
                        style: TextStyle(
                            fontSize: TDTheme.of(context).fontM?.size,
                            color: TDTheme.of(context).brandColor8)),
                  ),),),
            ],
          ),
          Offstage(offstage: (_status == _TDSearchBarStatus.focused || controller.text.isNotEmpty), child: GestureDetector(
            onTap: () {
              if(_status == _TDSearchBarStatus.animatingToFocus
                  || _status == _TDSearchBarStatus.animatingToUnFocus) {
                return;
              }
              if(_animation == null) {
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
            child: Stack(children: [
              Container(color: TDTheme.of(context).grayColor1,),
              Center(child: _getPlaceHolderWidgets(),)
            ],)
          ),),
      ]),
    );
  }

  Widget _getPlaceHolderWidgets() {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints box) {
      if(_animation != null) {
        return SlideTransition(
          position: _animation!,
          child: Row(
            key: _phKey,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                TDIcons.search,
                size: 24,
                color: TDTheme.of(context).fontGyColor3,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: ConstrainedBox(constraints: BoxConstraints(maxWidth: box.maxWidth - 51,), child: TDText(
                  widget.placeHolder,
                  font: TDTheme.of(context).fontM,
                  textColor: TDTheme.of(context).fontGyColor3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),),)],),
        );
      } else {
        return Row(
          key: _phKey,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              TDIcons.search,
              size: 24,
              color: TDTheme.of(context).fontGyColor3,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: ConstrainedBox(constraints: BoxConstraints(maxWidth: box.maxWidth - 51,), child: TDText(
                widget.placeHolder,
                font: TDTheme.of(context).fontM,
                textColor: TDTheme.of(context).fontGyColor3,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),),)],);
      }
    });
  }
}
