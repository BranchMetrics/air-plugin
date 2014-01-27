
cp build.config.dist build.config
perl -pi -e "s|\<replace_with_flex_home_path\>|$AIRSDK_LOCATION|" build.config
perl -pi -e "s|\<replace_with_android_sdk_path\>|$ANDROIDSDK_LOCATION|" build.config

ant
