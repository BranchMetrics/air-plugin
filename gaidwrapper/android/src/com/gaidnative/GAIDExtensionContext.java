package com.gaidnative;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.ads.identifier.AdvertisingIdClient.Info;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;

public class GAIDExtensionContext extends FREContext {
    public static final String TAG = "GAIDANE";
    public Activity act;
    
    @Override
    public void dispose() {
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
        functionMap.put(GetGAIDFunction.NAME, new GetGAIDFunction());
        return functionMap;
    }
    
    public void getGaidThread() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Info adInfo = AdvertisingIdClient.getAdvertisingIdInfo(act.getApplicationContext());
                    
                    JSONObject gaidJson = new JSONObject();
                    try {
                        gaidJson.put("gaid", adInfo.getId());
                        gaidJson.put("isLAT", adInfo.isLimitAdTrackingEnabled());
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    dispatchStatusEventAsync("getGoogleAdvertisingId", gaidJson.toString());
                } catch (IOException e) {
                    // Unrecoverable error connecting to Google Play services (e.g.,
                    // the old version of the service doesn't support getting AdvertisingId).
                } catch (GooglePlayServicesNotAvailableException e) {
                    // Google Play services is not available entirely.
                } catch (GooglePlayServicesRepairableException e) {
                    // Encountered a recoverable error connecting to Google Play services.
                }
            }
        }).start();
    }
}
