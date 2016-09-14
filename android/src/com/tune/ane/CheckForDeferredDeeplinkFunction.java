package com.tune.ane;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tune.TuneDeeplinkListener;

public class CheckForDeferredDeeplinkFunction implements FREFunction {
    public static final String NAME = "checkForDeferredDeeplink";

    @Override
    public FREObject call(final FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(TuneExtensionContext.TAG, "Call " + NAME);
            TuneExtensionContext tec = (TuneExtensionContext)context;
            tec.tune.checkForDeferredDeeplink(new TuneDeeplinkListener() {
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
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }

}
