plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    
    // 🔑 AGREGADO: Plugin de Google Services para Firebase
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.inicio_home_reminder_prueba1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.inicio_home_reminder_prueba1"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// =========================================================
// 🔑 SECCIÓN AÑADIDA: DEPENDENCIAS DE FIREBASE
// =========================================================
dependencies {
    // Import the Firebase BoM (Bill of Materials) para gestionar versiones automáticamente
    // He puesto una versión actualizada, pero usa la que Firebase te indique si difiere
    implementation(platform("com.google.firebase:firebase-bom:33.1.0")) 
    
    // Add the dependency for Firebase Analytics
    // Cuando usas el BoM, no necesitas especificar la versión aquí.
    implementation("com.google.firebase:firebase-analytics") 
    
    // Dependencia de Kotlin (si ya está en tu proyecto, omítela)
    // implementation(kotlin("stdlib-jdk8"))
    
    // Otras dependencias que puedas tener, como las de Firebase Auth:
    // implementation("com.google.firebase:firebase-auth") 
}