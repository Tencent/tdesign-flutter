import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

import '../../../tdesign_flutter.dart';

enum TUploadMediaType {
  image, // 图片
  video, // 视频
}

enum TUploadValidatorError {
  overSize, // 超出文件大小
  overQuantity, // 超出文件数量限制
}

enum TUploadFileStatus {
  success, // 成功
  loading, // 加载中
  error, // 失败
  retry, // 重试
}

enum TUploadType {
  add, // 添加
  remove, // 删除
  replace, // 替换
}

enum TUploadBoxType {
  roundedSquare, // 圆角方形
  circle, // 圆形
}

class TUploadFile {
  TUploadFile(
      {required this.key,
      this.remotePath,
      this.assetPath,
      this.file,
      this.progress,
      this.status = TUploadFileStatus.success,
      this.loadingText = 'Loading...',
      this.retryText = 'Re-Upload',
      this.errorText = 'Error',
      this.canDelete = true});

  final int key;
  final String? remotePath;
  final String? assetPath;
  final File? file;
  final bool canDelete;
  final int? progress;
  final String loadingText;
  final String retryText;
  final String errorText;
  TUploadFileStatus status;
}

typedef TUploadErrorEvent = void Function(Object e);
typedef TUploadClickEvent = void Function(int value);
typedef TUploadValueChangedEvent = void Function(
    List<TUploadFile> files, TUploadType type);
typedef TUploadValidatorEvent = void Function(TUploadValidatorError e);

class TUpload extends StatefulWidget {
  const TUpload(
      {Key? key,
      this.max = 0,
      this.mediaType = const [TUploadMediaType.image, TUploadMediaType.video],
      this.sizeLimit,
      this.onCancel,
      this.onError,
      this.onValidate,
      this.onClick,
      this.onMaxLimitReached,
      required this.files,
      this.onChange,
      this.multiple = false,
      this.width = 80.0,
      this.height = 80.0,
      this.type = TUploadBoxType.roundedSquare,
      this.disabled = false,
      this.enabledReplaceType = false,
      this.wrapSpacing,
      this.wrapRunSpacing,
      this.wrapAlignment,
      this.onUploadTap})
      : super(key: key);

  /// 控制展示的文件列表
  final List<TUploadFile> files;

  /// 用于控制文件上传数量，0为不限制，仅在multiple为true时有效
  final int max;

  /// 支持上传的文件类型，图片或视频
  final List<TUploadMediaType> mediaType;

  /// 图片大小限制，单位为KB
  final double? sizeLimit;

  /// 是否多选上传，默认false
  final bool multiple;

  /// 监听取消上传
  final VoidCallback? onCancel;

  /// 监听获取资源错误
  final TUploadErrorEvent? onError;

  /// 监听文件校验出错
  final TUploadValidatorEvent? onValidate;

  /// 监听点击图片位
  final TUploadClickEvent? onClick;

  /// 监听文件超过最大数量
  final VoidCallback? onMaxLimitReached;

  /// 监听添加, 删除和替换media事件
  final TUploadValueChangedEvent? onChange;

  /// 图片宽度
  final double? width;

  /// 图片高度
  final double? height;

  /// Box类型
  final TUploadBoxType type;

  /// 是否启用replace功能
  final bool? enabledReplaceType;

  ///是否禁用
  final bool? disabled;

  /// 多图布局时的 spacing
  final double? wrapSpacing;

  /// 多图布局时的 runSpacing
  final double? wrapRunSpacing;

  /// 多图对齐方式
  final WrapAlignment? wrapAlignment;

  ///自定义upload按钮事件
  final VoidCallback? onUploadTap;

  @override
  State<TUpload> createState() => _TUploadState();
}

class _TUploadState extends State<TUpload> {
  List<TUploadFile> fileList = [];

  bool get canUpload => widget.multiple
      ? (widget.max == 0 ? true : fileList.length < widget.max)
      : fileList.isEmpty;
  final ImagePicker _picker = ImagePicker();

  // 类型映射
  final Map<TUploadBoxType, TImageType> _imageTypeMap = {
    TUploadBoxType.roundedSquare: TImageType.roundedSquare,
    TUploadBoxType.circle: TImageType.circle,
  };

  @override
  initState() {
    super.initState();
    fileList = widget.files;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateInitialFiles();
    });
  }

  void _validateInitialFiles() {
    if (widget.max > 0 && fileList.length > widget.max) {
      if (widget.onMaxLimitReached != null) {
        widget.onMaxLimitReached!();
      } else if (widget.onValidate != null) {
        widget.onValidate!(TUploadValidatorError.overQuantity);
      } else {
        throw Exception('Initial file count exceeds the maximum limit');
      }
    }
  }

  // 获取相册照片或视频
  Future<List<XFile>> getMediaFromPicker(bool isMultiple) async {
    if (widget.mediaType.isEmpty) {
      return [];
    }

    var medias = <XFile>[];
    try {
      if (isMultiple) {
        medias = await _picker.pickMultiImage();
      } else {
        XFile? media;
        if (widget.mediaType.contains(TUploadMediaType.image)) {
          media = await _picker.pickImage(source: ImageSource.gallery);
        } else {
          media = await _picker.pickVideo(source: ImageSource.gallery);
        }
        if (media != null) {
          medias = [media];
        }
      }

      if (widget.max > 0 &&
          isMultiple &&
          fileList.length + medias.length > widget.max) {
        if (widget.onMaxLimitReached != null) {
          widget.onMaxLimitReached!();
        } else if (widget.onValidate != null) {
          widget.onValidate!(TUploadValidatorError.overQuantity);
        }
        return [];
      }
    } on PlatformException catch (e) {
      if (widget.onError != null) {
        widget.onError!(e);
      }
    } catch (e) {
      if (widget.onError != null) {
        widget.onError!(e);
      }
    }

    return medias;
  }

  // 处理获取到的资源
  void extractImageList(List<XFile> files) async {
    if (!canUpload || files.isEmpty) {
      return;
    }

    var result = await validateResources(files);

    if (result != null) {
      if (widget.onValidate != null) {
        widget.onValidate!(result);
      }
      return;
    }

    var originMaxKeys =
        fileList.isEmpty ? 0 : fileList.map((file) => file.key).reduce(max);

    var newFiles = <TUploadFile>[];
    for (var i = 0; i < files.length; i++) {
      newFiles.add(TUploadFile(
          key: originMaxKeys + i + 1,
          file: File(files[i].path),
          assetPath: files[i].path));
    }

    if (widget.onChange != null) {
      widget.onChange!(newFiles, TUploadType.add);
    }
  }

  // 替换资源
  void replaceMedia(List<XFile> files, TUploadFile oldFile) async {
    if (files.isEmpty || files.length != 1) {
      return;
    }

    var result = await validateResources(files, false);

    if (result != null) {
      if (widget.onValidate != null) {
        widget.onValidate!(result);
      }
      return;
    }

    var newFile = TUploadFile(
        key: oldFile.key, file: File(files[0].path), assetPath: files[0].path);

    if (widget.onChange != null) {
      widget.onChange!([newFile], TUploadType.replace);
    }
  }

  // 校验资源
  Future<TUploadValidatorError?> validateResources(List<XFile> files,
      [bool? multiple]) async {
    TUploadValidatorError? error;

    // 多选逻辑，优选从参数获取
    var isMultiple = multiple ?? widget.multiple;

    if (isMultiple && widget.max > 0) {
      var remain = widget.max - fileList.length;

      if (files.length > remain) {
        error = TUploadValidatorError.overQuantity;
        return error;
      }
    }

    for (var file in files) {
      if (widget.sizeLimit != null) {
        final fileSize = await file.length();
        final sizeLimitInBytes = widget.sizeLimit! * 1024;
        if (fileSize > sizeLimitInBytes) {
          error = TUploadValidatorError.overSize;
          break;
        }
      }
    }

    return error;
  }

  // 删除资源
  void onDelete(TUploadFile file) {
    if (widget.onChange != null) {
      widget.onChange!([file], TUploadType.remove);
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = fileList.map((f) => _buildImageBox(context, f)).toList();
    if (canUpload) {
      children.add(
        _buildUploadBox(context, shouldDisplay: canUpload, onTap: () async {
          if (widget.disabled!) {
            return;
          }
          if (widget.onUploadTap != null) {
            widget.onUploadTap!();
          } else {
            final files = await getMediaFromPicker(widget.multiple);
            extractImageList(files);
          }
        }),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: widget.wrapSpacing ?? 8,
        runSpacing: widget.wrapRunSpacing ?? 16,
        alignment: widget.wrapAlignment ?? WrapAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildUploadBox(BuildContext context,
      {void Function()? onTap, bool shouldDisplay = true}) {
    return Visibility(
        visible: shouldDisplay,
        child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: widget.type == TUploadBoxType.circle
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: TTheme.of(context).bgColorSecondaryContainer,
                    )
                  : BoxDecoration(
                      color: TTheme.of(context).bgColorSecondaryContainer,
                      borderRadius: BorderRadius.circular(
                          TTheme.of(context).radiusDefault)),
              child: Center(
                  child: Icon(
                TIcons.add,
                color: TTheme.of(context).textColorPlaceholder,
                size: 28,
              )),
            )));
  }

  Widget _buildImageBox(BuildContext context, TUploadFile file) {
    return GestureDetector(
      onTap: () async {
        if (widget.onClick != null) {
          widget.onClick!(file.key);
        }
        // 替换资源
        if (widget.enabledReplaceType ?? false) {
          final files = await getMediaFromPicker(false);
          replaceMedia(files, file);
        }
      },
      child: Stack(
        children: [
          TImage(
            key: Key(file.assetPath ?? ''),
            width: widget.width,
            height: widget.height,
            imgUrl: file.remotePath,
            imageFile: file.file,
            assetUrl: file.file == null ? file.assetPath : null,
            type: _imageTypeMap[widget.type] ?? TImageType.roundedSquare,
          ),
          Visibility(
              visible: file.status != TUploadFileStatus.success,
              child: _buildShadowBox(context, file)),
          Visibility(
              visible: file.canDelete,
              child: Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      onDelete(file);
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: widget.type == TUploadBoxType.circle
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: TTheme.of(context).textDisabledColor,
                            )
                          : BoxDecoration(
                              color: TTheme.of(context).textDisabledColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      TTheme.of(context).radiusDefault),
                                  topRight: Radius.circular(
                                      TTheme.of(context).radiusDefault))),
                      child: const Center(
                          child: Icon(
                        TIcons.close,
                        size: 16,
                        color: Colors.white,
                      )),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _buildShadowBox(BuildContext context, TUploadFile file) {
    var displayText = '';
    switch (file.status) {
      case TUploadFileStatus.loading:
        displayText =
            file.progress != null ? '${file.progress!}%' : file.loadingText;
        break;
      case TUploadFileStatus.retry:
        displayText = file.retryText;
        break;
      case TUploadFileStatus.error:
        displayText = file.errorText;
        break;
      default:
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.type == TUploadBoxType.circle
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: TTheme.of(context).fontGyColor3,
            )
          : BoxDecoration(
              color: TTheme.of(context).fontGyColor3,
              borderRadius:
                  BorderRadius.circular(TTheme.of(context).radiusDefault)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: file.status == TUploadFileStatus.loading,
                child: const TLoading(
                  size: TLoadingSize.large,
                  icon: TLoadingIcon.circle,
                  iconColor: Colors.white,
                ),
              ),
              Visibility(
                  visible: file.status == TUploadFileStatus.retry ||
                      file.status == TUploadFileStatus.error,
                  child: Icon(
                    file.status == TUploadFileStatus.retry
                        ? TIcons.refresh
                        : TIcons.close_circle,
                    size: 24,
                    color: Colors.white,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: TText(
                  displayText,
                  textColor: Colors.white,
                  style: const TextStyle(fontSize: 12, height: 1.67),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
