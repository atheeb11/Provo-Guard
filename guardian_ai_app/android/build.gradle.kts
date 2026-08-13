allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    val configureAndroid = {
        val android = project.extensions.findByName("android")
        if (android != null) {
            if (project.name == "file_picker" || project.name == "flutter_plugin_android_lifecycle") {
                try {
                    val setCompileSdk = android.javaClass.getMethod("setCompileSdk", java.lang.Integer.TYPE)
                    setCompileSdk.invoke(android, 36)
                } catch (e: Exception) {
                    try {
                        val compileSdkVersion = android.javaClass.getMethod("compileSdkVersion", java.lang.Integer.TYPE)
                        compileSdkVersion.invoke(android, 36)
                    } catch (e2: Exception) {}
                }
            }
        }
    }

    if (project.state.executed) {
        configureAndroid()
    } else {
        project.afterEvaluate {
            configureAndroid()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
