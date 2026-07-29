import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TActionSheetPage extends StatelessWidget {
  const TActionSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '在文件、图片和分享场景中选择下一步操作。',
      exampleCodeGroup: 'action_sheet',
      children: [
        ExampleModule(title: '真实使用场景', children: [
          ExampleItem(desc: '文件操作列表', builder: _list),
          ExampleItem(desc: '分享方式宫格', builder: _grid),
          ExampleItem(desc: '图片编辑分组', builder: _group),
        ]),
      ],
    );
  }

  Widget _trigger({required String label, required VoidCallback onPressed}) {
    return TButton(child: Text(label), onPressed: onPressed);
  }

  @ExampleCode(group: 'action_sheet')
  Widget _list(BuildContext context) {
    return _trigger(
      label: '管理项目',
      onPressed: () => TActionSheet.showList(
        context,
        subtitle: '报告-2026-Q3.pdf',
        items: [
          TActionSheetItem(label: '编辑内容', icon: const Icon(TIcons.edit)),
          TActionSheetItem(label: '复制链接', icon: const Icon(TIcons.link)),
          TActionSheetItem(label: '移动到文件夹', icon: const Icon(TIcons.folder)),
          TActionSheetItem(
            label: '删除文件',
            icon: const Icon(TIcons.delete),
            disabled: true,
          ),
        ],
        onChanged: (item, _) =>
            TToast.showText('已选择：${item.label}', context: context),
      ),
    );
  }

  @ExampleCode(group: 'action_sheet')
  Widget _grid(BuildContext context) {
    Widget shareIcon(
      IconData icon, {
      required Color backgroundColor,
      required Color foregroundColor,
    }) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 24, color: foregroundColor),
      );
    }

    return _trigger(
      label: '分享照片',
      onPressed: () => TActionSheet.showGrid(
        context,
        subtitle: '选择分享方式',
        items: [
          TActionSheetItem(
            label: '消息',
            icon: shareIcon(
              TIcons.chat,
              backgroundColor: context.tTheme.successLightColor,
              foregroundColor: context.tTheme.successNormalColor,
            ),
          ),
          TActionSheetItem(
            label: '邮件',
            icon: shareIcon(
              TIcons.mail,
              backgroundColor: context.tTheme.brandLightColor,
              foregroundColor: context.tTheme.brandNormalColor,
            ),
          ),
          TActionSheetItem(
            label: '复制链接',
            icon: shareIcon(
              TIcons.link,
              backgroundColor: context.tTheme.bgColorComponent,
              foregroundColor: context.tTheme.textColorPrimary,
            ),
          ),
          TActionSheetItem(
            label: '保存到本地',
            icon: shareIcon(
              TIcons.download,
              backgroundColor: context.tTheme.warningLightColor,
              foregroundColor: context.tTheme.warningNormalColor,
            ),
          ),
          TActionSheetItem(
            label: '生成二维码',
            icon: shareIcon(
              TIcons.qrcode,
              backgroundColor: context.tTheme.brandLightColor,
              foregroundColor: context.tTheme.brandNormalColor,
            ),
          ),
          TActionSheetItem(
            label: '更多',
            icon: shareIcon(
              TIcons.more,
              backgroundColor: context.tTheme.bgColorComponent,
              foregroundColor: context.tTheme.textColorSecondary,
            ),
          ),
        ],
        onChanged: (item, _) =>
            TToast.showText('已分享到：${item.label}', context: context),
      ),
    );
  }

  @ExampleCode(group: 'action_sheet')
  Widget _group(BuildContext context) {
    Widget actionIcon(
      IconData icon, {
      required Color backgroundColor,
      required Color foregroundColor,
    }) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 24, color: foregroundColor),
      );
    }

    return _trigger(
      label: '编辑图片',
      onPressed: () => TActionSheet.showGroup(
        context,
        items: [
          TActionSheetItem(
            label: '旋转',
            group: '图片处理',
            icon: actionIcon(
              TIcons.rotate,
              backgroundColor: context.tTheme.bgColorComponent,
              foregroundColor: context.tTheme.textColorPrimary,
            ),
          ),
          TActionSheetItem(
            label: '裁剪',
            group: '图片处理',
            icon: actionIcon(
              TIcons.cut,
              backgroundColor: context.tTheme.bgColorComponent,
              foregroundColor: context.tTheme.textColorPrimary,
            ),
          ),
          TActionSheetItem(
            label: '滤镜',
            group: '图片处理',
            icon: actionIcon(
              TIcons.filter,
              backgroundColor: context.tTheme.bgColorComponent,
              foregroundColor: context.tTheme.textColorPrimary,
            ),
          ),
          TActionSheetItem(
            label: '分享',
            group: '分享与导出',
            icon: actionIcon(
              TIcons.share,
              backgroundColor: context.tTheme.brandLightColor,
              foregroundColor: context.tTheme.brandNormalColor,
            ),
          ),
          TActionSheetItem(
            label: '保存副本',
            group: '分享与导出',
            icon: actionIcon(
              TIcons.download,
              backgroundColor: context.tTheme.warningLightColor,
              foregroundColor: context.tTheme.warningNormalColor,
            ),
          ),
          TActionSheetItem(
            label: '删除图片',
            group: '危险操作',
            icon: actionIcon(
              TIcons.delete,
              backgroundColor: context.tTheme.errorLightColor,
              foregroundColor: context.tTheme.errorNormalColor,
            ),
          ),
        ],
        onChanged: (item, _) =>
            TToast.showText('已选择：${item.label}', context: context),
      ),
    );
  }
}
