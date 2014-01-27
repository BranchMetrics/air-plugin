package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class StartAppToAppFunction implements FREFunction {
    public static final String NAME = "startAppToAppTracking";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        if (passedArgs.length == 5) {
            try {
                String offerId = "";
                String publisherAdvertiserId = "";
                String publisherId = "";
                String targetPackageName = "";
                boolean doRedirect = false;

                if (passedArgs[0] != null) {
                    targetPackageName = passedArgs[0].getAsString();
                }
                if (passedArgs[1] != null) {
                    publisherAdvertiserId = passedArgs[1].getAsString();
                }
                if (passedArgs[2] != null) {
                    offerId = passedArgs[2].getAsString();
                }
                if (passedArgs[3] != null) {
                    publisherId = passedArgs[3].getAsString();
                }
                if (passedArgs[4] != null) {
                    doRedirect = passedArgs[4].getAsBool();
                }

                Log.i(MATExtensionContext.TAG, "Call " + NAME);
                MATExtensionContext mec = (MATExtensionContext)context;
                mec.mat.setTracking(publisherAdvertiserId, targetPackageName, publisherId, offerId, doRedirect);

                return FREObject.newObject(true);
            } catch (Exception e) {
                Log.d(MATExtensionContext.TAG, "ERROR: " + e);
                e.printStackTrace();
            }
        }
        return null;
    }
}
