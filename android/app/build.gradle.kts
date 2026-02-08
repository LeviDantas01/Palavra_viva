plugins {
    id("com.android.application")
    id("kotlin-android")
    // O plugin do Flutter deve ser aplicado após os plugins do Android e Kotlin.
    id("dev.flutter.flutter-gradle-plugin")
}

// --- INÍCIO DA CONFIGURAÇÃO DE ASSINATURA (KEYSTORE) ---
import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
// --- FIM DA CONFIGURAÇÃO DE ASSINATURA ---

android {
    namespace = "com.example.versiculos_diarios" // <--- CONFIRA SE ESSE É O SEU NAMESPACE
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        // TODO: Especifique seu ID de aplicativo exclusivo (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.versiculos_diarios" // <--- CONFIRA SEU ID AQUI TAMBÉM
        // Você pode atualizar os valores a seguir para corresponder ao target SDK do seu app.
        // Para os valores padrão, o Flutter usa a versão mais recente disponível.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // AQUI ESTÁ A CORREÇÃO PARA O KOTLIN:
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            // Verificação de segurança para o arquivo
            val storeFileVal = keystoreProperties.getProperty("storeFile")
            if (storeFileVal != null) {
                storeFile = file(storeFileVal)
            }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        getByName("release") {
            // AQUI CONECTAMOS A ASSINATURA AO BUILD DE RELEASE
            signingConfig = signingConfigs.getByName("release")
            
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}