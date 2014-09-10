cp build.config.dist build.config
perl -pi -e "s|\<replace_with_flex_home_path\>|$AIRSDK_LOCATION|" build.config
perl -pi -e "s|\<replace_with_android_sdk_path\>|$ANDROIDSDK_LOCATION|" build.config
perl -pi -e "s|\<replace_with_swf_version\>|$SWF_VERSION|" build.config
perl -pi -e "s|\<replace_with_google_play_services_lib_path>|$GOOGLEPLAYLIB_LOCATION|" build.config

cp extension.xml.dist extension.xml
perl -pi -e "s|\<replace_with_air_sdk_version\>|$AIRSDK_VERSION|" extension.xml

cp platform.xml.dist platform.xml
perl -pi -e "s|\<replace_with_air_sdk_version\>|$AIRSDK_VERSION|" platform.xml

cp platformios.xml.dist platformios.xml
perl -pi -e "s|\<replace_with_air_sdk_version\>|$AIRSDK_VERSION|" platformios.xml

ant