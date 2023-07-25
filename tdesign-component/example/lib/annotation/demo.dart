/// 生成代码的注解
class Demo {

  /// 注解分组，其与标注的方法名唯一表示一份演示代码文件
  /// 请直接写字符串，不要做拼接或变量引用等操作
  final String? group;

  const factory Demo({String? group}) = Demo._;

  const Demo._({this.group});
}