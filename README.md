# MAT AIR Native Extension

Please see the Quick Start guide here:

[AIR Quick Start](https://developers.mobileapptracking.com/adobe-air-plugin/)

### Building the ANE

The following tools are required to build the MobileAppTracking ANE:

__Adobe AIR__

[http://get.adobe.com/air/](http://get.adobe.com/air/)

__Adobe Flex SDK__

[http://www.adobe.com/devnet/flex/flex-sdk-download.html](http://www.adobe.com/devnet/flex/flex-sdk-download.html)

__Android SDK__

[http://developer.android.com/sdk/index.html](http://developer.android.com/sdk/index.html)

__Google Play Services__

[https://developers.google.com/android/guides/setup](https://developers.google.com/android/guides/setup)

In the /build/ folder, rename the build.config.dist file to build.config and set your system paths for flex.sdk and android.sdk.

In extension.xml, platformandroid.xml, and platformios.xml, change the AIR SDK version if needed.

Then from /build/, run 'ant' which will create a MobileAppTrackerANE.ane file in the /dist/ folder.
