import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/demo.dart';


class TDPickerPage extends StatefulWidget {
  const TDPickerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDPickerPageState();
}

class _TDPickerPageState extends State<TDPickerPage> {
  String selected_1 = '';
  List<String> data_1 = ['广州市', '韶关市', '深圳市', '珠海区', '汕头市'];
  String selected_2 = '';
  String selected_3 = '';
  List<List<String>> data_2 = [];
  String selected_4 = '';
  Map data_3 = {
    '广东省': {
      '深圳市': ['南山区南山区南山区南山区南山区', '宝安区', '罗湖区', '福田区'],
      '佛山市': [''],
      '广州市广州市广州市广州市广州市广州市广州市广州市广州市广州市广州市': ['花都区']
    },
    '广东省2': {
      '深圳市': ['南山区南山区南山区南山区南山区', '罗湖区', '福田区'],
      '广州市广州市广州市广州市广州市广州市广州市广州市广州市广州市广州市': ['花都区']
    },
    '重庆市': {
      '重庆市重庆市重庆市重庆市重庆市重庆市重庆市': ['九龙坡区', '江北区'],
    },
    '浙江省浙江省浙江省浙江省浙江省浙江省浙江省浙江省': {
      '杭州市': ['西湖区', '余杭区', '萧山区'],
      '宁波市': ['江东区', '北仑区', '奉化市']
    },
    '香港': {
      '香港': ['九龙城区', '黄大仙区', '离岛区', '湾仔区']
    },
  };

  Map data_test = {
    '广东省': {
      '深圳市': ['南山区', '宝安区', '罗湖区', '福田区'],
      '广州市': ['天河区', '越秀区', '白云区', '花都区'],
      '佛山市': ['顺德区', '南海区', '禅城区']
    },
    '浙江省': {
      '杭州市': ['西湖区', '余杭区', '萧山区'],
      '宁波市': ['江东区', '北仑区', '奉化市'],
      '温州市': ['鹿城区', '瑞安市', '乐清市']
    },
    '江苏省': {
      '南京市': ['玄武区', '秦淮区', '建邺区', '鼓楼区', '浦口区', '栖霞区', '雨花台区', '江宁区', '六合区', '溧水区', '高淳区'],
      '无锡市': ['梁溪区', '锡山区', '惠山区', '滨湖区', '新吴区'],
      '徐州市': ['鼓楼区', '云龙区', '贾汪区', '泉山区', '铜山区'],
      '常州市': ['天宁区', '钟楼区', '新北区', '武进区', '金坛区'],
      '苏州市': ['姑苏区', '虎丘区', '吴中区', '相城区', '吴江区'],
      '南通市': ['崇川区', '港闸区', '通州区'],
      '连云港市': ['连云区', '海州区', '赣榆区'],
      '淮安市': ['淮安区', '淮阴区', '清江浦区', '洪泽区'],
      '盐城市': ['亭湖区', '盐都区', '大丰区', '建湖县'],
      '扬州市': ['广陵区', '邗江区', '江都区'],
      '镇江市': ['京口区', '润州区', '丹徒区'],
      '泰州市': ['海陵区', '高港区', '姜堰区'],
      '宿迁市': ['宿城区', '宿豫区']
    },
    '山东省': {
      '济南市': ['历下区', '市中区', '天桥区'],
      '青岛市': ['市南区', '市北区', '黄岛区'],
      '烟台市': ['芝罘区', '莱山区']
    },
    '河南省': {
      '郑州市': ['金水区', '中原区', '惠济区'],
      '洛阳市': ['老城区', '西工区'],
      '开封市': ['龙亭区', '顺河区']
    },
    '河北省': {
      '石家庄市': ['长安区', '桥西区', '裕华区'],
      '唐山市': ['路南区', '路北区'],
      '邯郸市': ['丛台区', '邯山区']
    },
    '四川省': {
      '成都市': ['锦江区', '青羊区', '武侯区'],
      '绵阳市': ['涪城区', '游仙区'],
      '德阳市': ['旌阳区', '罗江区']
    },
    '湖南省': {
      '长沙市': ['岳麓区', '开福区', '天心区'],
      '株洲市': ['天元区', '芦淞区'],
      '湘潭市': ['雨湖区', '岳塘区']
    },
    '湖北省': {
      '武汉市': ['江汉区', '武昌区', '洪山区'],
      '宜昌市': ['西陵区', '伍家岗区'],
      '襄阳市': ['樊城区', '襄城区']
    },
    '安徽省': {
      '合肥市': ['庐阳区', '蜀山区', '包河区'],
      '芜湖市': ['镜湖区', '弋江区'],
      '马鞍山市': ['花山区', '雨山区']
    },
    '江西省': {
      '南昌市': ['东湖区', '西湖区', '青山湖区'],
      '九江市': ['濂溪区', '浔阳区'],
      '赣州市': ['章贡区', '南康区']
    },
    '福建省': {
      '福州市': ['鼓楼区', '台江区', '仓山区'],
      '厦门市': ['思明区', '湖里区'],
      '泉州市': ['丰泽区', '鲤城区']
    },
    '云南省': {
      '昆明市': ['五华区', '盘龙区'],
      '大理市': ['大理古城', '下关镇'],
      '丽江市': ['古城区', '玉龙县']
    },
    '贵州省': {
      '贵阳市': ['云岩区', '南明区'],
      '遵义市': ['红花岗区', '汇川区'],
      '安顺市': ['西秀区', '平坝区']
    },
    '陕西省': {
      '西安市': ['碑林区', '莲湖区', '雁塔区'],
      '咸阳市': ['秦都区', '渭城区'],
      '宝鸡市': ['渭滨区', '金台区']
    },
    '山西省': {
      '太原市': ['小店区', '迎泽区'],
      '大同市': ['平城区', '云冈区'],
      '运城市': ['盐湖区', '永济市']
    },
    '辽宁省': {
      '沈阳市': ['和平区', '沈河区', '皇姑区'],
      '大连市': ['中山区', '西岗区'],
      '鞍山市': ['铁东区', '铁西区']
    },
    '吉林省': {
      '长春市': ['朝阳区', '南关区'],
      '吉林市': ['船营区', '昌邑区'],
      '延边州': ['延吉市', '敦化市']
    },
    '黑龙江省': {
      '哈尔滨市': ['道里区', '南岗区', '香坊区'],
      '齐齐哈尔市': ['龙沙区', '铁锋区'],
      '大庆市': ['萨尔图区', '龙凤区']
    },
    '北京市': {
      '北京市': ['朝阳区', '海淀区', '东城区', '西城区']
    },
    '上海市': {
      '上海市': ['浦东新区', '黄浦区', '静安区']
    },
    '重庆市': {
      '重庆市': ['渝中区', '江北区', '九龙坡区', '南岸区']
    },
    '香港': {
      '香港': ['九龙城区', '黄大仙区', '湾仔区', '离岛区']
    },
    '澳门': {
      '澳门': ['花地玛堂区', '圣安多尼堂区', '大堂区', '风顺堂区']
    }
  };


  String selected_5 = '';

  @override
  void initState() {
    var list = <String>[];
    for(var i = 2022; i >= 2000; i--) {
      list.add('${i}年');
    }
    data_2.add(list);
    data_2.add(['春', '夏', '秋', '冬']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(),
      desc: '用于一组预设数据中的选择。',
      exampleCodeGroup: 'picker',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础选择器--地区', builder: buildArea),
            ExampleItem(desc: '基础选择器--时间', builder: buildTime),
            ExampleItem(desc: '基础选择器--地区--联动', builder: buildMultiArea),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '带标题选择器', builder: buildAreaWithTitle),
            ExampleItem(desc: '无标题选择器', builder: buildAreaWithoutTitle),
          ],
        )
      ],
      test: [
        ExampleItem(
            desc: '自定义left/right text', builder: buildCustomLeftRightText),
        ExampleItem(
            desc: '级联选择保持下一级选项', builder: buildKeepMultiArea),
      ],
    );
  }

  @Demo(group: 'picker')
  Widget buildArea(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiPicker(context, title: '选择地区',
            onConfirm: (selected) {
              setState(() {
                selected_1 = '${data_1[selected[0]]}';
              });
              Navigator.of(context).pop();
            }, data: [data_1]);
      },
      child: buildSelectRow(context, selected_1, '选择地区'),
    );
  }

  @Demo(group: 'picker')
  Widget buildTime(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiPicker(context, title: '选择时间',
            onConfirm: (selected) {
              setState(() {
                selected_2 = '${data_2[0][selected[0]]} ${data_2[1][selected[1]]}';
              });
              Navigator.of(context).pop();
            }, data: data_2);
      },
      child: buildSelectRow(context, selected_2, '选择时间'),
    );
  }

  @Demo(group: 'picker')
  Widget buildMultiArea(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiLinkedPicker(context,
          title: '选择地区',
          onConfirm: (selected) {
            setState(() {
              selected_3 = '${selected[0]} ${selected[1]} ${selected[2]}';
            });
            Navigator.of(context).pop();
          },
          columnNum: 3,
          data: data_test, // ← 这里添加了必需的 data 参数
          initialData: ['广东省', '深圳市', '南山区'],

        );
      },
      child: buildSelectRow(context, selected_3, '选择地区'),
    );
  }

  @Demo(group: 'picker')
  Widget buildAreaWithTitle(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiPicker(context, title: '选择地区',
            onConfirm: (selected) {
              setState(() {
                selected_4 = '${data_1[selected[0]]}';
              });
              Navigator.of(context).pop();
            }, data: [data_1]);
      },
      child: buildSelectRow(context, selected_4, '带标题选择器'),
    );
  }

  @Demo(group: 'picker')
  Widget buildAreaWithoutTitle(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiPicker(context, title: '',
            onConfirm: (selected) {
              setState(() {
                selected_5 = '${data_1[selected[0]]}';
              });
              Navigator.of(context).pop();
            }, data: [data_1]);
      },
      child: buildSelectRow(context, selected_5, '无标题选择器'),
    );
  }

  @Demo(group: 'picker')
  Widget buildCustomLeftRightText(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            TDPicker.showMultiPicker(context,
                leftText: '自定义取消',
                rightText: '自定义确认',
                title: '基础选择器', onConfirm: (selected) {
                  setState(() {
                    selected_5 = '${data_1[selected[0]]}';
                  });
                  Navigator.of(context).pop();
                }, data: [data_1]);
          },
          child: buildSelectRow(context, selected_5, '基础选择器'),
        ),
        GestureDetector(
          onTap: () {
            TDPicker.showMultiLinkedPicker(context,
                leftText: '自定义取消',
                rightText: '自定义确认',
                title: '联动选择器', onConfirm: (selected) {
                  setState(() {
                    selected_3 = '${selected[0]} ${selected[1]} ${selected[2]}';
                  });
                  Navigator.of(context).pop();
                }, data: data_3, columnNum: 3, initialData: ['浙江省', '杭州市', '西湖区']);
          },
          child: buildSelectRow(context, selected_3, '联动选择器'),
        )
      ],
    );
  }

  @Demo(group: 'picker')
  Widget buildKeepMultiArea(BuildContext context) {
    return GestureDetector(
      onTap: (){
        TDPicker.showMultiLinkedPicker(context, title: '选择地区',
            onConfirm: (selected) {
              setState(() {
                selected_3 = '${selected[0]} ${selected[1]} ${selected[2]}';
              });
              Navigator.of(context).pop();
            },
            data: data_3,
            columnNum: 3,
            keepSameSelection: true,
            initialData: ['广东省', '深圳市', '罗湖区']);
      },
      child: buildSelectRow(context, selected_3, '选择地区'),
    );
  }

  Widget buildSelectRow(BuildContext context, String output, String title) {
    return Container(
      color: TDTheme.of(context).whiteColor1,
      height: 56,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: TDText(title, font: TDTheme.of(context).fontBodyLarge,),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Row(
                  children: [
                    Expanded(child: TDText(
                      output,
                      font: TDTheme.of(context).fontBodyLarge,
                      textColor: TDTheme.of(context).fontGyColor3.withOpacity(0.4),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Icon(
                        TDIcons.chevron_right,
                        color: TDTheme.of(context).fontGyColor3.withOpacity(0.4),),
                    ),
                  ],
                ),
              )),
            ],
          ),
          const TDDivider(margin: EdgeInsets.only(left: 16, ),)
        ],
      ),
    );
  }
}
