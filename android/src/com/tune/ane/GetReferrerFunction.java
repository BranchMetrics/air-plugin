package com.tune.ane;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class GetReferrerFunction implements FREFunction {
    public static final String NAME = "getReferrer";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(TuneExtensionContext.TAG, "Call " + NAME);
            TuneExtensionContext tec = (TuneExtensionContext)context;
            return FREObject.newObject(tec.tune.getInstallReferrer());
        } catch (Exception e) {
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
