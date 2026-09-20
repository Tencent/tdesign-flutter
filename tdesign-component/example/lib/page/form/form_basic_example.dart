import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

/// 可直接运行的 TForm、TFormItem 与 TFormField 组合示例。
@ExampleCode(group: 'form')
class FormBasicDemo extends StatefulWidget {
  const FormBasicDemo({super.key});

  @override
  State<FormBasicDemo> createState() => _FormBasicDemoState();
}

class _FormBasicDemoState extends State<FormBasicDemo> {
  static const _regionItems = TPickerColumns([
    [
      TPickerOption(label: '广东省', value: 'guangdong'),
      TPickerOption(label: '北京市', value: 'beijing'),
    ],
    [
      TPickerOption(label: '深圳市', value: 'shenzhen'),
      TPickerOption(label: '广州市', value: 'guangzhou'),
      TPickerOption(label: '海淀区', value: 'haidian'),
      TPickerOption(label: '朝阳区', value: 'chaoyang'),
    ],
  ]);
  static const _initialDate = TDateTimePickerValue(
    year: 2022,
    month: 8,
    day: 10,
  );
  static const _initialName = 'Abcdefgh';
  static const _initialPassword = '12345678';
  static const _initialGender = 'man';
  static const _initialBirth = '2022-08-10';
  static const _initialPlace = '广东省 深圳市';
  static const _initialPlaceValues = <Object?>['guangdong', 'shenzhen'];
  static const _initialAge = 3;
  static const _initialDescription = 3.5;
  static const _initialResume =
      '本人性格开朗、稳重、细心、待人热情、真诚，工作认真负责，积极主动，勇于创新，具有很强的团队协作精神。';
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
      url: 'https://tdesign.gtimg.com/mobile/demos/example4.png',
      status: TUploadFileStatus.success,
    ),
  ];

  final _formController = TFormController();
  final _nameController = TextEditingController(text: _initialName);
  final _passwordController = TextEditingController(text: _initialPassword);
  final _resumeController = TextEditingController(text: _initialResume);

  TFormLayout _layout = TFormLayout.horizontal;
  bool _disabled = false;
  String _gender = _initialGender;
  String _birth = _initialBirth;
  String _place = _initialPlace;
  List<Object?> _placeValues = List.of(_initialPlaceValues);
  num _age = _initialAge;
  double _description = _initialDescription;
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
    return _buildFormDemo(context);
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
                    key: const ValueKey('form-layout-horizontal'),
                    size: TButtonSize.small,
                    variant: TButtonVariant.fill,
                    colorScheme: _layout == TFormLayout.horizontal
                        ? TButtonColorScheme.light
                        : TButtonColorScheme.defaultTheme,
                    style: _layout == TFormLayout.horizontal
                        ? null
                        : ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              context.tTheme.bgColorSecondaryContainer,
                            ),
                          ),
                    onPressed: () =>
                        setState(() => _layout = TFormLayout.horizontal),
                    child: const TText('水平排布'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TButton(
                    key: const ValueKey('form-layout-vertical'),
                    size: TButtonSize.small,
                    variant: TButtonVariant.fill,
                    colorScheme: _layout == TFormLayout.vertical
                        ? TButtonColorScheme.light
                        : TButtonColorScheme.defaultTheme,
                    style: _layout == TFormLayout.vertical
                        ? null
                        : ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              context.tTheme.bgColorSecondaryContainer,
                            ),
                          ),
                    onPressed: () =>
                        setState(() => _layout = TFormLayout.vertical),
                    child: const TText('竖向排布'),
                  ),
                ),
              ],
            ),
          ),
        ),
        TCell(
          title: const TText('禁用态'),
          note: Theme(
            data: Theme.of(context).mergeExtension(
              TSwitchThemeData(
                trackOffColor: context.tTheme.componentBorderColor,
              ),
            ),
            child: TSwitch(
              key: const ValueKey('form-disabled-switch'),
              value: _disabled,
              onChanged: (value) => setState(() => _disabled = value),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildForm(context),
      ],
    );
  }

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
        onSubmit: (_) => TToast.showSuccess('提交成功', context: context),
        child: Column(
          children: [
            TFormField<String>(
              name: 'name',
              value: _nameController.text,
              onChanged: _disabled ? null : (_) => setState(() {}),
              validator: (value) =>
                  RegExp(r'^[a-zA-Z]{8}$').hasMatch(value ?? '')
                  ? null
                  : '只能输入8个字符英文',
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '用户名',
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
              onChanged: _disabled ? null : (_) => setState(() {}),
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
              onChanged: _disabled
                  ? null
                  : (value) => setState(() => _gender = value),
              validator: (value) => value?.isNotEmpty == true ? null : '不能为空',
              builder: (context, value, onChanged, errorText) => TFormItem(
                key: const ValueKey('form-gender-item'),
                label: '性别',
                verticalAlignment: horizontal
                    ? TFormItemVerticalAlignment.center
                    : null,
                child: TRadioGroup<String>.options(
                  key: const ValueKey('form-gender-options'),
                  value: value,
                  options: const [
                    TRadioOption(value: 'man', label: '男'),
                    TRadioOption(value: 'women', label: '女'),
                    TRadioOption(value: 'secret', label: '保密'),
                  ],
                  direction: Axis.horizontal,
                  variant: TRadioVariant.inline,
                  onChanged: onChanged,
                ),
              ),
            ),
            TFormField<String>(
              name: 'birth',
              value: _birth,
              onChanged: _disabled
                  ? null
                  : (value) => setState(() => _birth = value),
              validator: (value) => value?.isNotEmpty == true ? null : '不能为空',
              builder: (context, value, onChanged, errorText) => Semantics(
                button: true,
                enabled: onChanged != null,
                label: '生日',
                value: value.isNotEmpty ? value : '未选择',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onChanged == null
                      ? null
                      : () => _showDatePicker(context, value, onChanged),
                  child: TFormItem(
                    key: const ValueKey('form-birth-item'),
                    label: '生日',
                    extra: _buildArrow(context),
                    child: _buildSelectionValue(context, value, '请输入生日'),
                  ),
                ),
              ),
            ),
            TFormField<String>(
              name: 'place',
              value: _place,
              onChanged: _disabled
                  ? null
                  : (value) => setState(() => _place = value),
              validator: (value) => value?.isNotEmpty == true ? null : '不能为空',
              builder: (context, value, onChanged, errorText) => Semantics(
                button: true,
                enabled: onChanged != null,
                label: '籍贯',
                value: value.isNotEmpty ? value : '未选择',
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onChanged == null
                      ? null
                      : () => _showRegionPicker(context, onChanged),
                  child: TFormItem(
                    key: const ValueKey('form-place-item'),
                    label: '籍贯',
                    extra: _buildArrow(context),
                    child: _buildSelectionValue(context, value, '请选择籍贯'),
                  ),
                ),
              ),
            ),
            TFormField<num>(
              name: 'age',
              value: _age,
              onChanged: _disabled
                  ? null
                  : (value) => setState(() => _age = value),
              builder: (context, value, onChanged, errorText) => TFormItem(
                key: const ValueKey('form-age-item'),
                label: '年限',
                child: TStepper(
                  value: value,
                  variant: TStepperVariant.filled,
                  onChanged: onChanged,
                ),
              ),
            ),
            TFormField<double>(
              name: 'description',
              value: _description,
              onChanged: _disabled
                  ? null
                  : (value) => setState(() => _description = value),
              validator: (value) => (value ?? 0) > 3 ? null : '分数过低会影响整体评价',
              builder: (context, value, onChanged, errorText) => TFormItem(
                key: const ValueKey('form-description-item'),
                label: '自我评价',
                child: TRate(
                  value: value,
                  allowHalf: true,
                  onChanged: onChanged,
                ),
              ),
            ),
            TFormField<String>(
              name: 'resume',
              value: _resumeController.text,
              onChanged: _disabled ? null : (_) => setState(() {}),
              validator: (value) => value?.isNotEmpty == true ? null : '不能为空',
              builder: (context, value, onChanged, errorText) => TFormItem(
                label: '个人简介',
                child: SizedBox(
                  key: const ValueKey('form-resume-content'),
                  height: 124,
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
              onChanged: _disabled
                  ? null
                  : (value) => setState(() => _photos = value),
              validator: (value) => value?.isNotEmpty == true ? null : '请上传照片',
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
                        onChanged: onChanged,
                      ),
                    );
                  },
                ),
              ),
            ),
            _buildButtons(),
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

  Widget _buildSelectionValue(
    BuildContext context,
    String? value,
    String placeholder,
  ) {
    final hasValue = value?.isNotEmpty == true;
    return TText(
      hasValue ? value! : placeholder,
      font: context.tTheme.fontBodyLarge,
      textColor: _disabled
          ? context.tTheme.textDisabledColor
          : hasValue
          ? context.tTheme.textColorPrimary
          : context.tTheme.textColorPlaceholder,
    );
  }

  Widget _buildButtons() {
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
              key: const ValueKey('form-reset-button'),
              size: TButtonSize.large,
              variant: TButtonVariant.fill,
              colorScheme: TButtonColorScheme.light,
              onPressed: _disabled ? null : _reset,
              child: const TText('重置'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TButton(
              key: const ValueKey('form-submit-button'),
              size: TButtonSize.large,
              variant: TButtonVariant.fill,
              colorScheme: TButtonColorScheme.primary,
              onPressed: _disabled ? null : _formController.submit,
              child: const TText('提交'),
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(
    BuildContext context,
    String value,
    ValueChanged<String>? onChanged,
  ) {
    var draft = _parseDate(value) ?? _initialDate;
    TPickerPopup.show(
      context,
      headerBuilder: (_, close) => TPopupHeader(
        cancelButton: TextButton(onPressed: close, child: const TText('取消')),
        title: const TText('选择日期'),
        confirmButton: TextButton(
          onPressed: () {
            if (mounted) {
              onChanged?.call(
                '${draft.year}-${draft.month.toString().padLeft(2, '0')}-${draft.day.toString().padLeft(2, '0')}',
              );
            }
            close();
          },
          child: const TText('确定'),
        ),
      ),
      child: StatefulBuilder(
        builder: (context, setPopupState) => TDateTimePicker(
          mode: DateTimePickerMode(dateMode: DateMode.date),
          value: draft,
          onChanged: (value) => setPopupState(() => draft = value),
        ),
      ),
    );
  }

  void _showRegionPicker(
    BuildContext context,
    ValueChanged<String>? onChanged,
  ) {
    var draft = List<Object?>.of(_placeValues);
    TPickerPopup.show(
      context,
      headerBuilder: (_, close) => TPopupHeader(
        cancelButton: TextButton(onPressed: close, child: const TText('取消')),
        title: const TText('选择地址'),
        confirmButton: TextButton(
          onPressed: () {
            if (mounted) {
              const labels = {
                'guangdong': '广东省',
                'beijing': '北京市',
                'shenzhen': '深圳市',
                'guangzhou': '广州市',
                'haidian': '海淀区',
                'chaoyang': '朝阳区',
              };
              _placeValues = List<Object?>.of(draft);
              onChanged?.call(
                draft.map((value) => labels[value] ?? '$value').join(' '),
              );
            }
            close();
          },
          child: const TText('确定'),
        ),
      ),
      child: StatefulBuilder(
        builder: (context, setPopupState) => TPicker(
          items: _regionItems,
          value: draft,
          onChanged: (value) => setPopupState(() => draft = value.values),
        ),
      ),
    );
  }

  void _reset() {
    _formController.reset();
    setState(() {
      _nameController.text = _initialName;
      _passwordController.text = _initialPassword;
      _resumeController.text = _initialResume;
      _gender = _initialGender;
      _birth = _initialBirth;
      _place = _initialPlace;
      _placeValues = List.of(_initialPlaceValues);
      _age = _initialAge;
      _description = _initialDescription;
      _photos = List.of(_initialPhotos);
    });
  }

  TDateTimePickerValue? _parseDate(String value) {
    final parts = value.split('-').map(int.tryParse).toList();
    if (parts.length != 3 || parts.any((part) => part == null)) {
      return null;
    }
    return TDateTimePickerValue(year: parts[0], month: parts[1], day: parts[2]);
  }
}
