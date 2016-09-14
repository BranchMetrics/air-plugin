package com.tune.ane;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.SimpleTimeZone;

import android.util.Log;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.tune.TuneEvent;
import com.tune.TuneEventItem;

public class MeasureEventFunction implements FREFunction {
    public static final String NAME = "measureEvent";
    
    @Override
    public FREObject call(FREContext context, FREObject[] passedArgs) {
        if (passedArgs.length == 20) {
            try {
                String eventName = "";
                double revenue = 0;
                String currencyCode = "";
                String refId = "";
                ArrayList<TuneEventItem> eventItems = new ArrayList<TuneEventItem>();
                String receipt = "";
                String receiptSignature = "";
                String attribute1 = "";
                String attribute2 = "";
                String attribute3 = "";
                String attribute4 = "";
                String attribute5 = "";
                String contentId = "";
                String contentType = "";
                Date date1 = null;
                Date date2 = null;
                int level = 0;
                int quantity = 0;
                double rating = 0;
                String searchString = "";
                
                if (passedArgs[0] != null) {
                    eventName = getDefinedString(passedArgs[0]);
                }
                if (passedArgs[1] != null) {
                    FREArray freEventItems = (FREArray) passedArgs[1];
                    
                    String itemName = "";
                    double unitPrice = 0;
                    int itemQuantity = 0;
                    double itemRevenue = 0;
                    String itemAttribute1 = "";
                    String itemAttribute2 = "";
                    String itemAttribute3 = "";
                    String itemAttribute4 = "";
                    String itemAttribute5 = "";

                    for (int i = 0; i < freEventItems.getLength(); i += 9) {
                        if (freEventItems.getObjectAt(i) != null) {
                            itemName = freEventItems.getObjectAt(i).getAsString();
                        }
                        if (freEventItems.getObjectAt(i + 1) != null) {
                            unitPrice = freEventItems.getObjectAt(i + 1).getAsDouble();
                        }
                        if (freEventItems.getObjectAt(i + 2) != null) {
                            itemQuantity = freEventItems.getObjectAt(i + 2).getAsInt();
                        }
                        if (freEventItems.getObjectAt(i + 3) != null) {
                            itemRevenue = freEventItems.getObjectAt(i + 3).getAsDouble();
                        }
                        if (freEventItems.getObjectAt(i) != null) {
                            itemAttribute1 = freEventItems.getObjectAt(i + 4).getAsString();
                        }
                        if (freEventItems.getObjectAt(i) != null) {
                            itemAttribute2 = freEventItems.getObjectAt(i + 5).getAsString();
                        }
                        if (freEventItems.getObjectAt(i) != null) {
                            itemAttribute3 = freEventItems.getObjectAt(i + 6).getAsString();
                        }
                        if (freEventItems.getObjectAt(i) != null) {
                            itemAttribute4 = freEventItems.getObjectAt(i + 7).getAsString();
                        }
                        if (freEventItems.getObjectAt(i) != null) {
                            itemAttribute5 = freEventItems.getObjectAt(i + 8).getAsString();
                        }
                        
                        TuneEventItem eventItem = new TuneEventItem(itemName)
                                .withQuantity(itemQuantity)
                                .withUnitPrice(unitPrice)
                                .withRevenue(itemRevenue)
                                .withAttribute1(itemAttribute1)
                                .withAttribute2(itemAttribute2)
                                .withAttribute3(itemAttribute3)
                                .withAttribute4(itemAttribute4)
                                .withAttribute5(itemAttribute5);
                        
                        eventItems.add(eventItem);
                    }
                }
                if (passedArgs[2] != null) {
                    revenue = passedArgs[2].getAsDouble();
                }
                if (passedArgs[3] != null) {
                    currencyCode = getDefinedString(passedArgs[3]);
                }
                if (passedArgs[4] != null) {
                    refId = getDefinedString(passedArgs[4]);
                }
                if (passedArgs[5] != null) {
                    receipt = getDefinedString(passedArgs[5]);
                }
                if (passedArgs[6] != null) {
                    receiptSignature = getDefinedString(passedArgs[6]);
                }
                
                if (passedArgs[7] != null) {
                    attribute1 = getDefinedString(passedArgs[7]);
                }
                if (passedArgs[8] != null) {
                    attribute2 = getDefinedString(passedArgs[8]);
                }
                if (passedArgs[9] != null) {
                    attribute3 = getDefinedString(passedArgs[9]);
                }
                if (passedArgs[10] != null) {
                    attribute4 = getDefinedString(passedArgs[10]);
                }
                if (passedArgs[11] != null) {
                    attribute5 = getDefinedString(passedArgs[11]);
                }
                if (passedArgs[12] != null) {
                    contentId = getDefinedString(passedArgs[12]);
                }
                if (passedArgs[13] != null) {
                    contentType = getDefinedString(passedArgs[13]);
                }
                if (passedArgs[14] != null) {
                    String dateString = getDefinedString(passedArgs[14]);
                    
                    if (dateString.length() != 0) {
                        SimpleDateFormat sdf = new SimpleDateFormat(TuneExtensionContext.TUNE_DATE_TIME_FORMAT, Locale.ENGLISH);
                        sdf.setTimeZone(new SimpleTimeZone(SimpleTimeZone.UTC_TIME, "UTC"));
                        date1 = sdf.parse(dateString);
                    }
                }
                if (passedArgs[15] != null) {
                    String dateString = getDefinedString(passedArgs[15]);
                    
                    if (dateString.length() != 0) {
                        SimpleDateFormat sdf = new SimpleDateFormat(TuneExtensionContext.TUNE_DATE_TIME_FORMAT, Locale.ENGLISH);
                        sdf.setTimeZone(new SimpleTimeZone(SimpleTimeZone.UTC_TIME, "UTC"));
                        date2 = sdf.parse(dateString);
                    }
                }
                if (passedArgs[16] != null) {
                    level = passedArgs[16].getAsInt();
                }
                if (passedArgs[17] != null) {
                    quantity = passedArgs[17].getAsInt();
                }
                if (passedArgs[18] != null) {
                    rating = passedArgs[18].getAsDouble();
                }
                if (passedArgs[19] != null) {
                    searchString = getDefinedString(passedArgs[19]);
                }
                
                Log.i(TuneExtensionContext.TAG, "Call " + NAME);
                TuneExtensionContext tec = (TuneExtensionContext)context;
                
                TuneEvent tuneEvent = new TuneEvent(eventName)
                        .withEventItems(eventItems)
                        .withRevenue(revenue)
                        .withCurrencyCode(currencyCode)
                        .withAdvertiserRefId(refId)
                        .withReceipt(receipt, receiptSignature)
                        .withAttribute1(attribute1)
                        .withAttribute2(attribute2)
                        .withAttribute3(attribute3)
                        .withAttribute4(attribute4)
                        .withAttribute5(attribute5)
                        .withContentId(contentId)
                        .withContentType(contentType)
                        .withDate1(date1)
                        .withDate2(date2)
                        .withSearchString(searchString);
                if (level != 0) {
                    tuneEvent.withLevel(level);
                }
                if (quantity != 0) {
                    tuneEvent.withQuantity(quantity);
                }
                if (rating != 0) {
                    tuneEvent.withRating(rating);
                }
                
                tec.tune.measureEvent(tuneEvent);
                
                return FREObject.newObject(true);
            } catch (Exception e) {
                Log.d(TuneExtensionContext.TAG, "ERROR: " + e);
                e.printStackTrace();
            }
        }
        return null;
    }
    
    public String getDefinedString(FREObject arg) {
        String argString = "";
        try {
            argString = arg.getAsString();
            if (!argString.equals("undefined")) {
                return argString;
            }
        } catch (Exception e) {
        }
        return "";
    }

}
