# TDesign Flutter v1.0 开发与调试完整指南

> **适用人群**：零 Flutter 经验的开发者
> **目标**：从环境搭建到交付一个符合 v1.0 规范的组件，全流程可执行

---

## 目录

- [第一部分：开发环境搭建](#第一部分开发环境搭建)
- [第二部分：项目结构导航](#第二部分项目结构导航)
- [第三部分：组件开发流程](#第三部分组件开发流程)
- [第四部分：调试方案](#第四部分调试方案)
- [第五部分：测试策略](#第五部分测试策略)
- [第六部分：0.2.x → v1.0 升级路径对照](#第六部分02x--v10-升级路径对照)
- [附录](#附录)

---

## 第一部分：开发环境搭建

### 1.1 基础环境要求

| 项目 | 最低版本 | 推荐版本 | 说明 |
|------|---------|---------|------|
| **Windows** | Windows 10+ | Windows 11 | 64-bit |
| **Flutter SDK** | 3.32.0 | 3.44+ | CI 双矩阵 3.32 + 3.44 |
| **Dart SDK** | 3.5.0+ | 随 Flutter 内置 | 无需单独安装 |
| **Java JDK** | 17 | 17 | Android 编译需要 |
| **Git** | 2.30+ | 最新版 | 版本控制 |
| **IDE** | Android Studio / VS Code | 任选其一 | 需装 Flutter 插件 |
| **Android SDK** | API 36 | API 36+ | 用于 Android 模拟器 |

### 1.2 安装 Flutter SDK（Windows）

```powershell
# 方式一：使用 Chocolatey（推荐）
choco install flutter

# 方式二：手动安装
# 1. 下载 Flutter SDK：https://docs.flutter.dev/get-started/install/windows
# 2. 解压到 C:\flutter（或其他路径，避免带空格的路径如 C:\Program Files\）
# 3. 添加 C:\flutter\bin 到系统 PATH 环境变量
```

验证安装：

```bash
flutter doctor
# 下面每条都应显示 ✓（或按提示修复）
# ✓ Flutter (Channel stable, 3.x.x)
# ✓ Android toolchain
# ✓ Visual Studio (Windows 桌面开发)
# ✓ Android Studio (或 VS Code)
# ✓ Connected device (至少一个可用)
```

关键环境变量（Windows）：

| 变量名 | 推荐值 | 说明 |
|--------|--------|------|
| `ANDROID_HOME` | `%LOCALAPPDATA%\Android\Sdk` | Android SDK 路径 |
| `JAVA_HOME` | JDK 安装目录 | Java 开发套件路径 |

### 1.3 IDE 配置

**推荐 VS Code**（轻量、启动快）或 **Android Studio**（调试功能更全）。二选一即可。

#### VS Code 配置

安装以下扩展：
- **Flutter**（官方插件，必装）
- **Dart**（官方插件，必装）

安装后验证：`Ctrl+Shift+P` → 输入 `Flutter: Run Flutter Doctor`

#### Android Studio 配置

安装以下插件：`File → Settings → Plugins` → 搜索安装：
- **Flutter**
- **Dart**

### 1.4 克隆项目并安装依赖

```bash
# 进入你的工作目录
cd e:/tdesign-flutter-v1

# 进入组件包目录
cd tdesign-component

# 安装 Flutter 依赖
flutter pub get

# 验证环境是否正常
flutter test

# 运行示例应用（需要先启动模拟器或连接真机）
cd example && flutter run
```

### 1.5 Android 模拟器配置（用于调试）

创建模拟器：

**方式一：Android Studio AVD Manager**
1. 打开 Android Studio → 右上角设备下拉 → **AVD Manager**
2. 点击 **Create Virtual Device**
3. 选择 **Pixel 6** 或 **Pixel 7** → Next
4. 选择系统镜像 **Android API 36** (UpsideDownCake)
5. 给模拟器命名 → Finish

**方式二：命令行**
```bash
# 列出可用系统镜像
sdkmanager --list | grep system-images

# 创建模拟器
avdmanager create avd -n pixel_7_api36 -k "system-images;android-36;google_apis;x86_64" -d pixel_7
```

启动模拟器：
```bash
# 启动刚创建的模拟器
emulator -avd pixel_7_api36

# 或列出所有模拟器后启动
emulator -list-avds
```

> **提示**：模拟器很耗内存，建议先用 `flutter run` 在 Web 模式（Chrome）调试，成熟后再跑模拟器验证。

### 1.6 环境验证检查清单

运行以下命令，确保全部通过：

```bash
# 1. Flutter 基础检查
flutter doctor -v

# 2. 项目依赖检查
cd e:/tdesign-flutter-v1/tdesign-component
flutter pub get

# 3. 静态分析检查
flutter analyze

# 4. 现有测试通过
flutter test

# 5. 示例应用能编译
cd example && flutter build apk --debug
```

全部通过后，环境就准备好了。

---

## 第二部分：项目结构导航

### 2.1 顶层目录职责

```
tdesign-flutter-v1/
├── tdesign-component/       ← **核心包：你主要工作的目录**
├── tdesign-adaptation/      ← 屏幕适配包（流水线维护，你不需要改）
├── tdesign-site/            ← 官网文档站点
└── scripts/                 ← 构建脚本
```

### 2.2 核心包详细结构（tdesign-component/）

```
tdesign-component/
│
├── lib/                             ← 源代码
│   ├── tdesign_flutter.dart         ← ★ 对外统一导出入口（用户只需 import 这一个文件）
│   └── src/
│       ├── components/              ← 56 个组件，每个组件一个独立子目录
│       │   ├── button/              ← 以 button 为例
│       │   │   ├── t_button.dart          # Widget 主体
│       │   │   └── t_button_style.dart    # 样式工厂类（v1.0 将重构为 t_button_theme_data.dart）
│       │   ├── switch/              ← B 类组件
│       │   │   ├── t_switch.dart
│       │   │   └── t_cupertino_switch.dart
│       │   ├── input/               ← D 类组件
│       │   │   ├── t_input.dart
│       │   │   ├── input_view.dart
│       │   │   └── t_input_spacer.dart
│       │   └── ...（53 个其他组件）
│       ├── theme/                   ← 主题系统
│       │   ├── t_theme.dart         # TThemeData 核心类
│       │   ├── t_default_theme.dart # 默认主题值
│       │   ├── t_colors.dart        # TDesign 规范颜色
│       │   ├── t_fonts.dart         # 字体样式
│       │   └── ...（其他主题文件）
│       └── util/                    ← 工具函数
│           ├── log.dart
│           ├── platform_util.dart
│           └── ...
│
├── example/                         ← ★ 示例应用（调试组件的主要入口）
│   └── lib/
│       ├── main.dart                # 应用入口
│       ├── home.dart                # 首页导航
│       ├── config.dart              # 组件注册表（exampleMap）
│       ├── page/                    # 每个组件的展示页面
│       │   ├── t_button_page.dart   # Button 示例（39KB）
│       │   ├── t_switch_page.dart   # Switch 示例
│       │   └── ...（71个页面文件）
│       └── component_test/         # 组件专项测试页面
│
├── test/                            ← 单元测试 & Widget 测试
│   ├── helpers/                     # 测试辅助工具
│   └── *_test.dart                  # 各组件测试文件
│
├── assets/                          ← 静态资源（字体等）
├── docs/                            ← ★ 文档（本指南所在目录）
├── pubspec.yaml                     ← 包配置（名称、版本、依赖）
├── analysis_options.yaml            ← 代码规范配置（70+ lint 规则）
└── CHANGELOG.md                     ← 版本变更日志
```

### 2.3 关键文件速查

| 要做什么 | 去哪个文件 |
|---------|-----------|
| 新建一个组件 | `lib/src/components/{组件名}/` 下创建 `.dart` 文件 |
| 让用户能导入新组件 | 在 `lib/tdesign_flutter.dart` 加一行 `export` |
| 写组件示例页面 | `example/lib/page/t_{组件名}_page.dart` |
| 注册示例页面 | `example/lib/config.dart` 的 `exampleMap` |
| 写单元测试 | `test/t_{组件名}_test.dart` |
| 修改代码规范 | `analysis_options.yaml` |
| 添加第三方依赖 | `pubspec.yaml` → `dependencies:`

---

## 第三部分：组件开发流程

### 3.1 v1.0 组件开发总流程

```
第一步              第二步              第三步              第四步              第五步
┌─────────┐      ┌─────────┐      ┌─────────┐      ┌─────────┐      ┌─────────┐
│ 阅读组件 │  →   │ 编写 v1.0│  →   │ 编写组件 │  →   │ 编写测试 │  →   │ 添加    │
│ 设计文档 │      │ 组件代码 │      │ 示例页面 │      │ 代码     │      │ export   │
└─────────┘      └─────────┘      └─────────┘      └─────────┘      └─────────┘
```

### 3.2 第一步：阅读组件设计文档

在开始写代码之前，找到该组件在 v1.0 文档体系中的位置：

```
docs/v1.0/components/
├── 01-base/          ← 基础组件（Button、Icon、Divider 等）
├── 02-navigation/    ← 导航类
├── 03-input/         ← 输入类（Input、Switch、Slider 等）
├── 04-display/       ← 数据展示类
└── 05-feedback/      ← 反馈类
```

以 Button 为例，设计文档路径：`docs/v1.0/components/01-base/button.md`

### 3.3 第二步：编写 v1.0 组件代码

#### 3.3.1 组件代码文件规划

根据 v1.0 规范，每个组件应有以下文件：

```
lib/src/components/{组件名}/
├── t_{组件名}.dart              ← Widget 主体（构造器）
├── t_{组件名}_theme_data.dart   ← ThemeExtension（v1.0 新增）
└── t_{组件名}_resolve.dart      ← 样式合并逻辑（如有需要）
```

#### 3.3.2 构造器四层模型（L1-L4）

每个组件构造器参数按四层组织：

| 层级 | 类别 | 包含参数 | 示例 |
|------|------|---------|------|
| **L1** | 语义级 | `variant`、`size`、`value` | `variant: TButtonVariant.fill` |
| **L2** | 内容级 | `child`、`label`、`icon` | `child: Text('提交')` |
| **L3** | 行为级 | `onPressed`、`onChanged` | `onPressed: () => print('tapped')` |
| **L4** | 样式级 | 颜色、字号、padding | **不放构造器，移到 ThemeData** |
| **P0** | 逃逸舱 | `style`（实例级最终覆盖） | 极端情况使用，日常不推荐 |

#### 3.3.3 关键命名变更对照

| 0.2.x（当前） | v1.0（目标） | 说明 |
|--------------|-------------|------|
| `onTap` | `onPressed` | 对齐 Material |
| `onClick` | `onPressed` | 对齐 Material |
| `type` | `variant` | 语义更准确 |
| `theme`（色方案） | `colorScheme` | 避免与 Theme 系统混淆 |
| `disabled` | 按控制类处理 | 见 §3.3.4 |
| `isOn` / `checked` | `value` | 对齐 Material |
| `isBlock` | 父级 `SizedBox(width: double.infinity)` | 组件不再处理通栏 |

#### 3.3.4 控制类与禁用策略

| 控制类 | 代表组件 | v1.0 禁用方式 |
|--------|---------|--------------|
| **A 类** | Button、Link | `onPressed: null` |
| **B/C 类** | Switch、Checkbox、Slider、Rate | `onChanged: null` |
| **D 类** | Input、Textarea | `enabled: false` 或 `readOnly: true` |
| **E 类** | Popup、Dialog、Toast | 不调用 `show()` 或 `visible: false` |
| **F 类** | Picker、Calendar | `onChanged: null`（但选项级 `.disabled` 保留） |

#### 3.3.5 Button 升级代码对照示例

```dart
// ============ 0.2.x（当前写法） ============
TButton(
  text: '提交',
  type: TButtonType.fill,
  theme: TButtonTheme.primary,
  disabled: true,
  isBlock: true,
  onTap: () => print('clicked'),
)

// ============ v1.0（目标写法） ============
// onPressed: null 表示禁用
// 通栏由父级布局处理
SizedBox(
  width: double.infinity,
  child: TButton(
    child: Text('提交'),
    variant: TButtonVariant.fill,
    colorScheme: TButtonColorScheme.primary,
    onPressed: null, // 禁用
  ),
)
```

#### 3.3.6 Switch 升级代码对照示例

```dart
// ============ 0.2.x ============
TSwitch(
  isOn: _on,
  enable: false,   // 禁用
  onChanged: (v) => true,
)

// ============ v1.0 ============
TSwitch(
  value: _on,
  onChanged: null,  // 禁用
)

// 正常受控用法
TSwitch(
  value: _on,
  onChanged: (v) => setState(() => _on = v),
)
```

#### 3.3.7 Input 升级代码对照示例

```dart
// ============ 0.2.x ============
final _controller = TextEditingController();

TInput(
  controller: _controller,
  onChanged: (v) => print(v),
)

// ============ v1.0 ============
final _controller = TInputController(initialValue: 'hello');

TInput(
  controller: _controller,
  onChanged: (v) => debugPrint(v),  // 仅通知，不控制禁用
  enabled: true,
)

// 非受控一次性初值（不传 controller 时可用）
TInput(initialValue: 'hello', onChanged: (v) => print(v))

// 禁用
TInput(controller: _controller, enabled: false)
// 只读
TInput(controller: _controller, readOnly: true)
```

### 3.4 第三步：编写示例页面

每个新组件或升级后的组件，需要在 `example/` 中添加示例页面。

#### 3.4.1 示例页面文件

```dart
// example/lib/page/t_{组件名}_page.dart
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 组件示例页面
class TButtonPage extends StatelessWidget {
  const TButtonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: 'Button 按钮',
      // 使用 ExampleModule 和 ExampleItem 组织示例
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础按钮',
              builder: (_) => TButton(
                child: const Text('填充按钮'),
                variant: TButtonVariant.fill,
                colorScheme: TButtonColorScheme.primary,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
```

#### 3.4.2 注册示例页面

在 `example/lib/config.dart` 中注册：

```dart
final exampleMap = <String, List<ExamplePageModel>>{
  '基础': [
    // ... 其他组件
    ExamplePageModel(
      text: 'Button 按钮',
      name: 'button',
      pageBuilder: (_) => const TButtonPage(),
    ),
  ],
};
```

#### 3.4.3 代码展示注解（可选）

如果需要展示"查看代码"功能，使用 `@Demo` 注解：

```dart
@Demo(group: 'button')
Widget _buildBasicButton(BuildContext context) {
  // 示例代码...
}
```

并把代码文件放到 `assets/code/button.{方法名}.txt`

### 3.5 第四步：编写测试代码

测试文件放在 `test/` 目录下，命名规则 `t_{组件名}_test.dart`。

#### 3.5.1 基础 Widget 测试模板

```dart
// test/t_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  // 测试套件 1：基础渲染
  group('TButton 基础渲染', () {
    testWidgets('应该能正常渲染按钮', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TButton(
              child: const Text('提交'),
              onPressed: () {},
            ),
          ),
        ),
      );

      // 验证按钮文本存在
      expect(find.text('提交'), findsOneWidget);
    });
  });

  // 测试套件 2：禁用状态
  group('TButton 禁用状态', () {
    testWidgets('onPressed 为 null 时按钮不可点击', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TButton(
              child: const Text('禁用按钮'),
              onPressed: null, // 禁用
            ),
          ),
        ),
      );

      // 尝试点击
      await tester.tap(find.text('禁用按钮'));
      await tester.pump();

      // 验证没有触发点击
      expect(tapped, isFalse);
    });
  });

  // 测试套件 3：variant × colorScheme 组合
  group('TButton 样式矩阵', () {
    testWidgets('primary fill 按钮应该正常渲染', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TButton(
              child: const Text('Primary'),
              variant: TButtonVariant.fill,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.byType(TButton), findsOneWidget);
    });
  });
}
```

#### 3.5.2 v1.0 测试覆盖率要求

| 指标 | 要求 |
|------|------|
| 代码覆盖率 | `lib/src/` 行覆盖率 ≥ 95% |
| CI 矩阵 | Flutter 3.32 + 3.44 |
| 运行命令 | `flutter test --coverage` |

#### 3.5.3 各控制类必测场景

| 控制类 | 必测场景 |
|--------|---------|
| **A 类** | `onPressed` 主路径、`onPressed: null` 禁用 |
| **B/C 类** | `value + onChanged` 受控、`onChanged: null` 禁用 |
| **D 类** | `controller` 路径、`enabled: false` 禁用、`readOnly: true` 只读 |
| **E 类** | 显隐逻辑、无 Widget 级 `disabled` |
| **F 类** | `value + onChanged`、项级 `.disabled` 保留 |
| **Form** | `submit`、`reset`、`validate`、至少一个 `rules` 失败态 |

### 3.6 第五步：导出组件

在 `lib/tdesign_flutter.dart` 中添加导出：

```dart
// 组件
export 'src/components/button/t_button.dart';
export 'src/components/button/t_button_theme_data.dart';  // v1.0 新增
```

> **重要区分**：
> - **要 export**：Widget 类、`show()` 工厂、`ThemeExtension`、Controller、公开枚举
> - **不要 export**：所有 `*Style` 类、内部 Widget、旧版普通类 Theme

---

## 第四部分：调试方案

### 4.1 调试方式总览

| 方式 | 适用场景 | 启动命令 |
|------|---------|---------|
| **Web 热重载** | 快速UI样式调试 | `cd example && flutter run -d chrome` |
| **Android 模拟器** | 移动端真实验证 | `cd example && flutter run` |
| **Flutter DevTools** | 性能分析、Widget 检查 | 启动后在终端按 `v` 打开 |
| **Widget 测试** | 逻辑验证、回归测试 | `flutter test` |
| **单元测试** | 工具类/逻辑函数 | `flutter test test/t_xxx_test.dart` |

### 4.2 启动示例应用调试

```bash
# 1. 进入 example 目录
cd e:/tdesign-flutter-v1/tdesign-component/example

# 2. 确保依赖已安装
flutter pub get

# 3. 运行（会自动列出可用设备让你选择）
flutter run

# 4. 指定设备运行
flutter run -d chrome        # Web / Chrome 浏览器
flutter run -d windows       # Windows 桌面应用
flutter run -d emulator-5554 # 指定 Android 模拟器
```

### 4.3 热重载（Hot Reload）

运行 `flutter run` 后，修改代码并在终端按：

| 按键 | 功能 | 速度 |
|------|------|------|
| **r** | 热重载（Hot Reload） | 1-2 秒，保留状态 |
| **R** | 热重启（Hot Restart） | 5-10 秒，重置状态 |
| **q** | 退出 | - |

热重载适用于修改 UI 布局、颜色、文字等。但如果修改了枚举、修改了 `initState()`、添加了新字段，需要用热重启（`R`）。

### 4.4 Flutter DevTools 使用

DevTools 提供了强大的调试和性能分析功能：

**启动方式**：
1. `flutter run` 启动应用后，终端会显示 DevTools URL
2. 或在终端按 `v` 键自动打开浏览器

**核心功能**：

| 面板 | 用途 | 常用操作 |
|------|------|---------|
| **Widget Inspector** | 可视化 Widget 树 | 点击"Toggle Select Widget Mode"选择任意 UI 元素 |
| **Timeline** | 性能分析 | 查看帧渲染时间，定位卡顿 |
| **Memory** | 内存分析 | 检查内存泄漏 |
| **Debugger** | 断点调试 | 设置断点、查看变量值 |
| **Network** | 网络请求查看 | 查看 HTTP 请求 |

#### Widget Inspector 实战

1. 打开 DevTools → **Flutter Inspector**
2. 点击左上角 **Toggle Select Widget Mode**（或按 `Ctrl+Shift+P` → `Flutter: Toggle Widget Inspector`）
3. 在 App 上点击任意 UI 元素
4. 右侧面板显示该 Widget 的所有属性、约束条件、布局信息

这是调试组件布局问题最有效的方法。

### 4.5 VS Code 断点调试

1. 打开 `example/lib/main.dart`
2. 在代码行号左侧点击设置断点（红点）
3. 按 `F5` 启动调试（或在左侧"运行和调试"面板中选择 "Flutter"）
4. 应用运行到断点处自动暂停
5. 左侧 **VARIABLES** 面板查看变量值
6. **DEBUG CONSOLE** 中可以执行 Dart 表达式
7. 按 `F10` 单步跳过、`F11` 单步进入、`F5` 继续运行

**调试命令面板**：`Ctrl+Shift+P` → 输入 `Flutter:` 查看所有可用命令。

### 4.6 调试技巧速查

| 场景 | 技巧 |
|------|------|
| 不确定某个 Widget 的属性值 | DevTools Widget Inspector 选中查看 |
| 打印调试信息 | `debugPrint('变量值：$value')` |
| 强制红框标记 Widget | 包裹 `DebugPaintSizeEnabled` 或设置断点 |
| 查看主题值 | `print(TTheme.of(context).brandNormalColor)` |
| 查看 Widget 树 | `debugDumpApp()` 在代码中调用 |
| 无法找到字体图标 | 检查 `pubspec.yaml` 中 fonts 配置 |
| 模拟器启动失败 | 冷启动：`emulator -avd {name} -wipe-data` |

### 4.7 常见问题

| 问题 | 解决方法 |
|------|---------|
| `flutter doctor` 显示 `[!] Android toolchain` | 检查 `ANDROID_HOME` 环境变量和 `sdkmanager` |
| `flutter run` 找不到设备 | 先启动模拟器或连接真机；运行 `flutter devices` 查看可用设备 |
| 热重载不生效 | 按 `R` 热重启；或在代码中添加 `const` 关键字缺失时也需要热重启 |
| `pub get` 下载慢 | 设置镜像：`set PUB_HOSTED_URL=https://pub.flutter-io.cn` |

---

## 第五部分：测试策略

### 5.1 测试分层

```
┌─────────────────────────────────────────────────┐
│  真机验证：Android 16 (API 36)、iOS 26           │  ← example 运行
├─────────────────────────────────────────────────┤
│  Widget 测试 + Golden 图像测试                    │  ← flutter test
├─────────────────────────────────────────────────┤
│  单元测试（工具函数、Controller、逻辑）             │  ← flutter test
├─────────────────────────────────────────────────┤
│  静态分析（lint、类型检查）                        │  ← flutter analyze
└─────────────────────────────────────────────────┘
```

### 5.2 常用测试命令

```bash
# 运行所有测试
flutter test

# 运行指定测试文件
flutter test test/t_button_test.dart

# 生成覆盖率报告
flutter test --coverage

# 查看覆盖率（需要安装 lcov）
# Windows: 安装 lcov 后运行
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html

# 静态分析
flutter analyze

# 仅检查特定文件
flutter analyze lib/src/components/button/
```

### 5.3 Golden 图像测试（视觉回归测试）

```dart
// test/t_button_golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  testWidgets('TButton golden - primary fill', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: TButton(
              child: const Text('Primary'),
              variant: TButtonVariant.fill,
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    // 生成/比较 Golden 图像
    await expectLater(
      find.byType(TButton),
      matchesGoldenFile('goldens/t_button_primary_fill.png'),
    );
  });
}
```

运行 Golden 测试：
```bash
# 首次运行（生成参考图像）
flutter test --update-goldens

# 后续运行（与参考图像比较）
flutter test
```

Golden 测试文件放在 `test/goldens/` 目录下。

### 5.4 测试编写 Checklist（发布前必查）

- [ ] 组件基础渲染测试
- [ ] 禁用状态测试（按控制类对应方式）
- [ ] 各 variant/colorScheme 至少一个态
- [ ] `onChanged` / `onPressed` 回调触发测试
- [ ] 主题回退逻辑测试（不传样式参数时走 Theme）
- [ ] 如果有 `mergeExtension` 子树覆盖，需测试覆盖行为
- [ ] 如果有 Form 集成，需测试 submit/reset/validate
- [ ] Golden 图像测试（P0 组件：Button、Slider、TabBar 必须覆盖）

### 5.5 静态分析检查

代码提交前，确保 `flutter analyze` 无警告：

```bash
cd e:/tdesign-flutter-v1/tdesign-component
flutter analyze
```

关键代码规范（来自 `analysis_options.yaml`）：

| 规则 | 说明 |
|------|------|
| `camel_case_types` | 类型名使用大驼峰命名 |
| `use_key_in_widget_constructors` | Widget 构造器要有 key 参数 |
| `prefer_const_constructors` | 优先使用 const 构造 |
| `package_api_docs` | 公开 API 必须有注释 |
| `no_logic_in_create_state` | createState 中不要写逻辑 |

---

## 第六部分：0.2.x → v1.0 升级路径对照

### 6.1 核心变更速查表

| 变更类别 | 0.2.x（旧） | v1.0（新） | 变更决策 |
|---------|------------|-----------|---------|
| **改名** | `onTap` / `onClick` | `onPressed` | ✏️ 改名 |
| **改名** | `type` | `variant` | ✏️ 改名 |
| **改名** | `theme`（颜色方案） | `colorScheme` | ✏️ 改名 |
| **改名** | `isOn` / `checked` | `value` | ✏️ 改名 |
| **改名** | `TButtonTheme`（枚举） | `TButtonColorScheme` | ✏️ 改名 |
| **改名** | `TButtonType` | `TButtonVariant` | ✏️ 改名 |
| **改名** | `disable`/`enable` | 按控制类处理 | ✏️ 改名+策略变更 |
| **合并** | `icon` + `iconWidget` | `icon`（统一为 `Widget?`） | 🔀 合并 |
| **迁入Theme** | 颜色/字号/padding 构造参数 | `T{Xxx}ThemeData` 字段 | 📦 迁入 Theme |
| **移除** | `disabled` 参数 | `onPressed: null` / `onChanged: null` | 🗑️ 移除 |
| **移除** | `isBlock` | 父级 `SizedBox` 处理 | 🗑️ 移除 |
| **移除** | `onLongPress` | 外包手势 `GestureDetector` | 🗑️ 移除 |
| **移除** | `TButtonStyle` 等 Style 类 | 迁入 `T{Xxx}ThemeData` | 🗑️ 移除 |
| **新增** | — | `T{Xxx}ThemeData` (ThemeExtension) | ✨ 新增 |
| **新增** | — | `mergeExtension` 子树覆盖 | ✨ 新增 |
| **新增** | — | `TFormField<T>` 表单桥接器 | ✨ 新增 |

### 6.2 按控制类的组件升级清单

#### A 类组件（Button、Link、Fab、Cell）

| 组件 | 0.2.x 参数 | v1.0 参数 | 禁用方式变更 |
|------|-----------|----------|------------|
| TButton | `disabled: true` + `onTap` | `onPressed: null` | `disabled` → `onPressed: null` |
| TLink | `disabled: true` + `onTap` | `onPressed: null` | 同上 |
| TFab | `disabled: true` + `onTap` | `onPressed: null` | 同上 |
| TCell | `disabled: true` + `onTap` | `onTap: null` | ListTile 系保留 onTap |

#### B/C 类组件（Switch、Checkbox、Slider、Rate）

| 组件 | 0.2.x 参数 | v1.0 参数 | 禁用方式变更 |
|------|-----------|----------|------------|
| TSwitch | `enable: false` + `isOn` | `onChanged: null` + `value` | `enable: false` → `onChanged: null` |
| TCheckbox | `enable: false` + `checked` | `onChanged: null` + `value` | 同上 |
| TSlider | — | `onChanged: null` + `value` | — |
| TRate | `disabled: true` | `onChanged: null` | 同上 |

#### D 类组件（Input、Textarea）

| 组件 | 0.2.x 参数 | v1.0 参数 | 禁用方式变更 |
|------|-----------|----------|------------|
| TInput | 无明确 disabled | `enabled: false` 或 `readOnly: true` | 新增明确禁用控制 |
| TTextarea | 同上 | 同上 | 同上 |

#### E 类组件（Popup、Dialog、Toast）

| 组件 | 0.2.x 参数 | v1.0 参数 |
|------|-----------|----------|
| TPopup | 命令式调用 | `TPopup.show()` 命令式 |
| TDialog | `show()` 实例方法 | `TDialog.showAlert()` / `showConfirm()` 静态方法 |
| TToast | `show*()` 静态方法 | 保持不变 |

### 6.3 升级步骤（单个组件）

```
1. 阅读该组件 v1.0 设计文档（§1 API 定稿）
   ├── 了解新 API、新命名
   ├── 了解变更决策（改名/合并/移除/迁入Theme）
   └── 了解控制类归属

2. 编写新代码
   ├── {组件名}_theme_data.dart  ← 新建 ThemeExtension
   ├── {组件名}_resolve.dart     ← 样式合并（如需要）
   └── t_{组件名}.dart           ← 重构构造器和 build

3. 编写测试
   ├── test/t_{组件名}_test.dart         ← Widget 测试
   └── test/goldens/                     ← Golden 图像测试

4. 更新示例
   └── example/lib/page/t_{组件名}_page.dart  ← 使用 v1.0 API

5. 更新导出
   └── lib/tdesign_flutter.dart  ← 添加/修改 export

6. 验证
   ├── flutter analyze  ← 静态分析通过
   ├── flutter test     ← 测试全部通过
   └── example 可运行    ← 按钮正常渲染交互
```

### 6.4 主题系统升级要点

| 0.2.x | v1.0 | 说明 |
|-------|------|------|
| `TTheme.of(context)` | `Theme.of(context).extension<TThemeData>()` | 不再使用自定义 Theme |
| `systemThemeDataLight` | `TThemeBuilder.light(token)` | 改为 Builder 模式 |
| `TTheme._singleData` | 删除 | 不再使用单例 |
| `TTheme.needMultiTheme()` | 删除 | 多主题走原生机制 |
| 构造器传色值/间距 | 移到 `T{Xxx}ThemeData` 或 P0 `style` | L4 不在构造器 |
| `TButtonStyle` | `TButtonThemeData` | 不 export Style |

子树覆盖的正确姿势：
```dart
// v1.0 正确：mergeExtension 合并
Theme(
  data: Theme.of(context).mergeExtension(
    TButtonThemeData(defaultVariant: TButtonVariant.outline),
  ),
  child: ...,
)

// 错误：copyWith 会覆盖其他 Extension
// Theme.of(context).copyWith(extensions: [...])
```

---

## 附录

### A. 常用 Flutter 命令速查

| 命令 | 说明 |
|------|------|
| `flutter doctor` | 检查开发环境 |
| `flutter devices` | 列出可用设备 |
| `flutter pub get` | 安装依赖 |
| `flutter pub upgrade` | 升级依赖 |
| `flutter run` | 运行应用 |
| `flutter run -d chrome` | 在 Chrome 运行 |
| `flutter test` | 运行测试 |
| `flutter test --coverage` | 运行测试并生成覆盖率 |
| `flutter analyze` | 静态分析 |
| `flutter build apk` | 构建 Android APK |
| `flutter clean` | 清除构建缓存 |
| `flutter create .` | 重新生成平台代码 |

### B. 组件开发模板文件

参考 [component-template.md](./component-template.md)，可直接复制作为新组件的开发起点。

### C. 参考文档索引

| 文档 | 路径 |
|------|------|
| 项目总览 | [README.md](../../README.md) |
| API 规范 | `docs/v1.0/foundation/api.md` |
| 受控模型 | `docs/v1.0/foundation/controlled.md` |
| Theme 方案 | `docs/v1.0/foundation/theme.md` |
| 禁用演变 | `docs/v1.0/foundation/disabled-evolution.md` |
| Form 规范 | `docs/v1.0/foundation/form.md` |
| 组件文档样板 | `docs/v1.0/components/01-base/button.md` |
| 测试规范 | `docs/v1.0/guide/testing.md` |
| 代码规范 | `analysis_options.yaml` |

### D. 图例说明

| 图例 | 含义 |
|------|------|
| ✏️ | 改名 |
| 🔀 | 合并 |
| 📦 | 迁入 Theme |
| 🗑️ | 移除（从构造器删除） |
| ✨ | 新增（v1.0 新增项） |
| 🚫 | 移出 export（不再公开导出） |

---

> **文档版本**：v1.0  
> **最后更新**：2026-06-21  
> **维护者**：TDesign Flutter 团队
