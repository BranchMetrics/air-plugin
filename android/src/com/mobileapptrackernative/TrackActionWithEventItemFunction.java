package com.mobileapptrackernative;

import java.util.ArrayList;

import android.util.Log;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.mobileapptracker.MATEventItem;

public class TrackActionWithEventItemFunction implements FREFunction {
    public static final String NAME = "trackActionWithEventItem";

    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        if (passedArgs.length >= 5) {
            try {
                String event = "";
                double revenue = 0;
                String currency = "";
                String refId = "";
                ArrayList<MATEventItem> eventItems = new ArrayList<MATEventItem>();
                String receiptData = null;
                String receiptSignature = null;
                
                if (passedArgs[0] != null) {
                    event = passedArgs[0].getAsString();
                }
                // Read in list of MATEventItems
                if (passedArgs[1] != null) {
                    FREArray freEventItems = (FREArray) passedArgs[1];
                    
                    String itemName;
                    double unitPrice;
                    int itemQuantity;
                    double itemRevenue;
                    String attribute1;
                    String attribute2;
                    String attribute3;
                    String attribute4;
                    String attribute5;

                    for (int i = 0; i < freEventItems.getLength(); i+=9) {
                        itemName = freEventItems.getObjectAt(i).getAsString();
                        unitPrice = freEventItems.getObjectAt(i+1).getAsDouble();
                        itemQuantity = freEventItems.getObjectAt(i+2).getAsInt();
                        itemRevenue = freEventItems.getObjectAt(i+3).getAsDouble();
                        attribute1 = freEventItems.getObjectAt(i+4).getAsString();
                        attribute2 = freEventItems.getObjectAt(i+5).getAsString();
                        attribute3 = freEventItems.getObjectAt(i+6).getAsString();
                        attribute4 = freEventItems.getObjectAt(i+7).getAsString();
                        attribute5 = freEventItems.getObjectAt(i+8).getAsString();
                        
                        MATEventItem eventItem = new MATEventItem(itemName, itemQuantity, unitPrice, itemRevenue, attribute1, attribute2, attribute3, attribute4, attribute5);
                        
                        eventItems.add(eventItem);
                    }
                }
                if (passedArgs[2] != null) {
                    revenue = passedArgs[2].getAsDouble();
                }
                if (passedArgs[3] != null) {
                    currency = passedArgs[3].getAsString();
                }
                if (passedArgs[4] != null) {
                    refId = passedArgs[4].getAsString();
                }
                if (passedArgs[7] != null) {
                    receiptData = passedArgs[7].getAsString();
                }
                if (passedArgs[8] != null) {
                    receiptSignature = passedArgs[8].getAsString();
                }

                Log.i(MATExtensionContext.TAG, "Call " + NAME + " on event: " + event);
                MATExtensionContext mec = (MATExtensionContext)context;
                if (refId.length() > 0) {
                    mec.mat.setRefId(refId);
                }
                mec.mat.setRevenue(revenue);
                mec.mat.setCurrencyCode(currency);
                mec.mat.trackAction(event, eventItems, receiptData, receiptSignature);
                
                return FREObject.newObject(true);
            } catch (Exception e) {
                Log.d(MATExtensionContext.TAG, "ERROR: " + e);
                e.printStackTrace();
            }
        }
        return null;
    }
}
