import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  final bytes = Uint8List.fromList(const [
    0x89,
    0x50,
    0x4e,
    0x47,
    0x0d,
    0x0a,
    0x1a,
    0x0a,
    0x00,
    0x00,
    0x00,
    0x0d,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1f,
    0x15,
    0xc4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0d,
    0x49,
    0x44,
    0x41,
    0x54,
    0x08,
    0xd7,
    0x63,
    0xf8,
    0xcf,
    0xc0,
    0xf0,
    0x1f,
    0x00,
    0x05,
    0x00,
    0x01,
    0xff,
    0x89,
    0x99,
    0x3d,
    0x1d,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4e,
    0x44,
    0xae,
    0x42,
    0x60,
    0x82,
  ]);

  TUploadFile file(
    String id, {
    TUploadFileStatus status = TUploadFileStatus.ready,
    double? progress,
    String? errorText,
    bool canRemove = true,
    int? size,
    bool withBytes = true,
  }) {
    return TUploadFile(
      id: id,
      name: '$id.png',
      bytes: withBytes ? bytes : null,
      size: size ?? bytes.length,
      status: status,
      progress: progress,
      errorText: errorText,
      canRemove: canRemove,
    );
  }

  Widget wrap(Widget child, {TUploadThemeData? uploadTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (uploadTheme != null) {
      theme = theme.mergeExtension(uploadTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  group('TUpload controlled behavior', () {
    testWidgets('onChanged null disables add and file actions', (tester) async {
      await tester.pumpWidget(wrap(TUpload(
        files: [file('a')],
        maxFiles: 2,
        onPreview: (_) => fail('disabled preview'),
      )));
      expect(
        tester
            .widget<GestureDetector>(find.byKey(const ValueKey('upload-add')))
            .onTap,
        isNull,
      );
      expect(find.byKey(const ValueKey('upload-remove-a')), findsNothing);
    });

    testWidgets('custom picker emits a complete immutable next list',
        (tester) async {
      List<TUploadFile>? changed;
      final initial = file('a');
      final selected = file('b');
      await tester.pumpWidget(wrap(TUpload(
        files: [initial],
        maxFiles: 3,
        picker: () async => [selected],
        onChanged: (files) => changed = files,
      )));
      await tester.tap(find.byKey(const ValueKey('upload-add')));
      await tester.pump();
      expect(changed, [initial, selected]);
      expect(() => changed!.add(file('c')), throwsUnsupportedError);
    });

    testWidgets('empty selection does not emit changes', (tester) async {
      var changed = false;
      await tester.pumpWidget(wrap(TUpload(
        files: const [],
        picker: () async => [],
        onChanged: (_) => changed = true,
      )));
      await tester.tap(find.byKey(const ValueKey('upload-add')));
      await tester.pump();
      expect(changed, isFalse);
    });

    testWidgets('validates maximum count and byte size', (tester) async {
      TUploadValidationError? error;
      await tester.pumpWidget(wrap(TUpload(
        files: [file('a')],
        maxFiles: 2,
        picker: () async => [file('b'), file('c')],
        onValidationError: (value) => error = value,
        onChanged: (_) {},
      )));
      await tester.tap(find.byKey(const ValueKey('upload-add')));
      await tester.pump();
      expect(error, TUploadValidationError.maxFiles);

      error = null;
      await tester.pumpWidget(wrap(TUpload(
        files: const [],
        maxFileSize: 10,
        picker: () async => [file('large', size: 11)],
        onValidationError: (value) => error = value,
        onChanged: (_) {},
      )));
      await tester.tap(find.byKey(const ValueKey('upload-add')));
      await tester.pump();
      expect(error, TUploadValidationError.fileSize);
    });

    testWidgets('picker errors are forwarded', (tester) async {
      Object? error;
      await tester.pumpWidget(wrap(TUpload(
        files: const [],
        picker: () async => throw StateError('failed'),
        onError: (value) => error = value,
        onChanged: (_) {},
      )));
      await tester.tap(find.byKey(const ValueKey('upload-add')));
      await tester.pump();
      expect(error, isA<StateError>());
    });

    testWidgets('remove emits the remaining files', (tester) async {
      List<TUploadFile>? changed;
      final first = file('a');
      final second = file('b');
      await tester.pumpWidget(wrap(TUpload(
        files: [first, second],
        maxFiles: 3,
        onChanged: (value) => changed = value,
      )));
      await tester.tap(find.byKey(const ValueKey('upload-remove-a')));
      expect(changed, [second]);
    });

    testWidgets('preview and retry callbacks receive the selected file',
        (tester) async {
      TUploadFile? previewed;
      TUploadFile? retried;
      final ready = file('ready');
      final failed = file(
        'failed',
        status: TUploadFileStatus.error,
        errorText: 'Try again',
      );
      await tester.pumpWidget(wrap(TUpload(
        files: [ready, failed],
        maxFiles: 3,
        onPreview: (value) => previewed = value,
        onRetry: (value) => retried = value,
        onChanged: (_) {},
      )));
      await tester.tap(find.byKey(const ValueKey('upload-file-ready')));
      await tester.tap(find.byKey(const ValueKey('upload-status-failed')));
      expect(previewed, same(ready));
      expect(retried, same(failed));
    });

    testWidgets('max count hides add and canRemove controls remove action',
        (tester) async {
      await tester.pumpWidget(wrap(TUpload(
        files: [file('a', canRemove: false)],
        onChanged: (_) {},
      )));
      expect(find.byKey(const ValueKey('upload-add')), findsNothing);
      expect(find.byKey(const ValueKey('upload-remove-a')), findsNothing);
    });
  });

  group('TUpload status and theme', () {
    testWidgets('renders uploading progress, indeterminate and error states',
        (tester) async {
      await tester.pumpWidget(wrap(TUpload(
        files: [
          file('progress', status: TUploadFileStatus.uploading, progress: 0.5),
          file('loading', status: TUploadFileStatus.uploading),
          file('error', status: TUploadFileStatus.error),
          file('success', status: TUploadFileStatus.success),
        ],
        maxFiles: 5,
        onChanged: (_) {},
      )));
      expect(find.text('50%'), findsOneWidget);
      expect(find.text('上传中'), findsOneWidget);
      expect(find.text('上传失败'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
      expect(find.byKey(const ValueKey('upload-status-success')), findsNothing);
    });

    testWidgets('status overlay and remove icon use token foreground styles',
        (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(TUpload(
        files: [
          file('progress', status: TUploadFileStatus.uploading, progress: 0.5),
          file('error', status: TUploadFileStatus.error),
        ],
        maxFiles: 3,
        onChanged: (_) {},
      )));

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator).first,
      );
      final refreshIcon = tester.widget<Icon>(find.byIcon(TIcons.refresh));
      final removeIcon = tester.widget<Icon>(
        find.descendant(
          of: find.byKey(const ValueKey('upload-remove-error')),
          matching: find.byType(Icon),
        ),
      );
      final statusText = tester.widget<Text>(find.text('上传失败'));

      expect(indicator.color, token.textColorAnti);
      expect(refreshIcon.color, token.textColorAnti);
      expect(removeIcon.color, token.textColorAnti);
      expect(statusText.maxLines, 1);
      expect(statusText.overflow, TextOverflow.ellipsis);
      expect(statusText.style?.color, token.textColorAnti);
      expect(statusText.style?.fontSize, token.fontBodySmall?.size);
      expect(statusText.style?.height, token.fontBodySmall?.height);
    });

    testWidgets('renders bytes, network and placeholder preview branches',
        (tester) async {
      await tester.pumpWidget(wrap(TUpload(
        files: [
          file('bytes'),
          const TUploadFile(id: 'url', name: 'url', url: 'bad://url'),
          const TUploadFile(id: 'empty', name: 'empty'),
        ],
        maxFiles: 4,
        onChanged: (_) {},
      )));
      await tester.pump();
      expect(find.byType(Image), findsNWidgets(2));
      expect(find.byType(ColoredBox), findsWidgets);
    });

    testWidgets('placeholder preview uses token colors under full theme',
        (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(TUpload(
        files: const [TUploadFile(id: 'empty', name: 'empty')],
        onChanged: null,
      )));

      final placeholderBox = tester.widget<ColoredBox>(
        find
            .ancestor(
              of: find.byIcon(TIcons.file),
              matching: find.byType(ColoredBox),
            )
            .first,
      );
      final icon = tester.widget<Icon>(find.byIcon(TIcons.file));
      expect(placeholderBox.color, token.bgColorSecondaryContainer);
      expect(icon.color, token.textColorPlaceholder);
    });

    testWidgets('theme controls dimensions, shape and status styling',
        (tester) async {
      const statusStyle = TextStyle(color: Colors.yellow, fontSize: 10);
      await tester.pumpWidget(wrap(
        TUpload(
          files: [file('error', status: TUploadFileStatus.error)],
          maxFiles: 2,
          onChanged: (_) {},
        ),
        uploadTheme: const TUploadThemeData(
          variant: TUploadVariant.circle,
          itemSize: 96,
          spacing: 3,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          backgroundColor: Colors.green,
          foregroundColor: Colors.red,
          overlayColor: Colors.blue,
          statusTextStyle: statusStyle,
          borderRadius: 12,
          addIconSize: 20,
          statusIconSize: 18,
          removeButtonSize: 24,
          removeButtonColor: Colors.purple,
          removeIconSize: 12,
        ),
      ));
      expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SizedBox && widget.width == 96 && widget.height == 96,
          ),
          findsOneWidget);
      expect(tester.widget<Text>(find.text('上传失败')).style, statusStyle);
      final add = tester.widget<Container>(
        find.descendant(
          of: find.byKey(const ValueKey('upload-add')),
          matching: find.byType(Container),
        ),
      );
      expect((add.decoration as BoxDecoration).shape, BoxShape.circle);
    });
  });

  group('TUpload data contracts', () {
    test('file is immutable and copyWith updates selected values', () {
      final original = file('a');
      final copied = original.copyWith(
        id: 'b',
        name: 'b.png',
        url: 'https://example.com/b.png',
        bytes: Uint8List(1),
        size: 1,
        status: TUploadFileStatus.uploading,
        progress: 0.2,
        errorText: 'error',
        canRemove: false,
      );
      expect(copied.id, 'b');
      expect(copied.status, TUploadFileStatus.uploading);
      expect(copied.canRemove, isFalse);
      expect(original.copyWith().id, 'a');
      expect(
        () => TUploadFile(id: 'a', name: 'a', progress: 2),
        throwsAssertionError,
      );
    });

    test('constructor rejects invalid limits and video multi-selection', () {
      expect(
        () => TUpload(files: const [], maxFiles: 0),
        throwsAssertionError,
      );
      expect(
        () => TUpload(files: [file('a'), file('b')], maxFiles: 1),
        throwsAssertionError,
      );
      expect(
        () => TUpload(
          files: const [],
          mediaType: TUploadMediaType.video,
          maxFiles: 2,
        ),
        throwsAssertionError,
      );
    });

    test('enum contracts are final', () {
      expect(TUploadMediaType.values, hasLength(2));
      expect(TUploadFileStatus.values, hasLength(4));
      expect(TUploadValidationError.values, hasLength(2));
      expect(TUploadVariant.values, hasLength(2));
    });
  });

  group('default image_picker adapter', () {
    late ImagePickerPlatform originalPlatform;
    late _FakeImagePickerPlatform fakePlatform;

    setUp(() {
      originalPlatform = ImagePickerPlatform.instance;
      fakePlatform = _FakeImagePickerPlatform(
        XFile.fromData(bytes, name: 'selected.png'),
      );
      ImagePickerPlatform.instance = fakePlatform;
    });
    tearDown(() {
      ImagePickerPlatform.instance = originalPlatform;
    });

    testWidgets('covers single image, multiple image and video selection',
        (tester) async {
      List<TUploadFile>? changed;
      Object? pickerError;

      Future<void> run(TUpload upload) async {
        await tester.pumpWidget(wrap(upload));
        await tester.tap(find.byKey(const ValueKey('upload-add')));
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 20)),
        );
        await tester.pump();
      }

      await run(TUpload(
        files: const [],
        onError: (error) => pickerError = error,
        onChanged: (value) => changed = value,
      ));
      expect(pickerError, isNull);
      expect(fakePlatform.imageCalls, 1);
      expect(changed, hasLength(1));

      changed = null;
      await run(TUpload(
        files: const [],
        maxFiles: null,
        onChanged: (value) => changed = value,
      ));
      expect(changed, hasLength(1));

      changed = null;
      await run(TUpload(
        files: const [],
        mediaType: TUploadMediaType.video,
        onChanged: (value) => changed = value,
      ));
      expect(changed, hasLength(1));
    });

    testWidgets('cancelled default picker keeps controlled value',
        (tester) async {
      var changed = false;
      fakePlatform.cancelled = true;
      await tester.pumpWidget(wrap(TUpload(
        files: const [],
        onChanged: (_) => changed = true,
      )));
      await tester.tap(find.byKey(const ValueKey('upload-add')));
      await tester.pumpAndSettle();
      expect(changed, isFalse);
    });
  });

  test('TUploadThemeData copyWith and lerp', () {
    const base = TUploadThemeData(
      variant: TUploadVariant.square,
      itemSize: 80,
      spacing: 4,
      runSpacing: 6,
      alignment: WrapAlignment.start,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      overlayColor: Colors.black54,
      statusTextStyle: TextStyle(fontSize: 10),
      borderRadius: 4,
      addIconSize: 20,
      statusIconSize: 22,
      removeButtonSize: 18,
      removeButtonColor: Colors.grey,
      removeIconSize: 12,
    );
    const other = TUploadThemeData(
      variant: TUploadVariant.circle,
      itemSize: 120,
      spacing: 8,
      runSpacing: 10,
      alignment: WrapAlignment.end,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      overlayColor: Colors.blue,
      statusTextStyle: TextStyle(fontSize: 14),
      borderRadius: 12,
      addIconSize: 28,
      statusIconSize: 30,
      removeButtonSize: 24,
      removeButtonColor: Colors.red,
      removeIconSize: 16,
    );
    expect(base.copyWith().itemSize, 80);
    expect(base.copyWith(itemSize: 90).itemSize, 90);
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.25).variant, TUploadVariant.square);
    expect(base.lerp(other, 0.75).variant, TUploadVariant.circle);
    expect(base.lerp(other, 0.5).itemSize, 100);
  });
}

class _FakeImagePickerPlatform extends ImagePickerPlatform {
  _FakeImagePickerPlatform(this.file);

  final XFile file;
  bool cancelled = false;
  int imageCalls = 0;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    imageCalls += 1;
    return cancelled ? null : file;
  }

  @override
  Future<List<XFile>> getMultiImageWithOptions({
    MultiImagePickerOptions options = const MultiImagePickerOptions(),
  }) async {
    return cancelled ? [] : [file];
  }

  @override
  Future<XFile?> getVideo({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    Duration? maxDuration,
  }) async {
    return cancelled ? null : file;
  }
}
