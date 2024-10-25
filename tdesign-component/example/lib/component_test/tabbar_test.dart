import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter/src/util/string_util.dart';
// import 'package:xjy_study/utils/color_util.dart';

class StudyDetail extends StatefulWidget {
  const StudyDetail({super.key});

  @override
  State createState() => _StudyDetailState();
}

class _StudyDetailState extends State with SingleTickerProviderStateMixin {
  final List _tabs = const ['待上课时', '已上课时'];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getQueryParams();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getQueryParams() {
    // final ModalRoute<Object?>? currentRoute = ModalRoute.of(context);
    // if (currentRoute != null) {
    //   final Map<String, dynamic> params = currentRoute.settings.arguments as Map<String, dynamic>;
    //   print('aa=${params}');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('课程详情'),
        leadingWidth: 40.w,
      ),
      body: ExtendedNestedScrollView(
        onlyOneScrollInBody: true,
        physics: ClampingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: _CourseItemDetail(),
            )
          ];
        },
        body: Column(
          children: [
            TDTabBar(
                controller: _tabController,
                height: 44.h,
                backgroundColor: Colors.white,
                indicatorColor: TDTheme.of().brandNormalColor,
                // labelColor:TDTheme.of().brandNormalColor,
                unselectedLabelStyle: TextStyle(fontSize: 12.sp, color: Colors.red),
                labelStyle: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w500),
                indicatorWidth: 16.w,
                showIndicator: true,
                tabs: _tabs
                    .map((e) => TDTab(
                  text: '$e',
                ))
                    .toList()),
            Expanded(
                child: TDTabBarView(
                    isSlideSwitch: true,
                    controller: _tabController,
                    children: _tabs
                        .map((e) => Center(
                      child: Text('data$e'),
                    ))
                        .toList()))
          ],
        ),
      ),
    );
  }
}

/// 课程详情描述
class _CourseItemDetail extends StatelessWidget {
  const _CourseItemDetail();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 8.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 3.h),
                height: 16.h,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    gradient: LinearGradient(colors: [
                      Color(0xFFFFB442),
                      Color(0xFFFF9A00),
                    ])),
                child: Text(
                  '数学',
                  style: TextStyle(color: Colors.white, fontSize: 12.sp, height: 1.h),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                  child: Text(
                    '集合图形离开撒娇的案例三等奖集合图形离开撒娇的案例',
                    style: TextStyle(
                        color: TDTheme.of().fontGyColor1,
                        fontSize: 14.sp,
                        overflow: TextOverflow.ellipsis,
                        height: 1.5.h),
                    maxLines: 2,
                  ))
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.h, bottom: 12.h),
            child: Text(
              '2020年8月15日开始，共20节课',
              style: TextStyle(fontSize: 12.sp, color: TDTheme.of().fontGyColor2,),
            ),
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28.w),
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                '某某老师',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 12.sp,
                    color: TDTheme.of().fontGyColor2,
                    overflow: TextOverflow.ellipsis),
              )
            ],
          )
        ],
      ),
    );
  }
}