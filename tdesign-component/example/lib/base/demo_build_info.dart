/// 官方 Demo 构建日期统一采用北京时间，避免设备时区改变日期。
String formatDemoBuildDate(String timestamp) {
  final milliseconds = int.tryParse(timestamp.trim());
  if (milliseconds == null) {
    return '未知';
  }
  try {
    final date = DateTime.fromMillisecondsSinceEpoch(
      milliseconds,
      isUtc: true,
    ).add(const Duration(hours: 8));
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  } on ArgumentError {
    return '未知';
  }
}
