import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/t_upload_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  testWidgets('Upload Demo follows the official groups and layouts', (
    tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: ExamplePageInheritedTheme(
            model: ExamplePageModel(
              text: 'Upload 上传',
              name: 'upload',
              pageBuilder: (_, __) => const TUploadPage(),
            ),
            child: const TUploadPage(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('01 组件类型'), findsOneWidget);
    final scrollState = tester.state<ScrollableState>(
      find.byType(Scrollable).first,
    );
    var foundStatus = false;
    var foundStyle = false;
    var foundList = false;
    var foundDragLabel = false;
    var foundGridMatrix = false;
    var foundListMatrix = false;
    var allExamplesEnabled = true;
    var foundEnabledDragDemo = false;
    for (
      var offset = 0.0;
      offset <= scrollState.position.maxScrollExtent;
      offset += 300
    ) {
      scrollState.position.jumpTo(offset);
      await tester.pump();
      foundStatus |= find.text('02 组件状态').evaluate().isNotEmpty;
      foundStyle |= find.text('03 组件风格').evaluate().isNotEmpty;
      foundDragLabel |= find.text('长按图片拖拽排片').evaluate().isNotEmpty;
      foundList |= find
          .byWidgetPredicate(
            (widget) =>
                widget is TUpload && widget.layout == TUploadLayout.list,
          )
          .evaluate()
          .isNotEmpty;
      for (final upload in tester.widgetList<TUpload>(find.byType(TUpload))) {
        allExamplesEnabled &= upload.onChanged != null;
        if (upload.draggable) {
          foundEnabledDragDemo |= upload.onChanged != null;
        }
        foundGridMatrix |=
            upload.layout == TUploadLayout.grid &&
            upload.files.length == 13 &&
            upload.files.any((file) => file.name == 'report.xlsx') &&
            upload.files.any((file) => file.name == 'image-reload.png');
        foundListMatrix |=
            upload.layout == TUploadLayout.list &&
            upload.files.length == 8 &&
            upload.files.first.name == 'Technical Design Document.pdf' &&
            upload.files.last.name == 'Quarterly Review.pptx';
      }
    }
    expect(foundStatus, isTrue);
    expect(foundStyle, isTrue);
    expect(foundList, isTrue);
    expect(foundDragLabel, isTrue);
    expect(foundGridMatrix, isTrue);
    expect(foundListMatrix, isTrue);
    expect(allExamplesEnabled, isTrue);
    expect(foundEnabledDragDemo, isTrue);
  });
}
