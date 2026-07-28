import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TForm、TFormItem 与 TFormField 组合示例。
class TFormPage extends StatefulWidget {
  const TFormPage({super.key});

  @override
  State<TFormPage> createState() => _TFormPageState();
}

class _TFormPageState extends State<TFormPage> {
  static const _regionItems = TPickerColumns([
    [
      TPickerOption(label: '广东', value: 'guangdong'),
      TPickerOption(label: '浙江', value: 'zhejiang'),
    ],
    [
      TPickerOption(label: '深圳', value: 'shenzhen'),
      TPickerOption(label: '杭州', value: 'hangzhou'),
    ],
  ]);

  static const _appointment = TDateTimePickerValue(
    year: 2026,
    month: 7,
    day: 28,
    hour: 10,
    minute: 30,
  );

  final _horizontalController = TFormController();
  final _verticalController = TFormController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _noteController = TextEditingController();

  String _gender = 'female';
  List<String> _interests = ['design'];
  bool _notifications = true;
  num _quantity = 2;
  double _progress = 60;
  double _rating = 3;
  List<Object?> _region = ['guangdong', 'shenzhen'];
  TDateTimePickerValue _selectedAppointment = _appointment;
  String _submittedLayout = '';
  Map<String, Object?> _submittedValues = const {};

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '组合常用输入组件，支持横向和纵向布局、校验、提交与重置。',
      exampleCodeGroup: 'form',
      children: [
        ExampleModule(
          title: '表单布局',
          children: [
            ExampleItem(desc: '横向布局：基础输入与选择', builder: _buildHorizontalForm),
            ExampleItem(desc: '纵向布局：数值、滚轮与日期输入', builder: _buildVerticalForm),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'form')
  Widget _buildHorizontalForm(BuildContext context) {
    return _buildForm(
      context,
      controller: _horizontalController,
      layout: TFormLayout.horizontal,
      children: [
        TFormField<String>(
          name: 'name',
          value: _nameController.text,
          onChanged: (_) => setState(() {}),
          required: true,
          requiredMessage: '请输入姓名',
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '姓名',
            child: TInput(
              controller: _nameController,
              hintText: '请输入姓名',
              onChanged: onChanged,
            ),
          ),
        ),
        TFormField<String>(
          name: 'password',
          value: _passwordController.text,
          onChanged: (_) => setState(() {}),
          required: true,
          requiredMessage: '请输入密码',
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '密码',
            help: '使用密码输入类型',
            child: TInput(
              controller: _passwordController,
              obscureText: true,
              hintText: '请输入密码',
              onChanged: onChanged,
            ),
          ),
        ),
        TFormField<String>(
          name: 'gender',
          value: _gender,
          onChanged: (value) => setState(() => _gender = value),
          required: true,
          requiredMessage: '请选择性别',
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '性别',
            child: TRadioGroup<String>(
              value: value,
              options: const [
                TRadioOption(value: 'female', label: '女'),
                TRadioOption(value: 'male', label: '男'),
              ],
              direction: Axis.horizontal,
              onChanged: onChanged,
            ),
          ),
        ),
        TFormField<List<String>>(
          name: 'interests',
          value: _interests,
          onChanged: (value) => setState(() => _interests = value),
          required: true,
          requiredMessage: '至少选择一项兴趣',
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '兴趣',
            child: TCheckboxGroup<String>(
              value: value,
              options: const [
                TCheckboxOption(value: 'design', label: '设计'),
                TCheckboxOption(value: 'code', label: '开发'),
                TCheckboxOption(value: 'product', label: '产品'),
              ],
              direction: Axis.horizontal,
              columns: 3,
              onChanged: onChanged,
            ),
          ),
        ),
        TFormField<bool>(
          name: 'notifications',
          value: _notifications,
          onChanged: (value) => setState(() => _notifications = value),
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '消息通知',
            help: '接收服务状态通知',
            child: TSwitch(value: value, onChanged: onChanged),
          ),
        ),
        TFormField<num>(
          name: 'quantity',
          value: _quantity,
          onChanged: (value) => setState(() => _quantity = value),
          rules: [
            (value) => value != null && value >= 1 && value <= 10
                ? null
                : '范围为 1 到 10',
          ],
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '数量',
            child:
                TStepper(value: value, min: 1, max: 10, onChanged: onChanged),
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'form')
  Widget _buildVerticalForm(BuildContext context) {
    return _buildForm(
      context,
      controller: _verticalController,
      layout: TFormLayout.vertical,
      children: [
        TFormField<String>(
          name: 'note',
          value: _noteController.text,
          onChanged: (_) => setState(() {}),
          required: true,
          requiredMessage: '请输入备注',
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '备注',
            child: TInput.multiline(
              controller: _noteController,
              maxLength: 100,
              hintText: '请输入备注',
              onChanged: onChanged,
            ),
          ),
        ),
        TFormField<double>(
          name: 'progress',
          value: _progress,
          onChanged: (value) => setState(() => _progress = value),
          rules: [
            (value) => value != null && value >= 0 && value <= 100
                ? null
                : '范围为 0 到 100',
          ],
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '进度',
            child: TSlider(
              value: value,
              min: 0,
              max: 100,
              divisions: 10,
              showThumbValue: true,
              onChanged: onChanged,
            ),
          ),
        ),
        TFormField<double>(
          name: 'rating',
          value: _rating,
          onChanged: (value) => setState(() => _rating = value),
          required: true,
          requiredMessage: '请选择评分',
          rules: [(value) => value == 0 ? '请选择评分' : null],
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '评分',
            child: TRate(value: value, allowHalf: true, onChanged: onChanged),
          ),
        ),
        TFormField<List<Object?>>(
          name: 'region',
          value: _region,
          onChanged: (value) => setState(() => _region = value),
          required: true,
          requiredMessage: '请选择地区',
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '地区',
            child: SizedBox(
              height: 160,
              child: TPicker(
                items: _regionItems,
                value: value,
                onChanged: (pickerValue) => onChanged?.call(pickerValue.values),
              ),
            ),
          ),
        ),
        TFormField<TDateTimePickerValue>(
          name: 'appointment',
          value: _selectedAppointment,
          onChanged: (value) => setState(() => _selectedAppointment = value),
          required: true,
          requiredMessage: '请选择预约时间',
          rules: [(value) => value?.year == null ? '请选择预约时间' : null],
          builder: (context, value, onChanged, errorText) => TFormItem(
            label: '预约时间',
            child: SizedBox(
              height: 160,
              child: TDateTimePicker(
                mode: DateTimePickerMode(
                  dateMode: DateMode.date,
                  timeMode: TimeMode.minute,
                ),
                value: value,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(
    BuildContext context, {
    required TFormController controller,
    required TFormLayout layout,
    required List<Widget> children,
  }) {
    final layoutLabel = layout == TFormLayout.horizontal ? '横向布局' : '纵向布局';
    return Theme(
      data: Theme.of(context).mergeExtension(
        TFormThemeData(
          layout: layout,
          showColon: layout == TFormLayout.horizontal,
          itemSpacing: layout == TFormLayout.vertical ? 8 : 0,
        ),
      ),
      child: Column(
        children: [
          if (_submittedLayout == layoutLabel && _submittedValues.isNotEmpty)
            _buildSubmittedResult(context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TForm(
              controller: controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSubmit: (values) => _showSubmittedValues(layoutLabel, values),
              child: Column(
                children: [
                  ...children,
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TButton(
                          variant: TButtonVariant.fill,
                          onPressed: () => _submit(layoutLabel, controller),
                          child: const TText('提交并查看数据'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TButton(
                        variant: TButtonVariant.outline,
                        onPressed: () => _reset(controller),
                        child: const TText('重置'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmittedResult(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TText(
            '提交结果 · $_submittedLayout',
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 8),
          for (final entry in _submittedValues.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      final error = _validationError(entry.key, entry.value);
                      return TIcon(
                        error == null
                            ? TIcons.check_circle_filled
                            : TIcons.error_circle_filled,
                        size: 18,
                        color: error == null
                            ? context.tTheme.successNormalColor
                            : context.tTheme.errorNormalColor,
                        semanticLabel: error == null ? '校验通过' : '校验失败',
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 96,
                    child: TText(
                      entry.key,
                      textColor: context.tTheme.textColorSecondary,
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final error = _validationError(entry.key, entry.value);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TText(_displayValue(entry.key, entry.value)),
                            if (error != null)
                              TText(
                                error,
                                textColor: context.tTheme.errorNormalColor,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showSubmittedValues(String layout, Map<String, Object?> values) {
    setState(() {
      _submittedLayout = layout;
      _submittedValues = Map<String, Object?>.from(values);
    });
  }

  void _submit(String layout, TFormController controller) {
    if (!controller.submit()) {
      setState(() {
        _submittedLayout = layout;
        _submittedValues = Map<String, Object?>.from(controller.values);
      });
    }
  }

  String? _validationError(String key, Object? value) {
    switch (key) {
      case 'name':
        return value is String && value.trim().isNotEmpty ? null : '必填';
      case 'password':
        return value is String && value.isNotEmpty ? null : '必填';
      case 'note':
        return value is String && value.trim().isNotEmpty ? null : '必填';
      case 'rating':
        return value is num && value > 0 ? null : '必选';
      case 'region':
        return value is Iterable && value.isNotEmpty ? null : '必选';
      case 'interests':
        return value is Iterable && value.isNotEmpty ? null : '至少选择一项兴趣';
      case 'quantity':
        return value is num && value >= 1 && value <= 10 ? null : '范围为 1 到 10';
      case 'progress':
        return value is num && value >= 0 && value <= 100
            ? null
            : '范围为 0 到 100';
      case 'appointment':
        return value is TDateTimePickerValue && value.year != null
            ? null
            : '必选';
      default:
        return key == 'notifications' && value == null ? '请选择通知设置' : null;
    }
  }

  void _reset(TFormController controller) {
    controller.reset();
    setState(() {
      _nameController.clear();
      _passwordController.clear();
      _noteController.clear();
      _gender = 'female';
      _interests = ['design'];
      _notifications = true;
      _quantity = 2;
      _progress = 60;
      _rating = 3;
      _region = ['guangdong', 'shenzhen'];
      _selectedAppointment = _appointment;
      _submittedLayout = '';
      _submittedValues = const {};
    });
  }

  String _displayValue(String key, Object? value) {
    if (key == 'password') {
      return value is String && value.isNotEmpty ? '已填写（已隐藏）' : '未填写';
    }
    if (key == 'gender') {
      return value == 'female' ? '女' : '男';
    }
    if (key == 'interests' && value is Iterable<Object?>) {
      const labels = {'design': '设计', 'code': '开发', 'product': '产品'};
      return value.map((item) => labels[item] ?? '$item').join('、');
    }
    if (key == 'region' && value is Iterable<Object?>) {
      const labels = {
        'guangdong': '广东',
        'zhejiang': '浙江',
        'shenzhen': '深圳',
        'hangzhou': '杭州',
      };
      return value.map((item) => labels[item] ?? '$item').join('、');
    }
    if (value is TDateTimePickerValue) {
      return '${value.year}-${value.month}-${value.day} ${value.hour}:${value.minute}';
    }
    if (value is Iterable<Object?>) {
      return value.map((item) => _displayValue(key, item)).join('、');
    }
    return '$value';
  }
}
