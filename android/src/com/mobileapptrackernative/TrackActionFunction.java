package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class TrackActionFunction implements FREFunction {
    public static final String NAME = "trackAction";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        if (passedArgs.length == 5) {
            try {
                String event = "";
                double revenue = 0;
                String currency = "";
                String refId = "";
                if (passedArgs[0] != null) {
                    event = passedArgs[0].getAsString();
                }
                if (passedArgs[1] != null) {
                    revenue = passedArgs[1].getAsDouble();
                }
                if (passedArgs[2] != null) {
                    currency = passedArgs[2].getAsString();
                }
                if (passedArgs[3] != null) {
                    refId = passedArgs[3].getAsString();
                }

                Log.i(MATExtensionContext.TAG, "Call " + NAME + " on event: " + event + ", revenue: " + revenue + ", currency: " + currency + ", ref id: " + refId);
                MATExtensionContext mec = (MATExtensionContext)context;
                if (refId.length() > 0) {
                    mec.mat.trackAction(event, revenue, currency, refId);
                } else if (currency.length() > 0) {
                    mec.mat.trackAction(event, revenue, currency);
                } else if (revenue != 0) {
                    mec.mat.trackAction(event, revenue);
                } else {
                    mec.mat.trackAction(event);
                }
                return FREObject.newObject(true);
            } catch (Exception e) {
                Log.d(MATExtensionContext.TAG, "ERROR: " + e);
                e.printStackTrace();
            }
        }
        return null;
    }
}

