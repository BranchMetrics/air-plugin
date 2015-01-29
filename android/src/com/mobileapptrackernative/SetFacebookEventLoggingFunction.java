package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetFacebookEventLoggingFunction implements FREFunction {
    public static final String NAME = "setFacebookEventLogging";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            boolean fbEventLogging = false;
            if (passedArgs[0] != null) {
                fbEventLogging = passedArgs[0].getAsBool();
            }

            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            mec.mat.setFacebookEventLogging(context.getActivity(), fbEventLogging);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }

}
