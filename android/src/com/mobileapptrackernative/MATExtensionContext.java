package com.mobileapptrackernative;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Locale;
import java.util.Map;
import java.util.SimpleTimeZone;

import android.widget.RelativeLayout;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.mobileapptracker.MATGender;
import com.mobileapptracker.MobileAppTracker;
import com.tune.crosspromo.TuneAdMetadata;
import com.tune.crosspromo.TuneBanner;
import com.tune.crosspromo.TuneInterstitial;

public class MATExtensionContext extends FREContext {
    public static final String TAG = "MobileAppTrackerANE";
    public static final String MAT_DATE_TIME_FORMAT = "EEE MMM d HH:mm:ss yyyy zzz";
    public MobileAppTracker mat;
    public TuneBanner banner;
    public TuneInterstitial interstitial;
    public RelativeLayout layout;

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

        functionMap.put(SetAllowDuplicatesFunction.NAME, new SetAllowDuplicatesFunction());
        functionMap.put(SetAndroidIdFunction.NAME, new SetAndroidIdFunction());
        functionMap.put(SetAppAdTrackingFunction.NAME, new SetAppAdTrackingFunction());
        functionMap.put(SetCurrencyCodeFunction.NAME, new SetCurrencyCodeFunction());
        functionMap.put(SetDebugModeFunction.NAME, new SetDebugModeFunction());
        functionMap.put(SetExistingUserFunction.NAME, new SetExistingUserFunction());
        functionMap.put(SetFacebookEventLoggingFunction.NAME, new SetFacebookEventLoggingFunction());
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
        functionMap.put(SetPhoneNumberFunction.NAME, new SetPhoneNumberFunction());
        functionMap.put(SetAgeFunction.NAME,  new SetAgeFunction());
        functionMap.put(SetGenderFunction.NAME,  new SetGenderFunction());
        functionMap.put(SetLocationFunction.NAME,  new SetLocationFunction());
        functionMap.put(CheckForDeferredDeeplinkFunction.NAME, new CheckForDeferredDeeplinkFunction());
        
        // Cross-Promo functions
        functionMap.put(ShowBannerFunction.NAME, new ShowBannerFunction());
        functionMap.put(HideBannerFunction.NAME, new HideBannerFunction());
        functionMap.put(DestroyBannerFunction.NAME, new DestroyBannerFunction());
        functionMap.put(CacheInterstitialFunction.NAME, new CacheInterstitialFunction());
        functionMap.put(ShowInterstitialFunction.NAME, new ShowInterstitialFunction());
        functionMap.put(DestroyInterstitialFunction.NAME, new DestroyInterstitialFunction());
        
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

    public static TuneAdMetadata parseMetadata(FREObject asMetadata) {
        TuneAdMetadata metadata = new TuneAdMetadata();
        if (asMetadata != null) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(MATExtensionContext.MAT_DATE_TIME_FORMAT, Locale.ENGLISH);
                sdf.setTimeZone(new SimpleTimeZone(SimpleTimeZone.UTC_TIME, "UTC"));
                metadata.withBirthDate(sdf.parse(asMetadata.getProperty("birthDate").getAsString()));
            } catch (Exception e) {
            }
            try {
                HashMap<String, String> customTargets = new HashMap<String, String>();
                FREArray asCustomTargets = (FREArray) asMetadata.getProperty("customTargets");
                
                // Populate HashMap from FREArray of key-value pairs
                for (int i = 0; i < asCustomTargets.getLength(); i+=2) {
                    customTargets.put(asCustomTargets.getObjectAt(i).getAsString(), asCustomTargets.getObjectAt(i+1).getAsString());
                }
                metadata.withCustomTargets(customTargets);
            } catch (Exception e) {
            }
            try {
                metadata.withDebugMode(asMetadata.getProperty("debugMode").getAsBool());
            } catch (Exception e) {
            }
            try {
                int asGender = asMetadata.getProperty("gender").getAsInt();
                if (asGender == 0) {
                    metadata.withGender(MATGender.MALE);
                } else if (asGender == 1) {
                    metadata.withGender(MATGender.FEMALE);
                }
            } catch (Exception e) {
            }
            try {
                double latitude = asMetadata.getProperty("latitude").getAsDouble();
                double longitude = asMetadata.getProperty("longitude").getAsDouble();
                metadata.withLocation(latitude, longitude);
            } catch (Exception e) {
            }
            try {
                FREArray asKeywords = (FREArray) asMetadata.getProperty("keywords");
                HashSet<String> keywords = new HashSet<String>();
                // Populate ArrayList from FREArray of keywords
                for (int i = 0; i < asKeywords.getLength(); i++) {
                    keywords.add(asKeywords.getObjectAt(i).getAsString());
                }
                metadata.withKeywords(keywords);
            } catch (Exception e) {
            }
        }
        return metadata;
    }
}
