package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetEventContentTypeFunction implements FREFunction {
    public static final String NAME = "setEventContentType";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            String contentType = null;
            if (passedArgs[0] != null) {
                contentType = passedArgs[0].getAsString();
            }

            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            mec.mat.setEventContentType(contentType);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}