import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/demo.dart';
import '../../base/example_widget.dart';
class TDCascaderPage extends StatefulWidget {
  const TDCascaderPage({super.key});

  @override
  State<TDCascaderPage> createState() => _TDCascaderPageState();
}

class _TDCascaderPageState extends State<TDCascaderPage> {
  String _selected_1 = '';
  String? _initData;
  List<Map>  _data=
  [
    {
      "label": '北京市',
      "value": '110000',
      "children": [
        {
          "value": '110100',
          "label": '北京市',
          "children": [
            { "value": '110101', "label": '东城区' },
            { "value": '110102', "label": '西城区' },
            { "value": '110105', "label": '朝阳区' },
            { "value": '110106', "label": '丰台区' },
            { "value": '110107', "label": '石景山区' },
            { "value": '110108', "label": '海淀区' },
            { "value": '110109', "label": '门头沟区' },
          ],
        },
      ],
    },
    {
      "label": '天津市',
      "value": '120000',
      "children": [
        {
          "value": '120100',
          "label": '天津市',
          "children": [
            { "value": '120101', "label": '和平区' },
            { "value": '120102', "label": '河东区' },
            { "value": '120103', "label": '河西区' },
            { "value": '120104', "label": '南开区' },
            { "value": '120105', "label": '河北区' },
            { "value": '120106', "label": '红桥区' },
            { "value": '120110', "label": '东丽区' },
            { "value": '120111', "label": '西青区' },
            { "value": '120112', "label": '津南区' },
          ],
        },
      ],
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
           color: TDTheme.of(context).whiteColor1,
           child: ExamplePage(
             title: tdTitle(),
             exampleCodeGroup: 'cascader',
             desc: '用于多层级数据的逐级选择',
             children: [
                     ExampleModule(title: '组件类型',
                         children: [
                           ExampleItem(
                               desc: '垂直级联选择器',
                               ignoreCode: true,
                               builder: _buildVerticalCascader),
                      ])
             ],
             test: [],
           ),
    );
  }
  @Demo(group: 'cascader')
  Widget _buildVerticalCascader(BuildContext context){
      return  GestureDetector(
          onTap: (){

            TDCascader.showMultiCascader(context,title: '选择地址',
                data: _data,
                initialData:_initData,
                theme: 'tab',
                onChange: (List<MultiCascaderListModel> selectData){
                setState(() {
                 List result=[];
                 int len=selectData.length;
                 _initData=selectData[len-1].value!;
                 selectData.forEach((element) {
                   result.add(element.label);
                 });
                 _selected_1=result.join('/');
               });
            },onClose: (){
              Navigator.of(context).pop();
            });
          },
          child: _buildSelectRow(context, _selected_1, '选择地区'),
      );
   }
  Widget _buildSelectRow(BuildContext context, String output, String title) {
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
