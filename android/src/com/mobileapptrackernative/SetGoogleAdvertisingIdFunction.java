package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetGoogleAdvertisingIdFunction implements FREFunction {
    public static final String NAME = "setGoogleAdvertisingId";
    
    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            String googleAdId = null;
            if (passedArgs[0] != null) {
                googleAdId = passedArgs[0].getAsString();
            }
            
            boolean limitAdTracking = false;
            if (passedArgs[1] != null) {
                limitAdTracking = passedArgs[1].getAsBool();
            }

            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            mec.mat.setGoogleAdvertisingId(googleAdId, limitAdTracking);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }

}
