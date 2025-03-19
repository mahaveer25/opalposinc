# Keep the MuPDFCore class and all its fields and methods
-keep class com.printer.sdk.mupdf.MuPDFCore { *; }

# Keep all native methods in the MuPDFCore class
-keepclasseswithmembers class * {
    native <methods>;
}

# Prevent obfuscation of the field "globals" in the MuPDFCore class
-keepclassmembers class com.printer.sdk.mupdf.MuPDFCore {
    long globals;
}

# Keep all classes from the printer SDK
-keep class com.printer.sdk.** { *; }

# Keep the R class and its inner classes (important if using resources)
-keep class **.R$* { *; }
-keep class **.R { *; }
