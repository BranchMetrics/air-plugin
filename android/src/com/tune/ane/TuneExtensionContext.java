package com.tune.ane;

import java.util.HashMap;
import java.util.Map;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.tune.Tune;

public class TuneExtensionContext extends FREContext {
    public static final String TAG = "TuneANE";
    public static final String TUNE_DATE_TIME_FORMAT = "EEE MMM d HH:mm:ss yyyy zzz";
    public Tune tune;
    
    @Override
    public void dispose() {
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();

        functionMap.put(InitFunction.NAME, new InitFunction());
        functionMap.put(MeasureSessionFunction.NAME, new MeasureSessionFunction());
        functionMap.put(MeasureEventNameFunction.NAME, new MeasureEventNameFunction());
        functionMap.put(MeasureEventFunction.NAME, new MeasureEventFunction());

        functionMap.put(GetAdvertisingIdFunction.NAME, new GetAdvertisingIdFunction());
        functionMap.put(GetIsPayingUserFunction.NAME, new GetIsPayingUserFunction());
        functionMap.put(GetMatIdFunction.NAME, new GetMatIdFunction());
        functionMap.put(GetOpenLogIdFunction.NAME, new GetOpenLogIdFunction());
        functionMap.put(GetReferrerFunction.NAME, new GetReferrerFunction());

        functionMap.put(SetAndroidIdFunction.NAME, new SetAndroidIdFunction());
        functionMap.put(SetAppAdTrackingFunction.NAME, new SetAppAdTrackingFunction());
        functionMap.put(SetCurrencyCodeFunction.NAME, new SetCurrencyCodeFunction());
        functionMap.put(SetDebugModeFunction.NAME, new SetDebugModeFunction());
        functionMap.put(SetDeepLinkFunction.NAME, new SetDeepLinkFunction());
        functionMap.put(SetExistingUserFunction.NAME, new SetExistingUserFunction());
        functionMap.put(SetFacebookEventLoggingFunction.NAME, new SetFacebookEventLoggingFunction());
        functionMap.put(SetFacebookUserIdFunction.NAME, new SetFacebookUserIdFunction());
        functionMap.put(SetGoogleAdvertisingIdFunction.NAME, new SetGoogleAdvertisingIdFunction());
        functionMap.put(SetGoogleUserIdFunction.NAME, new SetGoogleUserIdFunction());
        functionMap.put(SetPackageNameFunction.NAME, new SetPackageNameFunction());
        functionMap.put(SetPayingUserFunction.NAME, new SetPayingUserFunction());
        functionMap.put(SetTRUSTeIdFunction.NAME,  new SetTRUSTeIdFunction());
        functionMap.put(SetTwitterUserIdFunction.NAME, new SetTwitterUserIdFunction());
        functionMap.put(SetUserEmailFunction.NAME, new SetUserEmailFunction());
        functionMap.put(SetUserIdFunction.NAME,  new SetUserIdFunction());
        functionMap.put(SetUserNameFunction.NAME, new SetUserNameFunction());
        functionMap.put(SetPhoneNumberFunction.NAME, new SetPhoneNumberFunction());
        functionMap.put(SetAgeFunction.NAME,  new SetAgeFunction());
        functionMap.put(SetGenderFunction.NAME,  new SetGenderFunction());
        functionMap.put(SetLocationFunction.NAME,  new SetLocationFunction());
        functionMap.put(CheckForDeferredDeeplinkFunction.NAME, new CheckForDeferredDeeplinkFunction());
        
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
