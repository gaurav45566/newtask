# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /usr/local/Cellar/android-sdk/24.3.3/tools/proguard/proguard-android.txt

# Google ML Kit - Keep all text recognition classes
-keep class com.google.mlkit.vision.text.** { *; }
-keep interface com.google.mlkit.vision.text.** { *; }

# Keep optional language model classes
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }

# Google ML Kit Commons
-keep class com.google.mlkit.common.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.gms.internal.** { *; }

# Don't warn about missing optional classes
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# Keep all ML Kit models
-keep class com.google.mlkit.**.** { *; }

# Firebase and Google Play Services (if used)
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }