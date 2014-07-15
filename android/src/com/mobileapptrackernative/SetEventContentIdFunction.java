package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetEventContentIdFunction implements FREFunction {
    public static final String NAME = "setEventContentId";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            String contentId = null;
            if (passedArgs[0] != null) {
                contentId = passedArgs[0].getAsString();
            }

            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            mec.mat.setEventContentId(contentId);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}