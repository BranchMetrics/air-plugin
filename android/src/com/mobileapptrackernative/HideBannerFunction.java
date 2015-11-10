package com.mobileapptrackernative;

import android.util.Log;
import android.widget.RelativeLayout;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class HideBannerFunction implements FREFunction {
    public static final String NAME = "hideBanner";
    
    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
                
            if (mec.banner != null && mec.layout != null) {
                mec.banner.pause();
                mec.layout.setVisibility(RelativeLayout.GONE);
            }
            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
