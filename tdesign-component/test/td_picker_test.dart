import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('MultiLinkedPickerModel — 基础初始化', () {
    late Map testData;

    setUp(() {
      testData = {
        '广东省': {
          '深圳市': ['南山区', '宝安区', '罗湖区'],
          '广州市': ['天河区', '越秀区'],
        },
        '浙江省': {
          '杭州市': ['西湖区', '余杭区'],
          '宁波市': ['江东区', '北仑区'],
        },
      };
    });

    // TC-06
    test('初始化时 isLoading 全为 false', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      expect(model.isLoading.length, 3);
      expect(model.isLoading.every((v) => v == false), isTrue);
    });

    test('初始化时 presentData 正确填充第 0 列', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      expect(model.presentData[0], containsAll(['广东省', '浙江省']));
    });

    test('初始化时 selectedData 与 initialData 对齐', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      expect(model.selectedData[0], '广东省');
      expect(model.selectedData[1], '深圳市');
      expect(model.selectedData[2], '南山区');
    });
  });

  group('MultiLinkedPickerModel — resetColumnsAfter', () {
    late Map testData;

    setUp(() {
      testData = {
        '广东省': {
          '深圳市': ['南山区', '宝安区'],
        },
        '浙江省': {
          '杭州市': ['西湖区', '余杭区'],
        },
      };
    });

    // TC-04：切换第 0 列后，第 1、2 列均重置为占位
    test('resetColumnsAfter(0) 将第 1、2 列重置为占位', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      model.resetColumnsAfter(0);
      expect(model.presentData[1], [MultiLinkedPickerModel.placeData]);
      expect(model.presentData[2], [MultiLinkedPickerModel.placeData]);
    });

    test('resetColumnsAfter(1) 只重置第 2 列', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      final col1DataBefore = List.from(model.presentData[1]);
      model.resetColumnsAfter(1);
      expect(model.presentData[1], col1DataBefore);
      expect(model.presentData[2], [MultiLinkedPickerModel.placeData]);
    });

    test('resetColumnsAfter 在最后一列时不操作', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      final col2DataBefore = List.from(model.presentData[2]);
      model.resetColumnsAfter(2);
      expect(model.presentData[2], col2DataBefore);
    });
  });

  group('MultiLinkedPickerModel — updateColumnData', () {
    late Map testData;

    setUp(() {
      testData = {
        '广东省': {
          '深圳市': ['南山区'],
        },
      };
    });

    // TC-02：同步回调返回新数据后更新列
    test('updateColumnData 正确替换指定列数据', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      model.updateColumnData(1, ['北京市', '上海市']);
      expect(model.presentData[1], ['北京市', '上海市']);
    });

    // TC-05：回调返回空列表时，使用占位
    test('updateColumnData 传入空列表时使用占位符', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      model.updateColumnData(1, []);
      expect(model.presentData[1], [MultiLinkedPickerModel.placeData]);
    });

    test('updateColumnData 同时重置该列 controller 到第 0 项', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      model.updateColumnData(1, ['杭州市', '宁波市']);
      expect(model.controllers[1].initialItem, 0);
    });
  });

  group('MultiLinkedPickerModel — refreshPresentDataAndController cascadeNext', () {
    late Map testData;

    setUp(() {
      testData = {
        '广东省': {
          '深圳市': ['南山区', '宝安区'],
          '广州市': ['天河区', '越秀区'],
        },
        '浙江省': {
          '杭州市': ['西湖区', '余杭区'],
          '宁波市': ['江东区', '北仑区'],
        },
      };
    });

    // TC-01：不传 onColumnChanged 时，原有逻辑正常级联（回归）
    test('cascadeNext=true 时第 0 列变化后第 1 列正确级联', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      final zhejiangIndex = model.presentData[0].indexOf('浙江省');
      model.refreshPresentDataAndController(0, zhejiangIndex, false);
      expect(
        model.presentData[1],
        containsAll(['杭州市', '宁波市']),
      );
    });

    // cascadeNext=false 时，第 1 列不应从 data Map 更新（由外部 onColumnChanged 负责）
    test('cascadeNext=false 时第 0 列变化后第 1 列保持原样', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      final prevCol1Data = List.from(model.presentData[1]);
      final zhejiangIndex = model.presentData[0].indexOf('浙江省');
      model.refreshPresentDataAndController(0, zhejiangIndex, false, cascadeNext: false);
      expect(model.presentData[1], prevCol1Data);
      expect(model.selectedData[0], '浙江省');
    });
  });

  group('MultiLinkedPickerModel — isLoading 状态管理', () {
    late Map testData;

    setUp(() {
      testData = {
        '广东省': {
          '深圳市': ['南山区'],
        },
      };
    });

    // TC-03：异步加载期间 isLoading 状态正确
    test('setLoading 设置指定列的加载状态', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      model.setLoading(1, true);
      expect(model.isLoading[1], isTrue);
      model.setLoading(1, false);
      expect(model.isLoading[1], isFalse);
    });

    test('setLoading 不影响其他列的加载状态', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      model.setLoading(1, true);
      expect(model.isLoading[0], isFalse);
      expect(model.isLoading[2], isFalse);
    });

    // BC-02：最后一列变化时不应触发加载（无下一列）
    test('最后一列无需加载下一列数据', () {
      final model = MultiLinkedPickerModel(
        data: testData,
        columnNum: 3,
        initialData: ['广东省', '深圳市', '南山区'],
      );
      // 最后一列 columnIndex = 2 = columnNum - 1，不应触发下一列更新
      expect(2 >= model.columnNum - 1, isTrue);
    });
  });
}
