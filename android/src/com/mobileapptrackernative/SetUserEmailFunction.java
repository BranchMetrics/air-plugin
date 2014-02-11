package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetUserEmailFunction implements FREFunction {
    public static final String NAME = "setUserEmail";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            String userEmail = null;
            if (passedArgs[0] != null) {
                userEmail = passedArgs[0].getAsString();
            }

            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            mec.mat.setUserEmail(userEmail);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
