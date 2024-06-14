import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_theme.dart';
import '../icon/td_icons.dart';
import '../image/td_image.dart';
import '../navbar/td_nav_bar.dart';

typedef OnIndexChange = Function(int index);
typedef OnClose = Function(int index);
typedef OnDelete = Function(int index);

class ImageViewerWidget extends StatefulWidget {
  const ImageViewerWidget({
    Key? key,
    this.closeBtn,
    this.deleteBtn,
    required this.images,
    this.showIndex,
    this.defaultIndex,
    this.onIndexChange,
    this.onClose,
    this.onDelete,
    this.modalBarrierColor,
  }) : super(key: key);

  final bool? closeBtn;
  final bool? deleteBtn;
  final List<dynamic> images;
  final bool? showIndex;
  final int? defaultIndex;
  final OnIndexChange? onIndexChange;
  final OnClose? onClose;
  final OnDelete? onDelete;
  final Color? modalBarrierColor;

  @override
  State<StatefulWidget> createState() {
    return _ImageViewerWidgetState();
  }
}

class _ImageViewerWidgetState extends State<ImageViewerWidget> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    _index = widget.defaultIndex ?? 0;
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: widget.modalBarrierColor,
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return TDImage(
                imgUrl: widget.images[index],
                type: TDImageType.fitWidth,
              );
            },
            itemCount: widget.images.length,
          ),
        ),
        SafeArea(
          child: TDNavBar(
            backgroundColor: Colors.transparent,
            useDefaultBack: false,
            title: (widget.showIndex ?? false) ? '$_index / ${widget.images.length}' : '',
            titleColor: TDTheme.of(context).whiteColor1,
            leftBarItems: [
              TDNavBarItem(
                  icon: TDIcons.close,
                  iconColor: TDTheme.of(context).whiteColor1,
                  action: () {
                    Navigator.of(context).pop();
                    widget.onClose?.call(_index);
                  })
            ],
          ),
        ),
      ],
    );
  }
}
