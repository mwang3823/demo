# Giữ lại tất cả các class trong Google Play Core
-keep class com.google.android.play.** { *; }

# Giữ lại tất cả các class của deferred components của Flutter
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Giữ lại tất cả các annotations (cần cho code generation)
-keepattributes *Annotation*

# Giữ lại các class SplitCompat (liên quan đến dynamic feature modules)
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }


