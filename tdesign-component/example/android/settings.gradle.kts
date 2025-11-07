pluginManagement {
    repositories {
        // 只保留必要的公共仓库
        google()
        mavenCentral()
        gradlePluginPortal()
        // 移除 mavenLocal() 声明
    }

    // 保留Flutter SDK路径配置
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def sdkPath = properties.getProperty("flutter.sdk")
        if (sdkPath == null) {
            throw new GradleException("Flutter SDK path not defined. Ensure local.properties contains flutter.sdk")
        }
        return sdkPath
    }
    settings.ext.flutterSdkPath = flutterSdkPath()
    includeBuild("${settings.ext.flutterSdkPath}/packages/flutter_tools/gradle")
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.3.0" apply false // 确保使用8.3.0或更高
    id "org.jetbrains.kotlin.android" version "1.9.0" apply false // 更新Kotlin版本
}

dependencyResolutionManagement {
    // 关键修改：使用FAIL_ON_PROJECT_REPOS策略
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)

    repositories {
        google()
        mavenCentral()
        // 添加Flutter引擎仓库
        maven {
            url "${settings.ext.flutterSdkPath}/bin/cache/artifacts/engine"
        }
    }
}

include ":app"