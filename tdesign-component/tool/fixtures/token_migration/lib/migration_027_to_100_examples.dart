import 'package:tdesign_flutter/tdesign_flutter.dart';

// migration:button:start
Widget migratedButton(VoidCallback? onPressed) {
  return TButton(
    variant: TButtonVariant.fill,
    colorPreset: TButtonColorPreset.primary,
    onPressed: onPressed,
    child: const Text('保存'),
  );
}
// migration:button:end

// migration:theme:start
Widget migratedApp(Widget home) {
  final tokens = TThemeData.defaultData();
  return MaterialApp(
    theme: TThemeBuilder.light(tokens),
    darkTheme: TThemeBuilder.dark(tokens),
    home: home,
  );
}

Widget migratedTextTheme(BuildContext context, Widget child) {
  return Theme(
    data: Theme.of(
      context,
    ).mergeExtension(const TTextThemeData(textStyle: TextStyle(fontSize: 18))),
    child: child,
  );
}

TThemeData migratedThemeCopy(TThemeData tokens) {
  return tokens.copyWith(name: 'business', spacerMap: const {'spacer3': 12});
}
// migration:theme:end

// migration:choices:start
Widget migratedCheckbox(bool value, ValueChanged<bool?>? onChanged) {
  return TCheckbox(value: value, onChanged: onChanged, title: '同意条款');
}

Widget migratedRadio(String value, ValueChanged<String>? onChanged) {
  return TRadioGroup<String>.options(
    value: value,
    onChanged: onChanged,
    options: const [
      TRadioOption(value: 'a', label: '方案 A'),
      TRadioOption(value: 'b', label: '方案 B'),
    ],
  );
}
// migration:choices:end

// migration:form:start
Widget migratedForm({
  required TFormController form,
  required TextEditingController text,
  required String value,
  required ValueChanged<String> onChanged,
}) {
  return TForm(
    controller: form,
    child: TFormField<String>(
      name: 'name',
      value: value,
      onChanged: onChanged,
      required: true,
      requiredMessage: '请输入姓名',
      builder: (context, current, change, error) => TFormItem(
        label: '姓名',
        errorText: error,
        child: TInput(controller: text, onChanged: change),
      ),
    ),
  );
}
// migration:form:end

// migration:calendar:start
Widget migratedCalendar(
  List<DateTime> value,
  ValueChanged<List<DateTime>>? onChanged,
) {
  return SizedBox(
    height: 400,
    child: TCalendar(
      value: value,
      variant: TCalendarVariant.single,
      minDate: DateTime(2026, 1, 1),
      maxDate: DateTime(2026, 12, 31),
      onChanged: onChanged,
    ),
  );
}

Widget migratedDateTime(
  TDateTimePickerValue value,
  ValueChanged<TDateTimePickerValue>? onChanged,
) {
  return TDateTimePicker(value: value, onChanged: onChanged);
}
// migration:calendar:end

// migration:picker:start
TPopupHandle migratedPicker({
  required BuildContext context,
  required String initialValue,
  required ValueChanged<String> onConfirmed,
}) {
  var draft = initialValue;
  return TPickerPopup.show(
    context,
    child: StatefulBuilder(
      builder: (context, setPanelState) => TPicker(
        items: const TPickerColumns([
          [
            TPickerOption(label: '选项 A', value: 'a'),
            TPickerOption(label: '选项 B', value: 'b'),
          ],
        ]),
        value: [draft],
        onChanged: (next) => setPanelState(() {
          draft = next.values.single! as String;
        }),
      ),
    ),
    headerBuilder: (context, close) => TPopupHeader(
      title: const Text('请选择'),
      cancelButton: TButton(onPressed: close, child: const Text('取消')),
      confirmButton: TButton(
        onPressed: () {
          onConfirmed(draft);
          close();
        },
        child: const Text('确认'),
      ),
    ),
  );
}
// migration:picker:end

// migration:dialog:start
Future<bool?> migratedDialog(BuildContext context) {
  return TDialog.show<bool>(
    context,
    dialog: const TConfirmDialog(
      title: '操作确认',
      content: '确认继续？',
      buttonText: '继续',
    ),
  );
}
// migration:dialog:end

// migration:upload:start
Widget migratedUpload({
  required List<TUploadFile> files,
  required ValueChanged<List<TUploadFile>>? onChanged,
  TUploadPicker? picker,
}) {
  return TUpload(
    files: files,
    onChanged: onChanged,
    maxFiles: 2,
    maxFileSize: 5 * 1024 * 1024,
    picker: picker,
  );
}
// migration:upload:end

// migration:toast:start
String migratedLoading(BuildContext context) {
  return TToast.showLoading(
    context: context,
    text: '处理中',
    duration: Duration.zero,
    overlay: const TOverlayConfig(preventScrollThrough: true),
  );
}

// migration:toast:end

// migration:removed-capabilities:start
TBadgeConfig? migratedBadge(bool showBadge, Widget badge) {
  return showBadge ? TBadgeConfig.custom(badge: badge) : null;
}

TMessageMarquee migratedMarquee(int speedMs, bool repeat, int delayMs) {
  return TMessageMarquee(
    duration: Duration(milliseconds: speedMs),
    repeat: repeat,
    delay: Duration(milliseconds: delayMs),
  );
}

Widget migratedImageDialog(Image image) {
  return TDialog(
    title: const Text('活动说明'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [image, const Text('图片下方的业务说明')],
    ),
    actions: const [TDialogAction(child: Text('知道了'), result: true)],
  );
}

Widget migratedCustomCounter(int milliseconds, Color color) {
  return TTimeCounter(
    time: milliseconds,
    autoStart: false,
    content: (time) => Text(
      '${time ~/ Duration.millisecondsPerSecond}s',
      style: TextStyle(color: color),
    ),
  );
}

Widget migratedProgress(double fraction) {
  return TProgress.circular(value: fraction);
}

Widget migratedIndexes() {
  return TIndexes(
    indexList: const ['A'],
    builderContent: (context, index) => Text(index),
  );
}

// migration:removed-capabilities:end
