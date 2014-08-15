package com.mobileapptrackernative;

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

            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            if (setAndroidId) {
                mec.mat.setAndroidId(Secure.getString(mec.getActivity().getContentResolver(), Secure.ANDROID_ID));
            } else {
                mec.mat.setAndroidId(null);
            }

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
