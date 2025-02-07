import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../tdesign_flutter.dart';

enum TDUploadMediaType {
  image, // 图片
  video, // 视频
}

enum TDUploadValidatorError {
  overSize, // 超出文件大小
  overQuantity, // 超出文件数量限制
}

enum TDUploadFileStatus {
  success, // 成功
  loading, // 加载中
  error, // 失败
  retry, // 重试
}

enum TDUploadType {
  add, // 添加
  remove, // 删除
  replace, // 替换
}

enum TDUploadBoxType {
  roundedSquare, // 圆角方形
  circle, // 圆形
}

class TDUploadFile {
  TDUploadFile(
      {required this.key,
      this.remotePath,
      this.assetPath,
      this.file,
      this.progress,
      this.status = TDUploadFileStatus.success,
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
  TDUploadFileStatus status;
}

typedef TDUploadErrorEvent = void Function(Object e);
typedef TDUploadClickEvent = void Function(int value);
typedef TDUploadValueChangedEvent = void Function(List<TDUploadFile> files, TDUploadType type);
typedef TDUploadValidatorEvent = void Function(TDUploadValidatorError e);

class TDUpload extends StatefulWidget {
  const TDUpload(
      {Key? key,
      this.max = 0,
      this.mediaType = const [TDUploadMediaType.image, TDUploadMediaType.video],
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
      this.type = TDUploadBoxType.roundedSquare,
      this.enabledReplaceType = false})
      : super(key: key);

  /// 控制展示的文件列表
  final List<TDUploadFile> files;

  /// 用于控制文件上传数量，0为不限制，仅在multiple为true时有效
  final int max;

  /// 支持上传的文件类型，图片或视频
  final List<TDUploadMediaType> mediaType;

  /// 图片大小限制，单位为KB
  final double? sizeLimit;

  /// 是否多选上传，默认false
  final bool multiple;

  /// 监听取消上传
  final VoidCallback? onCancel;

  /// 监听获取资源错误
  final TDUploadErrorEvent? onError;

  /// 监听文件校验出错
  final TDUploadValidatorEvent? onValidate;

  /// 监听点击图片位
  final TDUploadClickEvent? onClick;

  /// 监听文件超过最大数量
  final VoidCallback? onMaxLimitReached;

  /// 监听添加, 删除和替换media事件
  final TDUploadValueChangedEvent? onChange;

  /// 图片宽度
  final double? width;

  /// 图片高度
  final double? height;

  /// Box类型
  final TDUploadBoxType type;

  /// 是否启用replace功能
  final bool? enabledReplaceType;

  @override
  State<TDUpload> createState() => _TDUploadState();
}

class _TDUploadState extends State<TDUpload> {
  List<TDUploadFile> fileList = [];

  bool get canUpload => widget.multiple ? (widget.max == 0 ? true : fileList.length < widget.max) : fileList.isEmpty;
  final ImagePicker _picker = ImagePicker();

  // 类型映射
  final Map<TDUploadBoxType, TDImageType> _imageTypeMap = {
    TDUploadBoxType.roundedSquare: TDImageType.roundedSquare,
    TDUploadBoxType.circle: TDImageType.circle,
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
        widget.onValidate!(TDUploadValidatorError.overQuantity);
      } else {
        throw Exception("Initial file count exceeds the maximum limit");
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
        if (widget.mediaType.contains(TDUploadMediaType.image)) {
          media = await _picker.pickImage(source: ImageSource.gallery);
        } else {
          media = await _picker.pickVideo(source: ImageSource.gallery);
        }
        if (media != null) {
          medias = [media];
        }
      }

      if (widget.max > 0 && fileList.length + medias.length > widget.max) {
        if (widget.onMaxLimitReached != null) {
          widget.onMaxLimitReached!();
        } else if (widget.onValidate != null) {
          widget.onValidate!(TDUploadValidatorError.overQuantity);
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

    var originMaxKeys = fileList.isEmpty ? 0 : fileList.map((file) => file.key).reduce(max);

    var newFiles = <TDUploadFile>[];
    for (var i = 0; i < files.length; i++) {
      newFiles.add(TDUploadFile(key: originMaxKeys + i + 1, file: File(files[i].path), assetPath: files[i].path));
    }

    if (widget.onChange != null) {
      widget.onChange!(newFiles, TDUploadType.add);
    }
  }

  // 替换资源
  void replaceMedia(List<XFile> files, TDUploadFile oldFile) async {
    if (files.isEmpty || files.length != 1) {
      return;
    }

    var result = await validateResources(files);

    if (result != null) {
      if (widget.onValidate != null) {
        widget.onValidate!(result);
      }
      return;
    }

    var newFile = TDUploadFile(key: oldFile.key, file: File(files[0].path), assetPath: files[0].path);

    if (widget.onChange != null) {
      widget.onChange!([newFile], TDUploadType.replace);
    }
  }

  // 校验资源
  Future<TDUploadValidatorError?> validateResources(List<XFile> files, [bool? multiple]) async {
    TDUploadValidatorError? error;

    // 多选逻辑，优选从参数获取
    var isMultiple = widget.multiple;
    if (multiple != null) {
      isMultiple = multiple;
    }

    if (isMultiple && widget.max > 0) {
      var remain = widget.max - fileList.length;

      if (files.length > remain) {
        error = TDUploadValidatorError.overQuantity;
        return error;
      }
    }

    for (var file in files) {
      if (widget.sizeLimit != null) {
        var fileSize = (await file.length()) * 1024;

        if (fileSize > widget.sizeLimit!) {
          error = TDUploadValidatorError.overSize;
          break;
        }
      }
    }

    return error;
  }

  // 删除资源
  void onDelete(TDUploadFile file) {
    if (widget.onChange != null) {
      widget.onChange!([file], TDUploadType.remove);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 8,
        runSpacing: 16,
        children: [
          ...fileList.map((file) => _buildImageBox(context, file)).toList(),
          _buildUploadBox(context, shouldDisplay: canUpload, onTap: () async {
            if (!canUpload) {
              return;
            }

            final files = await getMediaFromPicker(widget.multiple);
            extractImageList(files);
          }),
        ],
      ),
    );
  }

  Widget _buildUploadBox(BuildContext context, {void Function()? onTap, bool shouldDisplay = true}) {
    return Visibility(
        visible: shouldDisplay,
        child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: widget.type == TDUploadBoxType.circle
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: TDTheme.of(context).grayColor1,
                    )
                  : BoxDecoration(color: TDTheme.of(context).grayColor1, borderRadius: BorderRadius.circular(6)),
              child: const Center(
                  child: Icon(
                TDIcons.add,
                color: Color.fromRGBO(0, 0, 0, 0.4),
                size: 28,
              )),
            )));
  }

  Widget _buildImageBox(BuildContext context, TDUploadFile file) {
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
          TDImage(
            key: Key(file.assetPath ?? ''),
            width: widget.width,
            height: widget.height,
            imgUrl: file.remotePath,
            // assetUrl: file.assetPath,
            imageFile: file.file,
            type: _imageTypeMap[widget.type] ?? TDImageType.roundedSquare,
          ),
          Visibility(visible: file.status != TDUploadFileStatus.success, child: _buildShadowBox(file)),
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
                      decoration: widget.type == TDUploadBoxType.circle
                          ? const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                            )
                          : const BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.6),
                              borderRadius:
                                  BorderRadius.only(bottomLeft: Radius.circular(6), topRight: Radius.circular(6))),
                      child: const Center(
                          child: Icon(
                        TDIcons.close,
                        size: 16,
                        color: Colors.white,
                      )),
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _buildShadowBox(TDUploadFile file) {
    var displayText = '';
    switch (file.status) {
      case TDUploadFileStatus.loading:
        displayText = file.progress != null ? '${file.progress!}%' : file.loadingText;
        break;
      case TDUploadFileStatus.retry:
        displayText = file.retryText;
        break;
      case TDUploadFileStatus.error:
        displayText = file.errorText;
        break;
      default:
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: widget.type == TDUploadBoxType.circle
          ? const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(0, 0, 0, 0.4),
            )
          : BoxDecoration(color: const Color.fromRGBO(0, 0, 0, 0.4), borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: file.status == TDUploadFileStatus.loading,
                child: const TDLoading(
                  size: TDLoadingSize.large,
                  icon: TDLoadingIcon.circle,
                  iconColor: Colors.white,
                ),
              ),
              Visibility(
                  visible: file.status == TDUploadFileStatus.retry || file.status == TDUploadFileStatus.error,
                  child: Icon(
                    file.status == TDUploadFileStatus.retry ? TDIcons.refresh : TDIcons.close_circle,
                    size: 24,
                    color: Colors.white,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: TDText(
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
