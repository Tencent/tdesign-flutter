part of 'notice_bar_page.dart';

extension _NoticeBarScrollableModule on TNoticeBarPage {
  ExampleModule get _noticeBarScrollableModule => const ExampleModule(
    title: '可滚动公告栏',
    children: [
      ExampleItem(
        desc: '可滚动公告栏有水平（horizontal）和垂直（vertical）',
        builder: _scrollingNoticeBars,
      ),
    ],
  );
}
