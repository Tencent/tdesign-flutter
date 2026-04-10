import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TUploadPage extends StatefulWidget {
  const TUploadPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TUploadState();
}

class TUploadState extends State<TUploadPage> {
  final List<TUploadFile> files1 = [];
  final List<TUploadFile> files2 = [
    TUploadFile(
        key: 1,
        remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png'),
    TUploadFile(
        key: 2,
        remotePath: 'https://tdesign.gtimg.com/demo/images/example2.png'),
    TUploadFile(
        key: 3,
        remotePath: 'https://tdesign.gtimg.com/demo/images/example3.png'),
    TUploadFile(
        key: 4,
        remotePath: 'https://tdesign.gtimg.com/demo/images/example4.png'),
  ];
  final List<TUploadFile> files3 = [
    TUploadFile(
        key: 1,
        status: TUploadFileStatus.loading,
        loadingText: '上传中...',
        remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png'),
    TUploadFile(
        key: 2,
        status: TUploadFileStatus.loading,
        progress: 68,
        remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png'),
  ];
  final List<TUploadFile> files4 = [
    TUploadFile(
        key: 1,
        status: TUploadFileStatus.retry,
        retryText: '重新上传',
        remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png'),
  ];
  final List<TUploadFile> files5 = [
    TUploadFile(
        key: 1,
        status: TUploadFileStatus.error,
        errorText: '上传失败',
        remotePath: 'https://tdesign.gtimg.com/demo/images/example4.png'),
  ];
  final List<TUploadFile> files6 = [];
  final List<TUploadFile> files7 = [];

  void onUploadTap() {
    print('点击上传');
    setState(() {
      files7.add(TUploadFile(
          key: files7.length + 1,
          remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png'));
    });
  }

  void onValueChanged(List<TUploadFile> fileList, List<TUploadFile> value,
      TUploadType event) {
    switch (event) {
      case TUploadType.add:
        setState(() {
          fileList.addAll(value);
        });
        break;
      case TUploadType.remove:
        setState(() {
          fileList.removeWhere((element) => element.key == value[0].key);
        });
        break;
      case TUploadType.replace:
        setState(() {
          final firstReplaceFile = value.first;
          final index =
              fileList.indexWhere((file) => file.key == firstReplaceFile.key);
          if (index != -1) {
            fileList[index] = firstReplaceFile;
          }
        });
        break;
    }
  }

  void onClick(int key) {
    print('点击 $key');
  }

  void onCancel() {
    print('取消');
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'upload',
      desc:
          '用于相册读取或拉起拍照的图片上传功能。${PlatformUtil.isWeb ? "Web端不支持读取本地图片,请前往移动端体验。" : ""}',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '单选上传', builder: _uploadSingle),
            ExampleItem(desc: '单选上传(替换)', builder: _uploadSingleWithReplace),
            ExampleItem(desc: '多选上传', builder: _uploadMultiple),
            ExampleItem(desc: '自定义upload按钮事件', builder: _uploadTap),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(desc: '加载状态', builder: _uploadLoading),
            ExampleItem(desc: '重新上传', builder: _uploadRetry),
            ExampleItem(desc: '上传失败', builder: _uploadError),
          ],
        ),
      ],
      test: [
        ExampleItem(
            ignoreCode: true,
            desc: '单选快速替换, 大小和图形测试',
            builder: _uploadSingleWithReplace),
        ExampleItem(
            ignoreCode: true, desc: '上传文件大小限制，10KB', builder: _uploadSizeLimit),
      ],
    );
  }

  Widget wrapDemoContainer(String title, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: TTheme.of(context).bgColorContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TText(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 16,
          ),
          child
        ],
      ),
    );
  }

  @Demo(group: 'upload')
  Widget _uploadSingle(BuildContext context) {
    return wrapDemoContainer('单选上传',
        child: TUpload(
          files: files1,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files1, files, type)),
        ));
  }

  @Demo(group: 'upload')
  Widget _uploadSingleWithReplace(BuildContext context) {
    return wrapDemoContainer('单选上传(替换)',
        child: TUpload(
          files: files6,
          width: 60,
          height: 60,
          type: TUploadBoxType.circle,
          enabledReplaceType: true,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files6, files, type)),
        ));
  }

  @Demo(group: 'upload')
  Widget _uploadMultiple(BuildContext context) {
    return wrapDemoContainer('多选上传',
        child: TUpload(
          files: files2,
          multiple: true,
          max: 9,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files2, files, type)),
        ));
  }

  @Demo(group: 'upload')
  Widget _uploadTap(BuildContext context) {
    return wrapDemoContainer('自定义upload按钮事件',
        child: TUpload(
          files: files7,
          multiple: true,
          max: 9,
          onUploadTap: onUploadTap,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files7, files, type)),
        ));
  }

  @Demo(group: 'upload')
  Widget _uploadLoading(BuildContext context) {
    return wrapDemoContainer('上传图片',
        child: TUpload(
          files: files3,
          multiple: true,
          max: 9,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files3, files, type)),
        ));
  }

  @Demo(group: 'upload')
  Widget _uploadRetry(BuildContext context) {
    return wrapDemoContainer('上传图片',
        child: TUpload(
          files: files4,
          multiple: true,
          max: 9,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files4, files, type)),
        ));
  }

  @Demo(group: 'upload')
  Widget _uploadError(BuildContext context) {
    return wrapDemoContainer('上传图片',
        child: TUpload(
          files: files5,
          multiple: true,
          max: 9,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange: ((files, type) => onValueChanged(files5, files, type)),
        ));
  }

  @Demo(group: 'upload')
  Widget _uploadSizeLimit(BuildContext context) {
    return wrapDemoContainer('限制10KB',
        child: TUpload(
          files: files1,
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          sizeLimit: 10,
          onChange: ((files, type) => onValueChanged(files1, files, type)),
        ));
  }
}
