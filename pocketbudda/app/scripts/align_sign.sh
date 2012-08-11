~/Downloads/android-sdk-linux_x86/tools/zipalign -v 4 ../../bin/Pocketbudda-unsigned.apk ../../bin/Pocketbudda-unsigned-aligned.apk
/usr/lib/jvm/java-6-sun/bin/jarsigner -verbose -keystore my-release-key.keystore ../../bin/Pocketbudda-unsigned-aligned.apk alias_name
mv ../../bin/Pocketbudda-unsigned-aligned.apk ../../bin/Pocketbudda.apk
