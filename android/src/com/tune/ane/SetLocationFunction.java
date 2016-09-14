package com.tune.ane;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetLocationFunction implements FREFunction {
    public static final String NAME = "setLocation";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(TuneExtensionContext.TAG, "Call " + NAME);
            TuneExtensionContext tec = (TuneExtensionContext)context;
            
            if (passedArgs[0] != null) {
                double latitude = passedArgs[0].getAsDouble();
                tec.tune.setLatitude(latitude);
            }
            if (passedArgs[1] != null) {
                double longitude = passedArgs[1].getAsDouble();
                tec.tune.setLongitude(longitude);
            }
            if (passedArgs[2] != null) {
                double altitude = passedArgs[2].getAsDouble();
                tec.tune.setAltitude(altitude);
            }
            
            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
