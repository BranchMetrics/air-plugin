package com.tune.ane;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetAgeFunction implements FREFunction {
    public static final String NAME = "setAge";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(TuneExtensionContext.TAG, "Call " + NAME);
            
            if (passedArgs[0] != null) {
                int age = passedArgs[0].getAsInt();
                TuneExtensionContext tec = (TuneExtensionContext)context;
                tec.tune.setAge(age);
            }

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
