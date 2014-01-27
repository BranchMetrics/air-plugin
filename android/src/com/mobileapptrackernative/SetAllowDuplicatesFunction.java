package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetAllowDuplicatesFunction implements FREFunction {
    public static final String NAME = "setAllowDuplicates";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            boolean allowDuplicates = false;
            if (passedArgs[0] != null) {
                allowDuplicates = passedArgs[0].getAsBool();
            }

            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            mec.mat.setAllowDuplicates(allowDuplicates);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
