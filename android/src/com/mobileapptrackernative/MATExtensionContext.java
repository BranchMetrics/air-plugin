package com.mobileapptrackernative;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.mobileapptracker.MobileAppTracker;

public class MATExtensionContext extends FREContext {
    public static final String TAG = "MobileAppTrackerANE";
    public MobileAppTracker mat;
    
    @Override
    public void dispose() {
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

        functionMap.put(InitFunction.NAME, new InitFunction());
        functionMap.put(MeasureSessionFunction.NAME, new MeasureSessionFunction());
        functionMap.put(MeasureActionFunction.NAME, new MeasureActionFunction());
        functionMap.put(MeasureActionWithEventItemsFunction.NAME, new MeasureActionWithEventItemsFunction());

        functionMap.put(GetIsPayingUserFunction.NAME, new GetIsPayingUserFunction());
        functionMap.put(GetMatIdFunction.NAME, new GetMatIdFunction());
        functionMap.put(GetOpenLogIdFunction.NAME, new GetOpenLogIdFunction());
        functionMap.put(GetReferrerFunction.NAME, new GetReferrerFunction());

        functionMap.put(SetAllowDuplicatesFunction.NAME, new SetAllowDuplicatesFunction());
        functionMap.put(SetAppAdTrackingFunction.NAME, new SetAppAdTrackingFunction());
        functionMap.put(SetCurrencyCodeFunction.NAME, new SetCurrencyCodeFunction());
        functionMap.put(SetDebugModeFunction.NAME, new SetDebugModeFunction());
        functionMap.put(SetExistingUserFunction.NAME, new SetExistingUserFunction());
        functionMap.put(SetEventAttributeFunction.NAME, new SetEventAttributeFunction());
        
        functionMap.put(SetEventContentIdFunction.NAME, new SetEventContentIdFunction());
        functionMap.put(SetEventContentTypeFunction.NAME, new SetEventContentTypeFunction());
        functionMap.put(SetEventDate1Function.NAME, new SetEventDate1Function());
        functionMap.put(SetEventDate2Function.NAME, new SetEventDate2Function());
        functionMap.put(SetEventLevelFunction.NAME, new SetEventLevelFunction());
        functionMap.put(SetEventQuantityFunction.NAME, new SetEventQuantityFunction());
        functionMap.put(SetEventRatingFunction.NAME, new SetEventRatingFunction());
        functionMap.put(SetEventSearchStringFunction.NAME, new SetEventSearchStringFunction());
        
        functionMap.put(SetFacebookUserIdFunction.NAME, new SetFacebookUserIdFunction());
        functionMap.put(SetGoogleAdvertisingIdFunction.NAME, new SetGoogleAdvertisingIdFunction());
        functionMap.put(SetGoogleUserIdFunction.NAME, new SetGoogleUserIdFunction());
        functionMap.put(SetPackageNameFunction.NAME, new SetPackageNameFunction());
        functionMap.put(SetPayingUserFunction.NAME, new SetPayingUserFunction());
        functionMap.put(SetSiteIdFunction.NAME, new SetSiteIdFunction());
        functionMap.put(SetTRUSTeIdFunction.NAME,  new SetTRUSTeIdFunction());
        functionMap.put(SetTwitterUserIdFunction.NAME, new SetTwitterUserIdFunction());
        functionMap.put(SetUserEmailFunction.NAME, new SetUserEmailFunction());
        functionMap.put(SetUserIdFunction.NAME,  new SetUserIdFunction());
        functionMap.put(SetUserNameFunction.NAME, new SetUserNameFunction());

        functionMap.put(SetAgeFunction.NAME,  new SetAgeFunction());
        functionMap.put(SetGenderFunction.NAME,  new SetGenderFunction());
        functionMap.put(SetLocationFunction.NAME,  new SetLocationFunction());
        
        functionMap.put(StartAppToAppFunction.NAME, new StartAppToAppFunction());

        // iOS functions that are no-op on Android
        functionMap.put(iOSNoOpFunction.DELEGATE, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.JAILBROKEN, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.REDIRECT_URL, new iOSNoOpFunction());
        
        functionMap.put(iOSNoOpFunction.GEN_JAILBROKEN, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.GEN_VENDOR, new iOSNoOpFunction());
        
        functionMap.put(iOSNoOpFunction.GET_PARAMS, new iOSNoOpFunction());

        functionMap.put(iOSNoOpFunction.SET_ADVERTISER, new iOSNoOpFunction());
        functionMap.put(iOSNoOpFunction.SET_VENDOR, new iOSNoOpFunction());
        
        functionMap.put(iOSNoOpFunction.USE_COOKIE, new iOSNoOpFunction());

        return functionMap;
    }

}
