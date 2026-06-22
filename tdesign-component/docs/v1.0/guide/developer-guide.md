# v1.0 开发指南

> 搭环境、认目录。  
> **开发仓库**：[github.com/RSS1102/tdesign-flutter-v1](https://github.com/RSS1102/tdesign-flutter-v1)  
> 组件规范 → [foundation/](../foundation/) · 写组件 md → [component-doc.md](./component-doc.md) · 测试 → [testing.md](./testing.md) · 文档生成 → [doc-generation.md](./doc-generation.md)

---

## 1. 开发环境

| 项 | v1.0 |
|---|---|
| 开发仓库 | [RSS1102/tdesign-flutter-v1](https://github.com/RSS1102/tdesign-flutter-v1) |
| Flutter SDK | ≥ **3.32.0** |
| CI | **3.32** + **3.44** 双矩阵 |
| 覆盖率 | `lib/src` ≥ **95%** |
| 测试 | `flutter test` + example 可构建 |

详情 → [testing.md §1](./testing.md#1-ci-与覆盖率)

---

## 2. 项目结构

```text
tdesign-flutter/
└── tdesign-component/
    ├── lib/
    │   ├── tdesign_flutter.dart      # 公开 export
    │   └── src/
    │       ├── components/{组件}/    # 组件实现
    │       ├── theme/                # Token、TThemeData
    │       └── util/                 # 工具
    ├── example/                      # 演示 App
    ├── test/                         # 测试
    ├── demo_tool/                    # API / 演示代码生成
    └── docs/v1.0/                    # 设计文档
```

| 路径 | 说明 |
|---|---|
| `lib/src/components/{组件}/` | 实现组件；文档文首 `源码` 字段即此路径 |
| `lib/tdesign_flutter.dart` | 对外 export 入口 |
| `example/lib/page/` | 演示页；`main.dart` 的 `exampleMap` 注册 |
| `demo_tool/all_build.sh` | 批量生成 API 文档；见 [doc-generation.md](./doc-generation.md) |

> **`tdesign_flutter_adaptation`**：`pubspec` 与 CI 会引用，**组件开发无需关注**（由 `init.sh` / 流水线处理）。

---

## 3. 本地起步

```bash
git clone https://github.com/RSS1102/tdesign-flutter-v1.git
cd tdesign-flutter-v1/tdesign-component
flutter pub get
flutter test
cd example && flutter run
```
