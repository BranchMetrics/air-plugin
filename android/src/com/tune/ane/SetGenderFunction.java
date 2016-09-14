package com.tune.ane;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tune.TuneGender;

public class SetGenderFunction implements FREFunction {
    public static final String NAME = "setGender";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(TuneExtensionContext.TAG, "Call " + NAME);
            
            if (passedArgs[0] != null) {
                int gender = passedArgs[0].getAsInt();
                
                TuneExtensionContext tec = (TuneExtensionContext)context;
                if (gender == 0) {
                    tec.tune.setGender(TuneGender.MALE);
                } else if (gender == 1) {
                    tec.tune.setGender(TuneGender.FEMALE);
                } else {
                    tec.tune.setGender(TuneGender.UNKNOWN);
                }
            }
            
            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
