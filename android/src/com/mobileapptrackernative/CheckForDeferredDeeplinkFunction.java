package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.mobileapptracker.MATDeeplinkListener;

public class CheckForDeferredDeeplinkFunction implements FREFunction {
    public static final String NAME = "checkForDeferredDeeplink";

    @Override
    public FREObject call(final FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            mec.mat.checkForDeferredDeeplink(new MATDeeplinkListener() {
                @Override
                public void didReceiveDeeplink(String deeplink) {
                    context.dispatchStatusEventAsync("TUNE_DEEPLINK", deeplink);
                }
                
                @Override
                public void didFailDeeplink(String error) {
                    context.dispatchStatusEventAsync("TUNE_DEEPLINK_FAILED", error);
                }
            });
            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }

}
