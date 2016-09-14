package com.tune.ane;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetUserEmailFunction implements FREFunction {
    public static final String NAME = "setUserEmail";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            String userEmail = null;
            if (passedArgs[0] != null) {
                userEmail = passedArgs[0].getAsString();
            }

            Log.i(TuneExtensionContext.TAG, "Call " + NAME);
            TuneExtensionContext tec = (TuneExtensionContext)context;
            tec.tune.setUserEmail(userEmail);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
