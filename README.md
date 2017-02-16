# TUNE AIR Native Extension

Please see the Quick Start guide here:

[AIR Quick Start](https://developers.tune.com/sdk/adobe-air-quick-start/)

## Building the ANE

### Prerequisites

1. [Install Apache Ant](http://ant.apache.org/bindownload.cgi) if you haven't already

Put the download somewhere permanent and add the bin directory to your PATH

2. [Download the Flex SDK installer](http://flex.apache.org/installer.html) This is the SDK that you need to build the AIR plugin

* Run the downloaded Flex installer
* Select a download location for the Flex SDK (you'll need this location later)
* Choose the latest version of Flex and Air (or whatever you need to build the plugin against) and download (this will take some time)

3. [Download the Android SDK](http://developer.android.com/sdk/index.html)

4. [Download Adobe Flash Builder](https://creative.adobe.com/products/download/flash-builder)

This is the IDE that you build the AIR Plugin with.

* Make sure you have java 6, which the Flash Builder 4.7 depends on [Mac download](https://support.apple.com/kb/DL1572?locale=en_US)

### Developing and testing in the Adobe Flash Builder IDE

1. Run the Adobe Flash Builder

Adobe Flash Builder is built on Eclipse, so it might look familiar to you

2. Choose File -> Import -> Existing Projects into Workspace and then choose the whole sdk-air directory

You should see 9 projects imported into the workspace.

3. Run the TuneANETestApp project on both iOS and Android devices. All the buttons in the test app should work on device without crashes. You can verify the AA requests succeed by looking at debug output from Xcode console or Android LogCat.

### Building the ANE from the command line

1. In the /build/ folder, rename the build.config.dist file to build.config and set your system paths for flex.sdk and android.sdk

2. In extension.xml, platformandroid.xml, and platformios.xml, change the AIR SDK version if needed

3. Then from /build/, run 'ant' which will create a TuneANE.ane file in the /dist/ folder
