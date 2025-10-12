plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.lit"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        // Use Java 11 instead of Java 8
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        // Target JVM 11 for Kotlin
        jvmTarget = "11"
    }

    defaultConfig {
        // Application ID must be unique per app
        applicationId = "com.example.lit"

        // Minimum / target SDKs
        minSdk = flutter.minSdkVersion
        targetSdk = 36

        // Flutter versioning
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for release builds
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
