package com.mobileapptrackernative;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.SimpleTimeZone;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class SetEventDate1Function implements FREFunction {
    public static final String NAME = "setEventDate1";
    
    private final String MAT_DATE_TIME_FORMAT = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"; // ISO 8601 Extended Format (always UTC) -- http://www.w3schools.com/jsref/jsref_toisostring.asp

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        try {
            Date date = null;
            
            String dateString = null;
            if (passedArgs[0] != null) {
                dateString = passedArgs[0].getAsString();
                
                SimpleDateFormat sdf = new SimpleDateFormat(MAT_DATE_TIME_FORMAT, Locale.ENGLISH);
                sdf.setTimeZone(new SimpleTimeZone(SimpleTimeZone.UTC_TIME, "UTC"));
                
                try {
                    date = sdf.parse(dateString);
                    
                    Log.i(MATExtensionContext.TAG, "Call " + NAME);
                    MATExtensionContext mec = (MATExtensionContext)context;
                    mec.mat.setEventDate1(date);
                } catch (ParseException e) {
                    e.printStackTrace();
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