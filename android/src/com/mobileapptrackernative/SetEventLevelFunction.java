package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetEventLevelFunction implements FREFunction {
    public static final String NAME = "setEventLevel";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            
            if (passedArgs[0] != null) {
                int level = passedArgs[0].getAsInt();
                MATExtensionContext mec = (MATExtensionContext)context;
                mec.mat.setEventLevel(level);
            }

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
