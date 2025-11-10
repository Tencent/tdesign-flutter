pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

dependencyResolutionManagement {
    // repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        // 添加国内镜像源
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://repo.huaweicloud.com/repository/maven") } // 华为云
        maven { url = uri("https://mirrors.tencent.com/nexus/repository/maven-public") } // 腾讯云

        // 后面报错会用到
        maven { url = uri("https://storage.flutter-io.cn/download.flutter.io")}
        maven { url = uri("https://maven.aliyun.com/repository/jcenter")}

        // 保留默认仓库（镜像源缺失时回退）
        google()
        mavenCentral()
    }
}

include(":app")
