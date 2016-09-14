package com.tune.ane;

import android.provider.Settings.Secure;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetAndroidIdFunction implements FREFunction {
    public static final String NAME = "setAndroidId";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            boolean setAndroidId = false;
            if (passedArgs[0] != null) {
                setAndroidId = passedArgs[0].getAsBool();
            }

            Log.i(TuneExtensionContext.TAG, "Call " + NAME);
            TuneExtensionContext tec = (TuneExtensionContext)context;
            if (setAndroidId) {
                tec.tune.setAndroidId(Secure.getString(tec.getActivity().getContentResolver(), Secure.ANDROID_ID));
            } else {
                tec.tune.setAndroidId(null);
            }

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
