package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.mobileapptracker.MATGender;

public class SetGenderFunction implements FREFunction {
    public static final String NAME = "setGender";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            
            if (passedArgs[0] != null) {
                int gender = passedArgs[0].getAsInt();
                
                MATExtensionContext mec = (MATExtensionContext)context;
                if (gender == 0) {
                    mec.mat.setGender(MATGender.MALE);
                } else if (gender == 1) {
                    mec.mat.setGender(MATGender.FEMALE);
                } else {
                    mec.mat.setGender(MATGender.UNKNOWN);
                }
            }
            
            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
