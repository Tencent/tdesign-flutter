part of 'notice_bar_page.dart';

extension _NoticeBarStatusModule on TNoticeBarPage {
  ExampleModule get _noticeBarStatusModule => const ExampleModule(
    title: '组件状态',
    children: [
      ExampleItem(
        desc: '公告栏类型有普通（info）、警示（warning）、成功（success）、错误（error）',
        builder: _themeNoticeBars,
      ),
    ],
  );
}
