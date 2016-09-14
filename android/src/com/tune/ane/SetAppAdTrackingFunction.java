package com.tune.ane;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetAppAdTrackingFunction implements FREFunction {
    public static final String NAME = "setAppAdTracking";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            boolean adTrackingEnabled = true;
            if (passedArgs[0] != null) {
                adTrackingEnabled = passedArgs[0].getAsBool();
            }

            Log.i(TuneExtensionContext.TAG, "Call " + NAME);
            TuneExtensionContext tec = (TuneExtensionContext)context;
            tec.tune.setAppAdTrackingEnabled(adTrackingEnabled);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
