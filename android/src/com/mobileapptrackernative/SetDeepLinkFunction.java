package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetDeepLinkFunction implements FREFunction {
    public static final String NAME = "setDeepLink";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            String deepLinkUrl = null;
            if (passedArgs[0] != null) {
                deepLinkUrl = passedArgs[0].getAsString();
            }

            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            mec.mat.setReferralUrl(deepLinkUrl);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }

        return null;
    }
}
