package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tune.crosspromo.TuneAdMetadata;
import com.tune.crosspromo.TuneInterstitial;

public class ShowInterstitialFunction implements FREFunction {
    public static final String NAME = "showInterstitial";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            if (passedArgs[0] != null) {
                String placement = passedArgs[0].getAsString();
                // Parse metadata object and set values if any are found
                TuneAdMetadata metadata = MATExtensionContext.parseMetadata(passedArgs[1]);
                
                MATExtensionContext mec = (MATExtensionContext)context;
                if (mec.interstitial == null) {
                    mec.interstitial = new TuneInterstitial(context.getActivity());
                }
                mec.interstitial.show(placement, metadata);
            }
            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
