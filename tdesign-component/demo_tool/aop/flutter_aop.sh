# flutter AOP 补丁
# TODO: 指定自己的flutter目录，并且切换到3.10.0版本
flutterDir=/Users/zflyluo/tools/flutter
# TODO:指定当前example的目录，后面不带"/"
projectDir=/Users/zflyluo/WorkSpace/flutter/tdesign_group/tdesign-mobile-flutter/tdesign-component
# 指定aop运行版本
version=3.10.0

# 切换到3.10.0版本
cd $flutterDir
git checkout $version
bin/flutter --version

echo "=====apply aop patch====="
# 应用补丁
git apply $projectDir/demo_tool/aop/$version/aop_flutter_sdk.patch

# 删除flutter_tools缓存
rm bin/cache/flutter_tools.stamp

echo "=====apply aop patch end====="

bin/flutter --version

echo "=====打印日志带'TDFlutterAop'，则表示AOP 应用成功====="

#cd $exampleDir
#flutter clean
#
#cd $flutterDir
#rm bin/cache/flutter_tools.stamp
#
#cd $exampleDir
#$flutterDir/bin/flutter pub get