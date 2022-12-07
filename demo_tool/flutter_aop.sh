# flutter AOP 补丁
# 指定自己的flutter目录，并且切换到3.0.5版本
flutterDir=/Users/zflyluo/tools/flutter
# 指定当前example的目录，后面不带"/"
exampleDir=/Users/zflyluo/WorkSpace/flutter/tdesign_group/tdesign-flutter/example

# 切换到3.0.5版本
cd $flutterDir
git checkout 3.0.5
bin/flutter --version

echo "=====apply aop patch====="
# 应用补丁
git apply $exampleDir/transform/aop_flutter_sdk_3.0.5.patch

# 删除flutter_tools缓存
rm bin/cache/flutter_tools.stamp

echo "=====apply aop patch end====="

bin/flutter --version

echo "=====打印日志带'FlutterAop'，则表示AOP 应用成功====="