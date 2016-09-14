package com.tune.ane;

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

            Log.i(TuneExtensionContext.TAG, "Call " + NAME);
            TuneExtensionContext tec = (TuneExtensionContext)context;
            tec.tune.setGoogleAdvertisingId(googleAdId, limitAdTracking);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }

}
