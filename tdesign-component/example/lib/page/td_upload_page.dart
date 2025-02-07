import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TDUploadPage extends StatefulWidget {
  const TDUploadPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TDUploadState();
}

class TDUploadState extends State<TDUploadPage> {
  final List<TDUploadFile> files1 = [];
  final List<TDUploadFile> files2 = [
    TDUploadFile(key: 1, remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png'),
    TDUploadFile(key: 2, remotePath: 'https://tdesign.gtimg.com/demo/images/example2.png'),
    TDUploadFile(key: 3, remotePath: 'https://tdesign.gtimg.com/demo/images/example3.png'),
  ];
  final List<TDUploadFile> files3 = [
    TDUploadFile(
        key: 1,
        status: TDUploadFileStatus.loading,
        loadingText: '上传中...',
        remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png'),
    TDUploadFile(
        key: 2,
        status: TDUploadFileStatus.loading,
        progress: 68,
        remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png'),
  ];
  final List<TDUploadFile> files4 = [
    TDUploadFile(
        key: 1,
        status: TDUploadFileStatus.retry,
        retryText: '重新上传',
        remotePath: 'https://tdesign.gtimg.com/demo/images/example1.png'),
  ];
  final List<TDUploadFile> files5 = [
    TDUploadFile(
        key: 1,
        status: TDUploadFileStatus.error,
        errorText: '上传失败',
        remotePath: 'https://tdesign.gtimg.com/demo/images/example4.png'),
  ];
  final List<TDUploadFile> files6 = [];

  void onValueChanged(List<TDUploadFile> fileList, List<TDUploadFile> value, TDUploadType event) {
    switch (event) {
      case TDUploadType.add:
        setState(() {
          fileList.addAll(value);
        });
        break;
      case TDUploadType.remove:
        setState(() {
          fileList.removeWhere((element) => element.key == value[0].key);
        });
        break;
      case TDUploadType.replace:
        setState(() {
          final firstReplaceFile = value.first;
          final index = fileList.indexWhere((file) => file.key == firstReplaceFile.key);
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
      title: tdTitle(),
      exampleCodeGroup: 'upload',
      desc: '用于相册读取或拉起拍照的图片上传功能。${PlatformUtil.isWeb ? "Web端不支持读取本地图片,请前往移动端体验。" : ""}',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '单选上传', builder: _uploadSingle),
            ExampleItem(desc: '单选上传(替换)', builder: _uploadSingleWithReplace),
            ExampleItem(desc: '多选上传', builder: _uploadMultiple),
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
        ExampleItem(ignoreCode: true, desc: '单选快速替换, 大小和图形测试', builder: _uploadSingleWithReplace),
      ],
    );
  }

  Widget wrapDemoContainer(String title, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TDText(
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
        child: TDUpload(
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
        child: TDUpload(
          files: files6,
          width: 60,
          height: 60,
          type: TDUploadBoxType.circle,
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
        child: TDUpload(
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
  Widget _uploadLoading(BuildContext context) {
    return wrapDemoContainer('上传图片',
        child: TDUpload(
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
        child: TDUpload(
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
        child: TDUpload(
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
}
