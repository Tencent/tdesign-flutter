import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

typedef MultiCascaderCallback = void Function(List<MultiCascaderListModel> selected);

class TDMultiCascader extends StatefulWidget {
  /// 选择器标题
  final String? title;

  /// 标题样式
  final TextStyle? titleStyle;

  /// 展示风格 可选项：step/tab
  final String? theme;

  ///	每级展示的次标题
  final List<String>? subTitles;

  /// 选择器List的视窗高度，默认200
  final double cascaderHeight;

  /// 若为null表示全部从零开始
  final List<int>? initialIndexes;

  /// 选择器的数据源
  final List<Map> data;

  /// 初始化数据
  final String? initialData;

  /// 背景颜色
  final Color? backgroundColor;

  /// 顶部圆角
  final double? topRadius;

  /// 是否开启字母排序
  final bool isLetterSort;

  /// 关闭按钮文本
  final String? closeText;

  /// 选择器关闭按钮回调
  final Function? onClose;

  /// 值发生变更时触发
  final MultiCascaderCallback onChange;
  const TDMultiCascader(
      {super.key,
      this.title,
      this.titleStyle,
      this.theme,
      this.subTitles,
      required this.data,
      required this.cascaderHeight,
      this.initialIndexes,
      this.initialData,
      this.backgroundColor,
      this.topRadius,
      this.closeText,
      this.isLetterSort = false,
      this.onClose,
      required this.onChange});

  @override
  State<TDMultiCascader> createState() => _TDMultiCascaderState();
}

class _TDMultiCascaderState extends State<TDMultiCascader> with TickerProviderStateMixin {
  List<MultiCascaderListModel> _tabListData = [];

  /// 当前tab选中的值
  String? _selectTabValue = '';

  /// 当前tab索引
  int _currentTabIndex = 0;

  /// tab 层级
  int _level = 0;

  /// 缓存列表数据
  List<MultiCascaderListModel> _listData = [];

  /// tab选中对应的列表数据
  List<MultiCascaderListModel> _selectListData = [];

  final ScrollController _scrollListController = ScrollController();

  @override
  void initState() {
    super.initState();
    List.generate(widget.data.length, (index) {
      MultiCascaderListModel item = MultiCascaderListModel(
        labelFun: ()=>widget.data[index]['label'],
        value: widget.data[index]['value'],
        segmentValue: widget.data[index]['segmentValue'],
        level: 0,
      );
      _listData.add(item);

      if (widget.data[index]['children'] != null && widget.data[index]['children'].length > 0) {
        _buildRecursiveList(1, widget.data[index]['value'], widget.data[index]['children']);
      }
    });
    if (widget.isLetterSort) {
      _listDataSegmenter();
    }
    _selectListData = _listData.where((element) => element.level == 0).toList();
    _tabListData.add(MultiCascaderListModel(
      labelFun: ()=>context.resource.cascadeLabel,
    ));
    if (widget.initialData != null) {
      _tabListData.clear();
      _initLocation(widget.initialData!);
      _currentTabIndex = _tabListData.length - 1;
      _level = _currentTabIndex;
      _tabListData = _tabListData.reversed.toList();
      _selectTabValue = widget.initialData;
      _selectListData =
          _listData.where((element) => element.parentValue == _tabListData[_currentTabIndex].parentValue).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;

    return Container(
      width: maxWidth,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? TDTheme.of(context).whiteColor1,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.topRadius ?? TDTheme.of(context).radiusExtraLarge),
          topRight: Radius.circular(widget.topRadius ?? TDTheme.of(context).radiusExtraLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildTitle(context), _buildTabThemeBox(context), Expanded(child: _buildContentBox(context))],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    /// 该方法在开始处必须调用父类的方法
    super.didChangeDependencies();
    Future.delayed(Duration(seconds: 1), () {
      List.generate(_selectListData.length, (index) {
        if (_selectListData[index].value == _selectTabValue) {
          _scrollToListIndex(index);
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollListController.dispose();
    super.dispose();
  }

  void _initLocation(String value) {
    List<MultiCascaderListModel> list = _listData.where((element) => element.value == value).toList();
    if (list.isNotEmpty) {
      _tabListData.add(list[0]);
      if (list[0].parentValue != null) {
        _initLocation(list[0].parentValue!);
      }
    }
  }

  void _listDataSegmenter() {
    _listData.sort((a, b) {
      if (a.segmentValue == null || b.segmentValue == null) {
        return 0;
      } else {
        return a.segmentValue!.toLowerCase().compareTo(b.segmentValue!.toLowerCase());
      }
    });
  }

  void _buildRecursiveList(int depth, String parentValue, List<Map> data) {
    List.generate(data.length, (index) {
      MultiCascaderListModel item = MultiCascaderListModel(
        labelFun: ()=>data[index]['label'],
        value: data[index]['value'],
        parentValue: parentValue,
        segmentValue: data[index]['segmentValue'],
        level: depth,
      );
      _listData.add(item);
      if (data[index]['children'] != null && data[index]['children'].length > 0) {
        _buildRecursiveList(depth + 1, data[index]['value'], data[index]['children']);
      }
    });
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      height: 58,
      child: Stack(
        children: [
          widget.title == null
              ? Container()
              : Center(
                  child: TDText(
                    widget.title,
                    style: widget.titleStyle ??
                        TextStyle(
                            fontSize: TDTheme.of(context).fontTitleLarge!.size,
                            fontWeight: FontWeight.w700,
                            color: TDTheme.of(context).fontGyColor1),
                  ),
                ),
          Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                  onTap: () {
                    if (widget.onClose != null) {
                      widget.onClose!();
                    }
                  },
                  child: Container(
                    height: 58,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 16),
                      child: widget.closeText == null
                          ? Icon(
                              TDIcons.close,
                              color: TDTheme.of(context).fontGyColor1,
                            )
                          : TDText(
                              widget.closeText,
                              style: TextStyle(
                                  fontSize: TDTheme.of(context).fontTitleMedium!.size,
                                  color: TDTheme.of(context).fontGyColor1),
                            ),
                    ),
                  ))),
        ],
      ),
    );
  }

  Widget _buildTabThemeBox(BuildContext context) {
    String them = widget.theme ?? 'step';
    return them == 'step' ? _buildStepBox(context) : _buildTabBox(context);
  }

  Widget _buildStepBox(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.1), width: 0.5))),
        padding: EdgeInsets.only(bottom: 11),
        width: maxWidth,
        child: ListView(
            shrinkWrap: true,
            children: List.generate(_tabListData.length, (index) {
              MultiCascaderListModel tabItem = _tabListData[index];
              return GestureDetector(
                  onTap: () {
                    _tabListChange(index);
                  },
                  child: Container(
                    height: 38,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // 圆和线
                          height: 8,
                          child: LeftLineWidget(
                            isCircleFill: tabItem.value == null && tabItem.value != _selectTabValue ? false : true,
                            isShowTopLine: index == 0 ? false : true,
                          ),
                        ),
                        Expanded(
                          child: TDText(
                            '${_tabListData[index].label}',
                            style: TextStyle(
                                fontSize: 14,
                                color: _currentTabIndex == index ? TDTheme.of(context).brandNormalColor : Colors.black),
                            fontWeight: _currentTabIndex == index ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2, right: 16),
                          child: Icon(
                            TDIcons.chevron_right,
                            color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ));
            })));
  }

  Widget _buildTabBox(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 48,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.1), width: 0.5))),
      width: maxWidth,
      child: TDCustomTab(
        tabs: List.generate(_tabListData.length, (index) {
          return _tabListData[index].label ?? '';
        }),
        initialIndex: _currentTabIndex,
        onTap: (int index) {
          _tabListChange(index);
        },
      ),
    );
  }

  Widget _buildContentBox(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    return Container(
        width: maxWidth,
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.subTitles != null)
              Container(
                  height: 50,
                  padding: EdgeInsets.only(
                    top: 20,
                  ),
                  child: TDText(
                    widget.subTitles![_level],
                    style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.4)),
                    font: TDTheme.of(context).fontTitleSmall,
                  ) //,
                  ),
            Expanded(
                child: PageView(
              scrollDirection: Axis.horizontal,
              reverse: false,
              controller: PageController(initialPage: 1, keepPage: false),
              children: List.generate(1, (index) {
                return ListView.builder(
                  controller: _scrollListController,
                  itemCount: _selectListData.length,
                  itemBuilder: (context, index) {
                    MultiCascaderListModel item = _selectListData[index];
                    MultiCascaderListModel preItem = index == 0 ? MultiCascaderListModel() : _selectListData[index - 1];
                    return GestureDetector(
                      onTap: () {
                        int level = 0;
                        if (_tabListData.length > 2 && _currentTabIndex == 0) {
                          _tabListData.clear();
                          _tabListData.add(MultiCascaderListModel(
                            labelFun: ()=>context.resource.cascadeLabel,
                          ));
                        }
                        if (item.level != null) {
                          level = item.level!;
                        }

                        if (widget.subTitles != null && widget.subTitles!.length - 1 > _level) {
                          _level = level + 1;
                        }
                        List isList = _tabListData.where((element) => element.level == item.level).toList();
                        if (isList.isNotEmpty) {
                          _tabListData.removeAt(level);
                        }
                        setState(() {
                          _tabListData.insert(level, item);
                          _selectTabValue = item.value;
                          //下一级查询
                          _getChildrenListData(level + 1, item.value!);
                        });
                      },
                      child: Container(
                          height: 56,
                          decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (item.segmentValue != null)
                                      SizedBox(
                                        width: 32,
                                        child: item.segmentValue != preItem.segmentValue
                                            ? TDText(
                                                '${item.segmentValue}',
                                                font: Font(size: 16, lineHeight: 24),
                                              )
                                            : null,
                                      ),
                                    TDText(
                                      '${item.label}',
                                      font: Font(size: 16, lineHeight: 24),
                                    ),
                                  ],
                                ),
                              ),
                              if (_selectTabValue == item.value)
                                Icon(
                                  TDIcons.check,
                                  color: TDTheme.of(context).brandNormalColor,
                                )
                            ],
                          )),
                    );
                  },
                );
              }),
            ))
          ],
        ));
  }

  void _tabListChange(int index) {
    MultiCascaderListModel tabItem = _tabListData[index];
    _currentTabIndex = index;
    if (tabItem.level != null) {
      _selectTabValue = tabItem.value;
    }
    if (index < _tabListData.length - 1) {
      _getFindListData(level: tabItem.level!, value: tabItem.value);
    } else {
      int cruIndex = index > 0 ? index - 1 : index;
      _getFindListData(level: index, parentValue: _tabListData[cruIndex].value);
    }
    _level = index;
    setState(() {});
  }

  void _getChildrenListData(int level, String value) {
    //查询层级数据
    var selectLevelData = _listData.where((element) => element.level == (level)).toList();
    //判断下级是否存在
    if (selectLevelData.isNotEmpty) {
      //获取下级数据
      var childList = selectLevelData.where((element) => element.parentValue == value).toList();
      _selectListData = childList;
      _currentTabIndex += 1;
    } else {
      var result = _tabListData.where((element) => element.label != context.resource.cascadeLabel).toList();
      widget.onChange(result);
      Navigator.of(context).pop();
    }
  }

  /// 查询列表数据
  void _getFindListData({required int level, String? parentValue, String? value}) {
    List<MultiCascaderListModel> list = [];
    //查询层级数据
    List<MultiCascaderListModel> selectLevelData = _listData.where((element) => element.level == (level)).toList();
    if (selectLevelData.isNotEmpty) {
      if (level == 0) {
        list = selectLevelData;
      } else if (value != null) {
        list = selectLevelData.where((element) => element.value == value).toList();
      } else {
        list = selectLevelData.where((element) => element.parentValue == parentValue).toList();
      }
      _selectListData = list;
    }
  }

  /// 定位选项在列表中位置
  void _scrollToListIndex(int index) async {
    // 计算列表中特定索引的位置
    double scrollTo = index * 56.0; // 每个列表项的高度是56.0
    _scrollListController.animateTo(
      scrollTo,
      duration: Duration(milliseconds: 1),
      curve: Curves.ease,
    );
  }
}

class LeftLineWidget extends StatelessWidget {
  /// 是否实心圆
  final bool isCircleFill;

  /// 线条颜色
  final Color? topLineColor;

  /// 是否显示圆圈上方线条
  final bool isShowTopLine;

  const LeftLineWidget({this.isShowTopLine = false, this.topLineColor, this.isCircleFill = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: 16,
      child: CustomPaint(
        painter: LeftLinePainter(isShowTopLine: isShowTopLine, topLineColor: topLineColor ?? TDTheme.of(context).brandNormalColor, isCircleFill: isCircleFill),
      ),
    );
  }
}

class LeftLinePainter extends CustomPainter {
  static const double _topHeight = 16;

  // static const Color _lightColor = Color.fromRGBO(0, 82, 217, 1);

  /// 是否实心圆
  final bool isCircleFill;

  /// 线条颜色
  final Color topLineColor;

  /// 是否显示圆圈上方线条
  final bool isShowTopLine;

  const LeftLinePainter({required this.topLineColor, required this.isShowTopLine, required this.isCircleFill});

  @override
  void paint(Canvas canvas, Size size) {
    double lineWidth = 1;
    double topHeight = size.height / 2;
    double centerX = size.width / 2;
    Paint linePain = Paint();
    linePain.color = Colors.transparent;
    linePain.strokeWidth = lineWidth;
    linePain.strokeCap = StrokeCap.square;
    canvas.drawLine(Offset(centerX, 0), Offset(centerX, topHeight), linePain);
    Paint circlePaint = Paint();
    circlePaint.color = topLineColor;
    circlePaint.strokeWidth = 1;
    circlePaint.style = isCircleFill ? PaintingStyle.fill : PaintingStyle.stroke;
    linePain.color = isShowTopLine ? (topLineColor) : Colors.transparent;
    canvas.drawLine(Offset(centerX, -size.height), Offset(centerX, -size.height - _topHeight), linePain);
    canvas.drawCircle(Offset(centerX, topHeight), centerX * 0.5, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MultiCascaderListModel {
  String? Function()? labelFun;
  String? get label => labelFun?.call();

  String? value;

  /// 父级值
  String? parentValue;

  /// 分组值
  String? segmentValue;

  int? level;
  MultiCascaderListModel({this.labelFun, this.value, this.parentValue, this.level, this.segmentValue});
}
