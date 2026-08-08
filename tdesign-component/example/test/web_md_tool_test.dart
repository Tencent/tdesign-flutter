import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter_example/base/web_md_tool.dart';

void main() {
  test(
    'writes generated component Markdown into the site documentation tree',
    () {
      expect(
        WebMdTool.documentationOutputPath(
          workspaceRoot: '/workspace/tdesign-flutter',
          componentName: 'pull-down-refresh',
        ),
        '/workspace/tdesign-flutter/'
        'tdesign-site/docs/components/pull-down-refresh/README.md',
      );
    },
  );
}
