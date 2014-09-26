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

In the /build/ folder, rename the build.config.dist file to build.config and set your system paths for flex.sdk, android.sdk and android.platformtools.

In extension.xml.dist and platformios.xml.dist, change `<replace_with_air_sdk_version>` with your desired AIR SDK version and rename the files without .dist.

Then from /build/, run 'ant' which will create a MobileAppTrackerANE.ane file in the /dist/ folder.
