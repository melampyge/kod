~/Downloads/android-sdk-linux_x86/tools/zipalign -v 4 ../bin/Havatahmini-unsigned.apk ../bin/Havatahmini-unsigned-aligned.apk
/usr/lib/jvm/java-6-sun/bin/jarsigner -verbose -keystore my-release-key.keystore ../bin/Havatahmini-unsigned-aligned.apk alias_name
mv ../bin/Havatahmini-unsigned-aligned.apk ../bin/Havatahmini.apk
