import 'package:flutter/material.dart';

import '../theme/resource_delegate.dart';

/// Context的扩展,方便使用
extension ContextExtension on BuildContext {
  TDResourceDelegate get resource => TDResourceManager.instance.delegate(this);
}