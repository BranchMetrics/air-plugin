package com.tune.ane;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetPayingUserFunction implements FREFunction {
    public static final String NAME = "setPayingUser";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            boolean payingUser = false;
            if (passedArgs[0] != null) {
                payingUser = passedArgs[0].getAsBool();
            }

            Log.i(TuneExtensionContext.TAG, "Call " + NAME);
            TuneExtensionContext tec = (TuneExtensionContext)context;
            tec.tune.setIsPayingUser(payingUser);

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
