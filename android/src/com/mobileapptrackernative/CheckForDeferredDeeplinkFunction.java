package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class CheckForDeferredDeeplinkFunction implements FREFunction {
    public static final String NAME = "checkForDeferredDeeplink";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            int timeout = 750;
            if (passedArgs[0] != null) {
                timeout = passedArgs[0].getAsInt();
            }

            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            mec.mat.checkForDeferredDeeplink(timeout);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }

}
