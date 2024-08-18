1. 准备工作
   a. Fork 项目仓库
    - 访问 TDesign Flutter 项目的 GitHub 页面
    - 点击右上角的 "Fork" 按钮

   b. 克隆 fork 的仓库到本地
      ```
      git clone https://github.com/你的用户名/tdesign-flutter.git
      cd tdesign-flutter
      ```

   c. 设置上游仓库
      ```
      git remote add upstream https://github.com/Tencent/tdesign-flutter.git
      ```

   d. 创建并切换到新的特性分支
      ```
      git checkout -b feature/新组件名小写_下划线  //如feature/td_new_component
      ```

   e. 安装依赖
      ```
      flutter pub get
      ```

2. 组件开发
   a. 在 `lib/src/components` 下创建新组件文件夹和主文件
      ```
      mkdir lib/src/components/new_component
      touch lib/src/components/new_component/td_new_component.dart
      ```

   b. 实现组件基本结构
      ```dart
      import 'package:flutter/material.dart';
      import 'package:tdesign_flutter/tdesign_flutter.dart';

      class TDNewComponent extends StatefulWidget {
        const TDNewComponent({Key? key}) : super(key: key);

        @override
        _TDNewComponentState createState() => _TDNewComponentState();
      }

      class _TDNewComponentState extends State<TDNewComponent> {
        @override
        Widget build(BuildContext context) {
          final theme = TDTheme.of(context);
          return Container(
            // 使用主题中的颜色和样式
            color: theme.brandNormalColor,
            child: Text(
              // 使用本地化文本
              TDResources.of(context).textComponentTitle,
              style: TextStyle(color: theme.fontGyColor1),
            ),
          );
        }
      }
      ```

3. 国际化支持
   a. 打开 `lib/src/localization/td_resources.dart`
   b. 在 TDResources 类中添加新的 getter
      ```dart
      String get newComponentTitle => _getText('newComponentTitle');
      ```

   c. 在 `lib/src/localization/l10n/intl_en.arb` 和 `intl_zh.arb` 中添加新的文本
      ```json
      {
        "newComponentTitle": "New Component"
      }
      ```

4. 示例页面开发
   a. 创建示例页面文件
      ```
      touch example/lib/page/td_new_component_page.dart
      ```

   b. 实现示例页面
      ```dart
      import 'package:flutter/material.dart';
      import 'package:tdesign_flutter/tdesign_flutter.dart';
      import '../base/example_base.dart';

      class TDNewComponentPage extends StatelessWidget {
        const TDNewComponentPage({Key? key}) : super(key: key);

        @override
        Widget build(BuildContext context) {
          return ExamplePage(
            title: 'New Component',
            exampleCodeGroup: 'newComponent',
            children: [
              ExampleModule(title: 'Basic Usage', children: [
                ExampleItem(
                  desc: 'Default',
                  builder: (_) => const TDNewComponent(),
                ),
                // 添加更多 ExampleItem
              ]),
              // 添加更多 ExampleModule
            ],
          );
        }
      }
      ```

5. 注册路由
   a. 打开 `example/lib/base/example_model.dart`
   b. 添加新组件的 ExampleModel
      ```dart
      ExampleModel('New Component', 'NewComponent', '/new_component', Icons.new_releases, (context, model) => const TDNewComponentPage()),
      ```

   c. 更新 `example/lib/config.dart`
      ```dart
      'Components': [
        // ... 其他组件
        ExampleModel('New Component', 'NewComponent', '/new_component', Icons.new_releases, (context, model) => const TDNewComponentPage()),
      ],
      ```

6. 演示代码编写
   在 TDNewComponentPage 中：
   ```dart
   @Demo(group: 'newComponent')
   Widget _buildBasicExample() {
     return const TDNewComponent();
   }
   ```

7. API 文档准备
   在 td_new_component.dart 中：
   ```dart
   /// A new component in the TDesign Flutter library.
   ///
   /// This component is used for... (describe the purpose)
   ///
   /// Example:
   /// ```dart
   /// TDNewComponent(
   ///   // Add example properties here
   /// )
   /// ```
   class TDNewComponent extends StatefulWidget {
     /// Creates a TDNewComponent.
     const TDNewComponent({Key? key}) : super(key: key);

     @override
     _TDNewComponentState createState() => _TDNewComponentState();
   }
   ```

8. 主题支持
   确保在组件中正确使用主题：
   ```dart
   final theme = TDTheme.of(context);
   // 使用 theme 中的颜色和样式
   ```

9. 测试
   a. 创建测试文件
      ```
      touch test/components/new_component_test.dart
      ```

   b. 编写测试用例
      ```dart
      import 'package:flutter_test/flutter_test.dart';
      import 'package:tdesign_flutter/tdesign_flutter.dart';

      void main() {
        testWidgets('TDNewComponent basic test', (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: TDTheme(
                data: TDThemeData.defaultData(),
                child: const TDNewComponent(),
              ),
            ),
          );
          // 添加验证逻辑
        });
      }
      ```

10. 代码规范检查
    运行以下命令：
    ```
    dart analyze
    dart format .
    ```

11. 更新文档
    a. 在 CHANGELOG.md 中添加：
       ```markdown
       ## Unreleased

       ### Added
       - New component: TDNewComponent
       ```

    b. 更新 README.md 和 README_zh.md

12. 本地测试
    运行示例应用：
    ```
    cd example
    flutter run
    ```

13. 代码提交
    ```
    git add .
    git commit -m "Add TDNewComponent"
    git push origin feature/new_component_name
    ```

14. 持续集成
    查看 GitHub Actions（如果配置了）的运行结果，根据需要进行修复。

15. 创建 Pull Request
    - 打开您的 GitHub fork 仓库页面
    - 点击 "New pull request"
    - 选择基础分支为原仓库的 dev 分支
    - 填写 PR 描述，详细说明新组件的功能和用法