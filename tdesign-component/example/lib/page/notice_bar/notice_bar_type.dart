part of 'notice_bar_page.dart';

extension _NoticeBarTypeModule on TNoticeBarPage {
  ExampleModule get _noticeBarTypeModule => const ExampleModule(
    title: '组件类型',
    children: [
      ExampleItem(desc: '纯文字的公告栏', builder: _textNoticeBar),
      ExampleItem(desc: '带图标的公告栏', builder: _iconNoticeBar),
      ExampleItem(desc: '带关闭的公告栏', builder: _closeNoticeBar),
      ExampleItem(desc: '带入口的公告栏', builder: _entranceNoticeBar),
      ExampleItem(desc: '自定义样式的公告栏', builder: _customNoticeBar),
      ExampleItem(desc: '自定义内容的公告栏', builder: _customContentNoticeBar),
    ],
  );
}
