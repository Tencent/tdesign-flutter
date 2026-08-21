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
      TPickerOption(label: '北京市', value: 'beijing'),
      TPickerOption(label: '天津市', value: 'tianjin'),
    ],
    [
      TPickerOption(label: '海淀区', value: 'haidian'),
      TPickerOption(label: '朝阳区', value: 'chaoyang'),
      TPickerOption(label: '蓟州区', value: 'jizhou'),
    ],
  ]);
  static const _initialDate = TDateTimePickerValue(
    year: 2026,
    month: 8,
    day: 20,
  );
  static const _initialPhotos = [
    TUploadFile(
      id: 'uploaded-1',
      name: 'uploaded1.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/example4.png',
      status: TUploadFileStatus.success,
    ),
    TUploadFile(
      id: 'uploaded-2',
      name: 'uploaded2.png',
      url: 'https://tdesign.gtimg.com/mobile/demos/example6.png',
      status: TUploadFileStatus.success,
    ),
  ];

  final _formController = TFormController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _resumeController = TextEditingController();

  TFormLayout _layout = TFormLayout.horizontal;
  bool _disabled = false;
  String _gender = '';
  String _birth = '';
  String _place = '';
  num _age = 3;
  double _description = 2;
  List<TUploadFile> _photos = List.of(_initialPhotos);

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _resumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用以收集、校验和提交数据，一般由输入框、单选框、复选框、选择器等控件组成。',
      exampleCodeGroup: 'form',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础表单',
              builder: _buildFormDemo,
              center: false,
              ignoreCode: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormDemo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          decoration: BoxDecoration(
            color: context.tTheme.bgColorContainer,
            border: Border(
              bottom: BorderSide(color: context.tTheme.componentStrokeColor),
            ),
          ),
          child: Theme(
            data: Theme.of(
              context,
            ).mergeExtension(const TButtonThemeData(shape: TButtonShape.round)),
            child: Row(
              children: [
                Expanded(
                  child: TButton(
                    size: TButtonSize.small,
                    variant: TButtonVariant.fill,
                    colorScheme: _layout == TFormLayout.horizontal
                        ? TButtonColorScheme.light
                        : TButtonColorScheme.defaultTheme,
                    onPressed: () =>
                        setState(() => _layout = TFormLayout.horizontal),
                    child: const TText('水平排布'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TButton(
                    size: TButtonSize.small,
                    variant: TButtonVariant.fill,
                    colorScheme: _layout == TFormLayout.vertical
                        ? TButtonColorScheme.light
                        : TButtonColorScheme.defaultTheme,
                    onPressed: () =>
                        setState(() => _layout = TFormLayout.vertical),
                    child: const TText('竖直排布'),
                  ),
                ),
              ],
            ),
          ),
        ),
        TCell(
          title: const TText('禁用态'),
          note: TSwitch(
            value: _disabled,
            onChanged: (value) => setState(() => _disabled = value),
          ),
        ),
        const SizedBox(height: 12),
        _buildForm(context),
      ],
    );
  }

  @ExampleCode(group: 'form')
  Widget _buildForm(BuildContext context) {
    final horizontal = _layout == TFormLayout.horizontal;
    return Theme(
      data: Theme.of(context).mergeExtension(
        TFormThemeData(
          layout: _layout,
          labelAlign: TextAlign.left,
          requiredMarkPosition: TFormRequiredMarkPosition.left,
          itemSpacing: 0,
        ),
      ),
      child: TForm(
        controller: _formController,
        showErrorMessage: true,
        child: Column(
          children: [
            TFormField<String>(
              name: 'name',
              value: _nameController.text,
              onChanged: (_) => setState(() {}),
              validator: (value) =>
                  RegExp(r'^[a-zA-Z]{8}$').hasMatch(value ?? '')
                  ? null
                  : '只能输入8个字符英文',
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '用户名',
                help: '输入用户名',
                child: TInput(
                  controller: _nameController,
                  enabled: !_disabled,
                  borderless: true,
                  hintText: '请输入用户名',
                  onChanged: onChanged,
                ),
              ),
            ),
            TFormField<String>(
              name: 'password',
              value: _passwordController.text,
              onChanged: (_) => setState(() {}),
              validator: (value) =>
                  (value?.length ?? 0) > 6 ? null : '长度大于6个字符',
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '密码',
                child: TInput(
                  controller: _passwordController,
                  enabled: !_disabled,
                  borderless: true,
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
              validator: (value) => value?.isNotEmpty == true ? null : '不能为空',
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '性别',
                child: TRadioGroup<String>(
                  value: value,
                  options: const [
                    TRadioOption(value: 'man', label: '男'),
                    TRadioOption(value: 'women', label: '女'),
                    TRadioOption(value: 'secret', label: '保密'),
                  ],
                  direction: Axis.horizontal,
                  columns: 3,
                  onChanged: _disabled ? null : onChanged,
                ),
              ),
            ),
            TFormField<String>(
              name: 'birth',
              value: _birth,
              onChanged: (value) => setState(() => _birth = value),
              validator: (value) => value?.isNotEmpty == true ? null : '不能为空',
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '生日',
                extra: _buildArrow(context),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _disabled
                      ? null
                      : () => _showDatePicker(context, onChanged),
                  child: IgnorePointer(
                    child: TInput(
                      key: ValueKey('form-birth-$value'),
                      initialValue: value,
                      enabled: !_disabled,
                      readOnly: true,
                      borderless: true,
                      textAlign: horizontal ? TextAlign.end : TextAlign.start,
                      hintText: '请输入生日',
                    ),
                  ),
                ),
              ),
            ),
            TFormField<String>(
              name: 'place',
              value: _place,
              onChanged: (value) => setState(() => _place = value),
              validator: (value) => value?.isNotEmpty == true ? null : '不能为空',
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '籍贯',
                extra: _buildArrow(context),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _disabled
                      ? null
                      : () => _showRegionPicker(context, onChanged),
                  child: IgnorePointer(
                    child: TInput(
                      key: ValueKey('form-place-$value'),
                      initialValue: value,
                      enabled: !_disabled,
                      readOnly: true,
                      borderless: true,
                      textAlign: horizontal ? TextAlign.end : TextAlign.start,
                      hintText: '请选择籍贯',
                    ),
                  ),
                ),
              ),
            ),
            TFormField<num>(
              name: 'age',
              value: _age,
              onChanged: (value) => setState(() => _age = value),
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '年限',
                child: Align(
                  alignment: horizontal
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  child: TStepper(
                    value: value,
                    variant: TStepperVariant.filled,
                    onChanged: _disabled ? null : onChanged,
                  ),
                ),
              ),
            ),
            TFormField<double>(
              name: 'description',
              value: _description,
              onChanged: (value) => setState(() => _description = value),
              validator: (value) => (value ?? 0) > 3 ? null : '分数过低会影响整体评价',
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '自我评价',
                child: Align(
                  alignment: horizontal
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  child: TRate(
                    value: value,
                    allowHalf: true,
                    onChanged: _disabled ? null : onChanged,
                  ),
                ),
              ),
            ),
            TFormField<String>(
              name: 'resume',
              value: _resumeController.text,
              onChanged: (_) => setState(() {}),
              validator: (value) => value?.isNotEmpty == true ? null : '不能为空',
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '个人简介',
                child: SizedBox(
                  height: 100,
                  child: TTextarea(
                    controller: _resumeController,
                    enabled: !_disabled,
                    hintText: '请输入个人简介',
                    minLines: 2,
                    maxLength: 50,
                    indicator: true,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ),
            TFormField<List<TUploadFile>>(
              name: 'photo',
              value: _photos,
              required: true,
              requiredMessage: '请上传照片',
              onChanged: (value) => setState(() => _photos = value),
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '上传照片',
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = horizontal ? 3 : 4;
                    final size =
                        (constraints.maxWidth - (columns - 1) * 8) / columns;
                    return Theme(
                      data: Theme.of(context).mergeExtension(
                        TUploadThemeData(itemSize: size.clamp(64, 96)),
                      ),
                      child: TUpload(
                        files: value,
                        maxFiles: horizontal ? 6 : 8,
                        onChanged: _disabled ? null : onChanged,
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildButtons(horizontal),
          ],
        ),
      ),
    );
  }

  Widget _buildArrow(BuildContext context) => TIcon(
    TIcons.chevron_right,
    size: 24,
    color: _disabled
        ? context.tTheme.textDisabledColor
        : context.tTheme.textColorPlaceholder,
    semanticLabel: '选择',
  );

  Widget _buildButtons(bool horizontal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        border: Border(
          bottom: BorderSide(color: context.tTheme.componentStrokeColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TButton(
              size: TButtonSize.large,
              variant: TButtonVariant.fill,
              colorScheme: horizontal
                  ? TButtonColorScheme.primary
                  : TButtonColorScheme.light,
              onPressed: _disabled ? null : _formController.submit,
              child: const TText('提交'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TButton(
              size: TButtonSize.large,
              variant: TButtonVariant.fill,
              colorScheme: TButtonColorScheme.defaultTheme,
              onPressed: _disabled ? null : _reset,
              child: const TText('重置'),
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context, ValueChanged<String>? onChanged) {
    var draft = _initialDate;
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        titleWidget: const TText('选择日期'),
        child: StatefulBuilder(
          builder: (context, setPopupState) => TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: draft,
            onChanged: (value) => setPopupState(() => draft = value),
          ),
        ),
        onVisibleChange: (visible, trigger) {
          if (!visible && trigger == TPopupTrigger.confirm && mounted) {
            onChanged?.call(
              '${draft.year}-${draft.month.toString().padLeft(2, '0')}-${draft.day.toString().padLeft(2, '0')}',
            );
          }
        },
      ),
    );
  }

  void _showRegionPicker(
    BuildContext context,
    ValueChanged<String>? onChanged,
  ) {
    var draft = <Object?>['beijing', 'haidian'];
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        titleWidget: const TText('选择地址'),
        child: StatefulBuilder(
          builder: (context, setPopupState) => TPicker(
            items: _regionItems,
            value: draft,
            onChanged: (value) => setPopupState(() => draft = value.values),
          ),
        ),
        onVisibleChange: (visible, trigger) {
          if (!visible && trigger == TPopupTrigger.confirm && mounted) {
            const labels = {
              'beijing': '北京市',
              'tianjin': '天津市',
              'haidian': '海淀区',
              'chaoyang': '朝阳区',
              'jizhou': '蓟州区',
            };
            onChanged?.call(
              draft.map((value) => labels[value] ?? '$value').join('/'),
            );
          }
        },
      ),
    );
  }

  void _reset() {
    _formController.reset();
    setState(() {
      _nameController.clear();
      _passwordController.clear();
      _resumeController.clear();
      _gender = '';
      _birth = '';
      _place = '';
      _age = 3;
      _description = 2;
      _photos = List.of(_initialPhotos);
    });
  }
}
