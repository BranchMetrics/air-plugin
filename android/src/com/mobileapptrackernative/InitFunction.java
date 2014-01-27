package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.mobileapptracker.MobileAppTracker;

public class InitFunction implements FREFunction {
    public static final String NAME = "initNativeCode";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(MATExtensionContext.TAG, "Initialize MobileAppTracker");
            MATExtensionContext mec = (MATExtensionContext) context;

            // Get advertiser id and conversion key from params passed to initNativeCode
            String advertiserId = "";
            String conversionKey = "";
            try {
                advertiserId = passedArgs[0].getAsString();
                conversionKey = passedArgs[1].getAsString();
            } catch (Exception e) {
                e.printStackTrace();
            }
            mec.mat = new MobileAppTracker(context.getActivity(), advertiserId, conversionKey);
            mec.mat.setPluginName("air");

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }

        return null;
    }

}
