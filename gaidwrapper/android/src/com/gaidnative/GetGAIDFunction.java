package com.gaidnative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class GetGAIDFunction implements FREFunction {
    public static final String NAME = "getGoogleAdvertisingId";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        Log.i(GAIDExtensionContext.TAG, "Call " + NAME);
        
        GAIDExtensionContext gec = (GAIDExtensionContext) context;
        gec.act = gec.getActivity();
        gec.getGaidThread();
        
        return null;
    }
}
