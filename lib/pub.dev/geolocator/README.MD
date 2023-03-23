# 注意：
## 1、修改build.gradle的compileSdkVersion版本
```gradle
android {
    // compileSdkVersion flutter.compileSdkVersion
    compileSdkVersion 33
}
```
## 2、AndroidManifest.xml添加相应权限
```xml
<!-- Always include this permission -->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<!-- Include only if your app benefits from precise location access. -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```