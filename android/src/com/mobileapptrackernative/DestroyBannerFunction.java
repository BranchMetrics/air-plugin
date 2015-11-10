package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class DestroyBannerFunction implements FREFunction {
    public static final String NAME = "destroyBanner";
    
    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
                
            if (mec.banner != null) {
                mec.banner.destroy();
                mec.banner = null;
            }
            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
