package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetLocationFunction implements FREFunction {
    public static final String NAME = "setLocation";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            
            if (passedArgs[0] != null) {
                double latitude = passedArgs[0].getAsDouble();
                mec.mat.setLatitude(latitude);
            }
            if (passedArgs[1] != null) {
                double longitude = passedArgs[1].getAsDouble();
                mec.mat.setLongitude(longitude);
            }
            if (passedArgs[2] != null) {
                double altitude = passedArgs[2].getAsDouble();
                mec.mat.setAltitude(altitude);
            }
            
            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
