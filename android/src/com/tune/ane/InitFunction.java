package com.tune.ane;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tune.Tune;

public class InitFunction implements FREFunction {
    public static final String NAME = "init";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(TuneExtensionContext.TAG, "Initialize Tune");
            TuneExtensionContext tec = (TuneExtensionContext) context;

            // Get advertiser id and conversion key from params passed to initMAT
            String advertiserId = "";
            String conversionKey = "";
            try {
                advertiserId = passedArgs[0].getAsString();
                conversionKey = passedArgs[1].getAsString();
            } catch (Exception e) {
                e.printStackTrace();
            }
            tec.tune = Tune.init(context.getActivity(), advertiserId, conversionKey);
            tec.tune.setPluginName("air");
            tec.tune.setReferralSources(context.getActivity());

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }

        return null;
    }

}
