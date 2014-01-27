package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetDebugModeFunction implements FREFunction {
    public static final String NAME = "setDebugMode";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            boolean debugMode = false;
            if (passedArgs[0] != null) {
                debugMode = passedArgs[0].getAsBool();
            }

            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            mec.mat.setDebugMode(debugMode);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
