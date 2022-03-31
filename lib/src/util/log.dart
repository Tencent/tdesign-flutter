typedef CustomLogPrinter = Function(String level, String tag, String msg);

class Log {
  static CustomLogPrinter? _customLogPrinter;

  static void setCustomLogPrinter(CustomLogPrinter? printer) {
    _customLogPrinter = printer;
  }

  static const String _levelV = 'v';
  static const String _levelD = 'd';
  static const String _levelI = 'i';
  static const String _levelW = 'w';
  static const String _levelE = 'e';

  static void v(String tag, [String msg = '']) => _log(_levelV, tag, msg);

  static void d(String tag, [String msg = '']) => _log(_levelD, tag, msg);

  static void i(String tag, [String msg = '']) => _log(_levelI, tag, msg);

  static void w(String tag, [String msg = '']) => _log(_levelW, tag, msg);

  static void e(String tag, [String msg = '']) => _log(_levelE, tag, msg);

  static void _log(String level, String tag, String msg) {
    _customLogPrinter?.call(level, tag, msg);
  }
}
