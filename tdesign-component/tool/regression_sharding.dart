/// 按组件名字符编码之和的奇偶固定分组；不依赖耗时、清单顺序或其他组件。
/// 组件名不变，组号不变；组件测试和 Golden 共用此规则。
int regressionShardForComponent(String component) =>
    component.codeUnits.fold<int>(0, (sum, code) => sum + code) % 2 + 1;

/// 无参数保持完整执行，只允许选择第 1 或第 2 组。
int? parseRegressionShard(List<String> arguments) {
  if (arguments.isEmpty) {
    return null;
  }
  if (arguments.length != 1 ||
      !const ['--shard=1', '--shard=2'].contains(arguments.single)) {
    throw const FormatException('Expected --shard=1 or --shard=2.');
  }
  return int.parse(arguments.single.substring('--shard='.length));
}
