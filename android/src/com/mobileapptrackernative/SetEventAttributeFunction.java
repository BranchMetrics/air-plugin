package com.mobileapptrackernative;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetEventAttributeFunction implements FREFunction {
    public static final String NAME = "setEventAttribute";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            int attributeNum = 0;
            if (passedArgs[0] != null) {
                attributeNum = passedArgs[0].getAsInt();
            }
            
            String attributeValue = null;
            if (passedArgs[1] != null) {
                attributeValue = passedArgs[1].getAsString();
            }
            
            Log.i(MATExtensionContext.TAG, "Call " + NAME);
            MATExtensionContext mec = (MATExtensionContext)context;
            
            // Set corresponding event attribute value
            switch (attributeNum) {
                case 1:
                    mec.mat.setEventAttribute1(attributeValue);
                    break;
                case 2:
                    mec.mat.setEventAttribute2(attributeValue);
                    break;
                case 3:
                    mec.mat.setEventAttribute3(attributeValue);
                    break;
                case 4:
                    mec.mat.setEventAttribute4(attributeValue);
                    break;
                case 5:
                    mec.mat.setEventAttribute5(attributeValue);
                    break;
                default:
                    break;
            }

            return FREObject.newObject(true);
        } catch (Exception e) {
            Log.d(MATExtensionContext.TAG, "ERROR: " + e);
            e.printStackTrace();
        }
        return null;
    }
}
