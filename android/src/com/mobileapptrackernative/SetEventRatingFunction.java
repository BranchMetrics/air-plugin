package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetEventRatingFunction implements FREFunction {
    public static final String NAME = "setEventRating";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            
            if (passedArgs[0] != null) {
                double rating = passedArgs[0].getAsDouble();
                MATExtensionContext mec = (MATExtensionContext)context;
                mec.mat.setEventRating((float)rating);
            }

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
