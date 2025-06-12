import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../../../tdesign_flutter.dart';
import '../navbar/td_nav_bar.dart';

typedef OnIndexChange = Function(int index);
typedef OnClose = Function(int index);
typedef OnDelete = Function(int index);
typedef OnImageTap = Function(int index);
typedef OnLongPress = Function(int index);
typedef LeftItemBuilder = Widget Function(BuildContext context, int index);
typedef RightItemBuilder = Widget Function(BuildContext context, int index);

class TDImageViewerWidget extends StatefulWidget {
  const TDImageViewerWidget({
    Key? key,
    this.closeBtn,
    this.deleteBtn,
    required this.images,
    this.labels,
    this.showIndex,
    this.loop,
    this.autoplay,
    this.duration,
    this.bgColor,
    this.navBarBgColor,
    this.iconColor,
    this.labelStyle,
    this.indexStyle,
    this.defaultIndex,
    this.onIndexChange,
    this.width,
    this.height,
    this.onClose,
    this.onDelete,
    this.ignoreDeleteError = false,
    this.onTap,
    this.onLongPress,
    this.leftItemBuilder,
    this.rightItemBuilder,
  }) : super(key: key);

  /// 是否展示关闭按钮
  final bool? closeBtn;

  /// 是否显示删除操作
  final bool? deleteBtn;

  /// 图片数组
  final List<dynamic> images;

  /// 图片描述
  final List<String>? labels;

  /// 是否显示页码
  final bool? showIndex;

  /// 图片是否循环
  final bool? loop;

  /// 图片轮播是否自动播放
  final bool? autoplay;

  /// 自动播放间隔
  final int? duration;

  /// 背景色
  final Color? bgColor;

  /// 导航栏背景色
  final Color? navBarBgColor;

  /// 图标颜色
  final Color? iconColor;

  /// label文字样式
  final TextStyle? labelStyle;

  /// 页码样式
  final TextStyle? indexStyle;

  /// 默认预览图片所在的下标
  final int? defaultIndex;

  /// 预览图片切换回调
  final OnIndexChange? onIndexChange;

  /// 关闭点击
  final OnClose? onClose;

  /// 删除点击
  final OnDelete? onDelete;

  /// 是否忽略单张图片删除错误提示
  final bool? ignoreDeleteError;

  /// 点击图片
  final OnImageTap? onTap;

  /// 长按图片
  final OnLongPress? onLongPress;

  /// 图片宽度
  final double? width;

  /// 图片高度
  final double? height;

  /// 左侧自定义操作
  final LeftItemBuilder? leftItemBuilder;

  /// 右侧自定义操作
  final RightItemBuilder? rightItemBuilder;

  @override
  State<StatefulWidget> createState() {
    return _TDImageViewerWidgetState();
  }
}

class _TDImageViewerWidgetState extends State<TDImageViewerWidget> {
  int _index = 1;

  @override
  void initState() {
    super.initState();
    if(widget.images.isEmpty) {
      throw FlutterError('images must not be empty');
    }
    if((widget.defaultIndex ?? 0) > widget.images.length - 1) {
      throw FlutterError('defaultIndex must be less than images.length');
    }
    if(widget.labels != null && widget.images.length != widget.labels!.length) {
      throw FlutterError('labels.length must be equals images.length');
    }
    _index = (widget.defaultIndex ?? 0) + 1;
  }

  Widget _getImage(dynamic image) {
    var size = MediaQuery.of(context).size;
    var boxFit = ((widget.width != null) || (widget.height != null))
        ? BoxFit.fill
        : BoxFit.fitWidth;
    var horizontal =
        widget.width != null ? (size.width - (widget.width ?? 0)) / 2 : 0.0;
    var vertical =
        widget.height != null ? (size.height - (widget.height ?? 0)) / 2 : 0.0;
    var margin =
        EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
    if (image is File) {
      return Container(
        margin: margin,
        child: TDImage(
          imageFile: image,
          fit: boxFit,
          type: TDImageType.fitWidth,
        ),
      );
    }
    if (image is String) {
      if (image.startsWith('http')) {
        return Container(
          margin: margin,
          child: TDImage(
            imgUrl: image,
            fit: boxFit,
            type: TDImageType.fitWidth,
            loadingWidget: Container(
              width: size.width,
              height: size.height,
              color: TDTheme.of(context).fontGyColor1,
              child: Center(
                child: TDLoading(
                  icon: TDLoadingIcon.circle,
                  size: TDLoadingSize.large,
                  iconColor: TDTheme.of(context).brandNormalColor,
                ),
              ),
            ),
          ),
        );
      }
      return Container(
        margin: margin,
        child: TDImage(
          assetUrl: image,
          fit: boxFit,
          type: TDImageType.fitWidth,
        ),
      );
    }
    throw FlutterError('image ${image} type is not supported');
  }

  Widget _getPageTitle() {
    if(widget.labels != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: (widget.labels![_index - 1]) != '',
            child: Text(widget.labels![_index - 1],
              textAlign: TextAlign.center,
              style: widget.labelStyle ?? TextStyle(color: TDTheme.of(context).whiteColor1),
            ),
          ),
          Visibility(
            visible: widget.showIndex ?? false,
            child: Text('$_index / ${widget.images.length}',
              textAlign: TextAlign.center,
              style: widget.indexStyle ?? TextStyle(color: TDTheme.of(context).brandClickColor, fontSize: 10),
            ),
          )
        ],
      );
    }
    return Text(
      (widget.showIndex ?? false)
          ? '$_index / ${widget.images.length}'
          : '',
      textAlign: TextAlign.center,
      style: widget.indexStyle ?? TextStyle(color: TDTheme.of(context).whiteColor1),
    );
  }

  Widget _getLeft() {
    if(widget.leftItemBuilder != null) {
      return widget.leftItemBuilder!(context, _index - 1);
    }
    return GestureDetector(
      onTap: () {
        if (widget.onClose != null) {
          widget.onClose!.call(_index - 1);
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Icon(
        TDIcons.close,
        color: widget.iconColor ?? TDTheme.of(context).whiteColor1,
      ),
    );
  }

  Widget _getRight() {
    if(widget.rightItemBuilder != null) {
      return widget.rightItemBuilder!(context, _index - 1);
    }
    return Visibility(
      visible: widget.deleteBtn ?? false,
      child: GestureDetector(
        onTap: () {
          if(widget.images.length == 1 && !(widget.ignoreDeleteError ?? false)) {
            throw FlutterError('images must not be empty');
          }
          widget.images.removeAt(_index - 1);
          widget.onDelete?.call(_index - 1);
          setState(() {
            if(_index > 1) {
              _index--;
            }
          });
        },
        child: Icon(
          TDIcons.delete,
          color: widget.iconColor ?? TDTheme.of(context).whiteColor1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media =  MediaQuery.of(context);
    var safeAreaHeight = media.padding.top;
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: widget.bgColor ?? TDTheme.of(context).fontGyColor1,
          ),
        ),
        Positioned(
          top: safeAreaHeight,
          bottom: 0,
          left: 0,
          right: 0,
          child: Swiper(
            index: _index - 1,
            loop: widget.loop ?? true,
            autoplay: widget.autoplay ?? false,
            duration: widget.duration ?? kDefaultAutoplayTransactionDuration,
            itemBuilder: (BuildContext context, int index) {
              var image = widget.images[index];
              return GestureDetector(
                onTap: () => widget.onTap?.call(index),
                onLongPress: () => widget.onLongPress?.call(index),
                child: _getImage(image),
              );
            },
            itemCount: widget.images.length,
            onIndexChanged: (index) {
              if ((widget.showIndex ?? false) || widget.labels != null) {
                setState(() {
                  _index = index + 1;
                });
              }
              widget.onIndexChange?.call(index);
            },
          ),
        ),
        SafeArea(
          child: Container(
            color: widget.navBarBgColor ?? const Color(0x66000000),
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _getLeft(),
                Expanded(
                  flex: 1,
                  child: _getPageTitle(),
                ),
                _getRight(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
